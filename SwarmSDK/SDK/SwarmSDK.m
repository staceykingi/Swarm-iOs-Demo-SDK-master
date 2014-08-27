//
//  SwarmSDK.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.31..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SwarmSDK.h"
#import "BLESRestApi.h"
#import "BLESBeaconContainer.h"
#import "BLESMock.h"
#import "SWARMLocationInformaion.h"
#import "SWARMBeacon.h"
#import <CommonCrypto/CommonHMAC.h>
#import <UIKit/UIKit.h>
#import "BLESUrldefinitions.h"

@interface SwarmSDK () <ActionForMeRequestCompleteDelegate, WhereAmIRequestCompletedDelegate, WhatIsHereRequestCompletedDelegate, ActionGenerationRequestCompleteDelegate, ActionReactionCompleteDelegate, SwarmLoginRequestCompletedDelegate>

@property (strong, nonatomic) BLESRestApi *restApi;
@property (strong, nonatomic) BLESBeaconContainer *beaconsContainer;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL regionMonitoringEnabled;
@property (strong, nonatomic) NSString *apiKey;
@property (strong, nonatomic) NSUUID* myUuid;
@property (nonatomic)  UIBackgroundTaskIdentifier backgroundTask;
@property (strong, nonatomic) NSString *partnerId;
@property (strong, nonatomic) NSString *remoteId;

@end

@implementation SwarmSDK
@synthesize restApi;
@synthesize partnerId, remoteId;
@synthesize beaconsContainer;
@synthesize beaconRegion;
@synthesize locationManager;
@synthesize monitorBeaconsChange;
@synthesize swarmId;
@synthesize whatIsHereServiceEnabled;
@synthesize whereAmIServiceEnabled;
@synthesize showNotificationEnabled;

@synthesize whereAmINotificationDelegate;
@synthesize whatIsHereNotificationDelegate;
@synthesize version;
@synthesize swarmLoginCompletedDelegate;
@synthesize myUuid;
@synthesize backgroundTask;

- (id)init
{
    self = [super init];
    if (self) {
        [self setRestApi:[[BLESRestApi alloc]init]];
        [self setBeaconsContainer:[[BLESBeaconContainer alloc]init]];
        [self setWhatIsHereServiceEnabled:NO];
        [self setWhereAmIServiceEnabled:NO];
        [self setRegionMonitoringEnabled:NO];
        [self setMonitorBeaconsChange:NO];
        
        [self setShowNotificationEnabled:NO];
        
        [self setSwarmId:nil];
        [[self restApi] setActionForMeRequestDelegate:self];
        [[self restApi] setWhereAmIRequestCompletedDelegate:self];
        [[self restApi] setWhatIsHereRequestCompletedDelegate:self];
        [[self restApi] setActionReactionCompleteDelegate:self];
        [[self restApi] setActionGenerationRequestCompleteDelegate:self];
        [[self restApi] setSwarmLoginRequestCompletedDelegate:self];
        [self setBackgroundTask:UIBackgroundTaskInvalid];
        [self setUseLongJobForBackgroundRequests:NO];
        
        NSString *compileDate = [NSString stringWithUTF8String:__DATE__];
        NSLog(@"SwarmSDK v1.3 - %@ init - logCallTrace: %d - logRest: %d",compileDate,logCallTrace,logRest);
        [self setVersion: compileDate];
    }
    return self;
}

-(id)initWithApiKey:(NSString*)apiKeyP withSwarmUUID:(NSUUID*)uuidP withPartnerId:(NSString*)partnerIdP withRemoteId:(NSString*)remoteIdP
{
    self = [self init];
    if (self) {
        [self setSwarmApiKey:apiKeyP];
        [self setSwarmUuid:uuidP];
        
        [self initPartnerId:partnerIdP];
        [self initRemoteId:remoteIdP];
        
    }
    return self;
    
}

-(NSString*)getPartnerId
{
    return [self partnerId];
}

-(NSString*)getRemoteId
{
    return [self remoteId];
}

-(NSString*)uuidText
{
    return [myUuid UUIDString];
}

-(BOOL)setSwarmUuid:(NSUUID*)uuid
{
    [self setMyUuid:uuid];
    [self initRegionWithUuid:uuid];
    
    return YES;
}

-(void)setSwarmApiKey:(NSString *)key
{
    [self setApiKey:key];
    [[self restApi]setSwarmApiKey:key];
    [self getSignature:@"SwarmSDK api key set"];
}


#pragma mark Implementation of visible service calls

-(BOOL)startWhereAmIService
{
    if (![self regionMonitoringEnabled]) {
        //start monitoring
        [self initRegionWithUuid:[self myUuid]];
    }
    [self setWhereAmIServiceEnabled:YES];
    
    return YES;
}

-(BOOL)startWhatIsHereService
{
    if (![self regionMonitoringEnabled]) {
        //start monitoring
        [self initRegionWithUuid:[self myUuid]];
    }
    [self setWhatIsHereServiceEnabled:YES];
    
    return YES;
    
}

-(BOOL)startMonitorBeaconsChange
{
    if (![self regionMonitoringEnabled]) {
        //start monitoring
        [self initRegionWithUuid:[self myUuid]];
    }
    [self setMonitorBeaconsChange:YES];
    
    return YES;
    
}

-(BOOL)doSwarmLogin:(SWARMUserProfile*)profile
{
    //check, if the profile is not nil
    if (profile==nil) {
        return NO;
    }
    
    //is the customerId, vendorId, advertiserId set?
    if ([profile partnerId]==nil || [profile remoteId]==nil ) {
        return NO;
    }
    
    [[self restApi]sendSwarmLoginRequest:profile];
    
    
    return YES;
}

-(void)requestActionForUser:(NSString *)swarmIdP forCampaign:(NSString *)campaignId
{
    [[self restApi] requestActionForCampaign:campaignId forSwarmId:swarmIdP withRemoteId: remoteId withPartnerId: partnerId];
}

-(void)reactToActionForUser:(NSString *)swarmIdP forAction:(NSString *)couponId withReaction:(BOOL)accepted
{
    [[self restApi] reactToAction:couponId acceptAction:accepted forUser:swarmIdP];
}

-(void)requestForMe:(NSString *)swarmIdP
{
    [[self restApi]sendActionForMeRequestForUser:swarmIdP];
    
}

-(void)onActionReactionComplete:(NSData *)responseData withError:(NSError *)error
{
    if ([self.reactToActionCompletedDelegate respondsToSelector:@selector(onReactToActionCompleted:withError:)]) {
        [self.reactToActionCompletedDelegate onReactToActionCompleted:responseData withError:error];
    }
}

#pragma mark -


#pragma mark Beacon tracking

- (void)initRegionWithUuid:(NSUUID*)uuid {
    
    // we don't need to start tracking for nil uuid.
    if (!uuid)
        return;
    
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:beaconIdentifier];
    self.beaconRegion.notifyOnEntry = beaconNotifyOnEntry;
    self.beaconRegion.notifyOnExit = beaconNotifyOnExit;
    self.beaconRegion.notifyEntryStateOnDisplay = NO;
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    
    if (self.beaconRegion==nil) {
        NSLog(@"Error in initRegionWithUuid: BeaconRegion was nil");
        return;
    }
    
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager requestStateForRegion:self.beaconRegion];
    
    [self setRegionMonitoringEnabled:YES];
    
}


- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    
    NSLog(@"didDetermineState called : %ld", (long)state);
    
    // A user can transition in or out of a region while the application is not running.
    // When this happens CoreLocation will launch the application momentarily, call this delegate method
    // and we will let the user know via a local notification.
    
    if ([self.regionStateChangedDelegate respondsToSelector:@selector(onRegionStateChanged:withState:withConditoin:)])
    {
        // notify the state change to the delegate.
        if ( self.showNotificationEnabled == YES )
            [self.regionStateChangedDelegate onRegionStateChanged:region withState:state withConditoin:true];
        
        if (state == CLRegionStateInside)
            [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
        else if (state == CLRegionStateOutside)
            [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
    else
    {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        if(state == CLRegionStateInside)
        {
            notification.alertBody = @"Hello Brady, you're inside the Collect store";
            [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
            
            
            //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://requestb.in/1claq7t1"]  cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            
             NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.collectrewardsapp.com/api/v2/PerformMemberCheckin?merchantId=2&memberId=992"]  cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            
            [request setHTTPMethod:@"GET"];
            [request setHTTPBody:[@"Matt has CHECKED IN" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            if (theConnection) {
                NSLog(@"Yeah buddy");
            }
            
            
        }
        else if(state == CLRegionStateOutside)
        {
            notification.alertBody = @"Brady, you're outside the Collect store";
            [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
            
            //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://requestb.in/1claq7t1"]  cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            
             NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.collectrewardsapp.com/api/v2/PerformMemberCheckout?merchantId=2&memberId=992"]  cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            
            [request setHTTPMethod:@"GET"];
            [request setHTTPBody:[@"Brady has CHECKED OUT" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            if (theConnection) {
                NSLog(@"Yeah buddy 2");
            }

        }
        else
        {
            return;
        }
        
        // If the application is in the foreground, it will get a callback to application:didReceiveLocalNotification:.
        // If its not, iOS will display the notification to the user.
        
        if ( self.showNotificationEnabled == YES )
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
    
    // What is this?
    //    if (state == UIApplicationStateBackground || state == UIApplicationStateInactive)
    //    {
    //        NSString *customURL = @"swarmSDKdemo://";
    //        //  NSString *customURL = @"iOSDevTips2://";
    //
    //
    //        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:customURL]])
    //        {
    //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
    //            NSLog(@"Calling app url");
    //        }
    //        else
    //        {
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URL error"
    //                                                            message:[NSString stringWithFormat:@"No custom URL defined for %@", customURL]
    //                                                           delegate:self cancelButtonTitle:@"Ok"
    //                                                  otherButtonTitles:nil];
    //            [alert show];
    //            NSLog(@"Could not launch url");
    //        }
    //    }
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    TraceLog(@">>>SwarmSDK - didRangeBeacons:inRegion");
    
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    if (state != UIApplicationStateActive && self.backgroundTask == UIBackgroundTaskInvalid) {
        
        // If app is in background, we need to run the background task.
        // Anyhow, we have at most 3 minutes(= UIMinimumKeepAliveTimeout) to run in the background.
        // We(or App providers) need to notify users that they need to open the app.
        [self beginBackgroundTask];
    }
    
    // we don't need to handle the services if we don't have sufficient time to complete them.
    if ([UIApplication sharedApplication].backgroundTimeRemaining < 10)
        return;
    
    [self.beaconsContainer updateBeacons:beacons];
    NSMutableArray *immediateBeacons = [self.beaconsContainer getBeacons];
    NSMutableArray *newBeacons = [self.beaconsContainer getNewBeacons];
    
    
    BLESBeaconContainer *currentContainer = [[BLESBeaconContainer alloc] init];
    [currentContainer setBeacons:immediateBeacons];
    [currentContainer setNewBeacons:newBeacons];
    
    // We need to handle WhatIsHere/WhereAmI services if the app is running on foreground.
    
    if ([self whatIsHereServiceEnabled]) {
        [self handleWhatIsHere: manager didRangeBeacons:currentContainer inRegion:region];
    }
    
    //If WhereAmI service is enabled, call it
    // TODO: first update the beacons, filter them and use the filtered list?
    if ([self whereAmIServiceEnabled]) {
        [self handleWhereAmI:manager didRangeBeacons:currentContainer inRegion:region];
    }
    
    if ([self monitorBeaconsChange]) {
        [self handleBeaconsChange:manager didRangeBeacons:currentContainer inRegion:region];
    }
}


/**
 * This handler gives back the beacon objects' list when a change happens
 * Does not contact the server
 **/
-(void)handleBeaconsChange:(CLLocationManager *)manager didRangeBeacons:(BLESBeaconContainer *)beaconsContainerP inRegion:(CLBeaconRegion *)region {
    if ([self.beaconsChangeFoundDelegate respondsToSelector:@selector(onBeaconsChangeFound:)]) {
        [self.beaconsChangeFoundDelegate onBeaconsChangeFound:beaconsContainerP];
    }
}


/**
 * WhatIsHere request for the seen beacons
 
 -(void)sendCustomerLocationEventsWithBeacons:(NSArray *)beaconsArray
 {
 if (beaconsArray==nil) {
 return;
 }
 BLESRestApi *restApi = [[BLESRestApi alloc]init];
 
 for (CLBeacon *bc in beaconsArray) {
 
 if ([bc proximity] != CLProximityImmediate) {
 NSLog(@"Proximity is not near enough, skipping.");
 continue;
 }
 else
 {
 NSLog(@"Beacon is immediate");
 }
 BLESCustomerLocationEvent *cle = [BLESMock getCustomerLocationEventSample];
 [cle setMajor:[bc major]];
 [cle setMinor:[bc minor]];
 //TODO: cle from beacon and user
 NSLog([NSString stringWithFormat:@"New beacon in range - %@:%@",[bc major], [bc minor]]);
 [restApi sendCustomerLocationEvent:cle];
 }
 }
 **/

-(void)onActionGenerationRequestComplete:(NSMutableArray*)coupons withError:(NSError*)error
{
    if ([self.requestActionCompletedDelegate respondsToSelector:@selector(onRequestActionCompleted:withError:)]) {
        [self.requestActionCompletedDelegate onRequestActionCompleted:coupons withError:error];
    }
}

-(NSString*)beaconsListToJSONString:(NSArray*)beaconsList
{
    //Create the json to send in
    NSError *error;
    
    NSMutableArray *tmpBeacons = [[NSMutableArray alloc]init];
    
    
    for (SWARMBeacon *bc in beaconsList) {
        NSDictionary *bcDict = @{@"minor":[bc minor],
                                 @"major":[bc major],
                                 @"rssi": [NSNumber numberWithInteger: [bc rssi]],
                                 @"uuid": [[bc proximityUUID] UUIDString],
                                 @"pr": [bc proximityLetter],
                                 @"prex": [bc proximityOld],
                                 @"latitude":[NSNumber numberWithDouble:locationManager.location.coordinate.latitude],
                                 @"longitude":[NSNumber numberWithDouble:locationManager.location.coordinate.longitude],
                                 @"accuracy":[NSNumber numberWithDouble:[bc accuracy]]
                                 };
        [tmpBeacons addObject:bcDict];
    }
    NSDictionary *toSend = @{@"locations":tmpBeacons};
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:toSend
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *tmpJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return tmpJson;
}


/**
 * Calls the WhereAmI service. The callback will tell the location details for the seen beacons.
 **/
-(void)handleWhereAmI:(CLLocationManager *)manager didRangeBeacons:(BLESBeaconContainer *)beaconsContainerP inRegion:(CLBeaconRegion *)region
{
    TraceLog(@">>> SwarmSDK - handleWhereAmI");
    //This function gets the list of visible beacons, so send them into the server to receive a list of locations when new beacon shows up
    if ([[beaconsContainerP getNewBeacons]count]==0) {
        //   NSLog(@"No change in visible beacons list.");
        return;
    }
    
    
    
    
    //Create the json to send in
    NSString *tmpJson = [self beaconsListToJSONString:[beaconsContainerP getBeacons]];
    RestLog(@"Visible beacon list changed, firing WhereAmI request with json: %@",tmpJson);
    //REST Call....
    [[self restApi]sendWhereAmIRequest:tmpJson isPersonalized:NO withUserId:@"none" withRemoteId:@"none" withPartnerId:[self partnerId]];
    
    
}

-(void)onWhereAmIRequestCompleted:(NSData *)responseData withError:(NSError *)error
{
    TraceLog(@">>> swarmSDK - onWhereAmIRequestCompleted");
    //check if data is not nil
    if (responseData==nil || error !=nil) {
        if ([self.whereAmINotificationDelegate respondsToSelector:@selector(onWhereAmINotificationReceived:withError:)]) {
            [self.whereAmINotificationDelegate onWhereAmINotificationReceived:nil withError:error];
        }
        
        return;
    }
    
    //parse response data, and create LocationInfo object
    
    //parse out the json data
    NSError* parseError;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&parseError];
    
    if (parseError !=nil) {
        if ([self.whereAmINotificationDelegate respondsToSelector:@selector(onWhereAmINotificationReceived:withError:)]) {
            [self.whereAmINotificationDelegate onWhereAmINotificationReceived:nil withError:parseError];
        }
        TraceLog(@"<<< parseerror");
        return;
    }
    
    NSArray* nearCampaigns = [json objectForKey:@"campaigns"];
    RestLog(@"received data: %@", nearCampaigns);
    NSMutableArray *campaigns = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *cp in nearCampaigns) {
        BLESCampaign *tmpCampaign = [BLESCampaign fromDictionary:cp];
        [campaigns addObject:tmpCampaign];
    }
    
    NSArray* addresses = [json objectForKey:@"locations"];
    
    NSMutableArray *locations = [[NSMutableArray alloc]init];
    for (NSDictionary *loc in addresses) {
        SWARMLocationInformaion *li = [SWARMLocationInformaion locationInformationFromDictionary:loc hasBeaconInfo:YES hasGeodata:YES];
        [locations addObject:li];
    }
    
    
    SWARMWhatIsHereInformation *wihi = [[SWARMWhatIsHereInformation alloc]init];
    [wihi setLocations:locations];
    //Fire the callback of the request:
    if ([self.whereAmINotificationDelegate respondsToSelector:@selector(onWhereAmINotificationReceived:withError:)]) {
        [self.whereAmINotificationDelegate onWhereAmINotificationReceived:wihi withError:nil];
    }
    
    TraceLog(@"<<< swarmSDK - onWhereAmIRequestCompleted");
}

-(void)handleWhatIsHere:(CLLocationManager *)manager didRangeBeacons:(BLESBeaconContainer *)beaconsContainerP inRegion:(CLBeaconRegion *)region
{
    TraceLog(@">>> swarmSDK - handleWhatIsHere");
    //This function gets the list of visible beacons, so send them into the server to receive a list of locations when new beacon shows up
    if ([[beaconsContainerP getNewBeacons]count]==0) {
        // NSLog(@"No change in visible beacons list.");
        TraceLog(@"<<<");
        return;
    }
    else
    {
        TraceLog(@"Visible beacon list changed, firing WhereAmI request...");
    }
    
    //Create the json to send in
    NSString *tmpJson = [self beaconsListToJSONString:[beaconsContainerP getBeacons]];
    
    RestLog(@"%@",tmpJson);
    //REST Call....
    [[self restApi]sendWhereAmIRequest:tmpJson isPersonalized:YES withUserId:[self swarmId] withRemoteId: [self remoteId] withPartnerId:[self partnerId]];
    TraceLog(@"<<< swarmSDK - handleWhatIsHere");
    
}

-(void)onWhatIsHereRequestCompleted:(NSData*)responseData withError:(NSError*)error
{
    TraceLog(@">>> swarmSDK - onWhatIsHereCompleted");
    //check if data is not nil
    if (responseData==nil) {
        if ([self.whatIsHereNotificationDelegate respondsToSelector:@selector(onWhatIsHereNotificationReceived:withError:)]) {
            [self.whatIsHereNotificationDelegate onWhatIsHereNotificationReceived:nil withError:error];
        }
        TraceLog(@"<<< swarmSDK - onWhatIsHereCompleted response was nil");
        return;
    }
    
    //parse response data, and create LocationInfo object
    
    //parse out the json data
    NSError* parseError;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&parseError];
    if (parseError!=nil) {
        if ([self.whatIsHereNotificationDelegate respondsToSelector:@selector(onWhatIsHereNotificationReceived:withError:)]) {
            [self.whatIsHereNotificationDelegate onWhatIsHereNotificationReceived:nil withError:parseError];
        }
        TraceLog(@"<<< swarmSDK - onWhatIsHereCompleted parseError");
    }
    
    
    
    NSArray* nearCampaigns = [json objectForKey:@"campaigns"];
    RestLog(@"WhatIsHere received data: %@", nearCampaigns);
    NSMutableArray *campaigns = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *cp in nearCampaigns) {
        BLESCampaign *tmpCampaign = [BLESCampaign fromDictionary:cp];
        [campaigns addObject:tmpCampaign];
    }
    
    NSArray* addresses = [json objectForKey:@"locations"];
    
    NSMutableArray *locations = [[NSMutableArray alloc]init];
    for (NSDictionary *loc in addresses) {
        SWARMLocationInformaion *li = [SWARMLocationInformaion locationInformationFromDictionary:loc hasBeaconInfo:YES hasGeodata:YES];
        [locations addObject:li];
    }
    
    NSMutableArray *coupons = [[NSMutableArray alloc]init];
    NSArray *fetchedCoupons = [json objectForKey:@"coupons"];
    for (NSDictionary *cp in fetchedCoupons)
    {
        SWARMAction *tmpCoupon = [SWARMAction fromDictionary:cp];
        [coupons addObject:tmpCoupon];
    }
    
    
    //Set up location->campaigns references
    for (SWARMLocationInformaion *loci in locations) {
        for (BLESCampaign *blesc in campaigns) {
            if ([[blesc locationId]isEqualToValue:[loci dbid]]) {
                [[loci campaigns]addObject:blesc];
            }
        }
    }
    
    for (BLESCampaign *blesc in campaigns) {
        for (SWARMAction *swac in coupons) {
            if ([[swac campaignId] intValue] == [[blesc campaignId] intValue])
                [[blesc coupons] addObject:swac];
        }
    }
    
    
    SWARMWhatIsHereInformation *wihi = [[SWARMWhatIsHereInformation alloc]init];
    [wihi setLocations:locations];
    // [wihi setCampaigns:campaigns];
    // [wihi setActions:coupons];
    //Fire the callback of the request:
    if ([self.whatIsHereNotificationDelegate respondsToSelector:@selector(onWhatIsHereNotificationReceived:withError:)]) {
        [self.whatIsHereNotificationDelegate onWhatIsHereNotificationReceived:wihi withError:nil];
    }
    
    TraceLog(@"<<< swarmSDK - onWhatIsHereCompleted");
}

-(void)onSwarmLoginRequestCompleted:(SWARMUserProfile*)responseData withError:(NSError *)error
{
    if ([self.swarmLoginCompletedDelegate respondsToSelector:@selector(onSwarmLoginCompleted:withError:)]) {
        [self.swarmLoginCompletedDelegate onSwarmLoginCompleted:responseData withError:error];
    }
}

#pragma mark - Background Task

- (void) beginBackgroundTask {
    
    [self endBackgroundTask];
    
    __weak typeof (self) wself = self;
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [wself endBackgroundTask];
    }];
}

- (void) endBackgroundTask {
    if (self.backgroundTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }
}

#pragma mark -

-(void)onActionForMeRequestComplete:(NSMutableArray *)coupons withError:(NSError*)error
{
    if ([self.requestForMeCompletedDelegate respondsToSelector:@selector(onRequestForMeCompleted:withError:)]) {
        [self.requestForMeCompletedDelegate onRequestForMeCompleted:coupons withError:error];
    }
}

-(NSString*)getSignature:(NSString*)textToSign
{
    return [[self restApi]getHMACSignature:(NSString*)textToSign withSalt:[self apiKey]];
}

-(void)initPartnerId:(NSString*)partnerIdP
{
    [[self restApi]setPartnerId:partnerIdP];
    [self setPartnerId:partnerIdP];
}

-(void)initRemoteId:(NSString*)remoteIdP
{
    [[self restApi]setRemoteId:remoteIdP];
    [self setRemoteId:remoteIdP];
}

@end
