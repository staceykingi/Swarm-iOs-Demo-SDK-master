//
//  BLESTrackViewController.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.16..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//
//URL to download coupons - mock
#define mockCouponsUrl [NSURL URLWithString: @"http://requinsynergy.azurewebsites.net/ListQueries/listCoupons.aspx"]
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
//#define mockCouponsUrl [NSURL URLWithString: @"http://requinsynergy.azurewebsites.net/ListQueries/listCoupons.aspx"]
#define mySession [BLESDemoSession sharedManager]
#import "BLESTrackViewController.h"
#import "BLESDemoSession.h"
#import "SWARMAction.h"
#import "BLESQRViewController.h"

#import "BLESMock.h"
#import "SWARMUserProfile.h"
#import "SWARMActionsNearTVC.h"

#import "BLESBeaconContainer.h"
#import "SWARMBeacon.h"
#import "BLESBeaconsListViewController.h"

@interface BLESTrackViewController ()

@property (strong,nonatomic) BLESDemoRestApi *demoRestApi;
@property  (strong,nonatomic) NSArray *lastSeenBeacons;
@end

BLESBeaconContainer *beaconsContainer;

@implementation BLESTrackViewController
@synthesize managedObjectContext,demoRestApi;





- (void)viewDidLoad
{
    [super viewDidLoad];
	beaconsContainer = [[BLESBeaconContainer alloc]init];
    
    [self.uuidEdit setText:[mySession uuid]];
  

    [self setDemoRestApi:[[BLESDemoRestApi alloc]init]];
    [[self demoRestApi] setUsersRqCompleteDelegate:self];
    
    [self setLastSeenBeacons:[[NSArray alloc]init]];
 

    //---------------------
    //TODO: remove
    

    
  /*  SWARMAction *cp =[[SWARMAction alloc] init];
    
   [cp setDesc:@"This is a demo coupon"];
    [cp setPictureUrl:@"http://192.168.10.100/coupon.png"];
    [cp setTitle:@"Xmas great deals"];
    [cp setActionId:@"asdf1234" ];
    [cp setExpiration:[NSDate date]];

    [mySession setCurrentAction:cp];
   */
    //---------------------
    
    if ([mySession demoProfiles]==nil || [mySession usersLoaded]==NO) {
        [self refreshSegments];
    }
    else
    {
        [self recreateSegments:[mySession demoProfiles] ];

        [[self targetSelector]setSelectedSegmentIndex: [[mySession demoProfiles]indexOfObject:[mySession currentUser]]];
        [[self refreshSpinner]stopAnimating];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[mySession swarmSDK] setBeaconsChangeFoundDelegate:self];
  //  [[mySession swarmSDK] setWhereAmINotificationDelegate:self];
  //  [[mySession swarmSDK] setWhatIsHereNotificationDelegate:self];
    [[mySession swarmSDK] startMonitorBeaconsChange];
  //[[mySession swarmSDK] startWhereAmIService];
  //[[mySession swarmSDK] startWhatIsHereService];
    [_proximityUUIDLabel setText:[[mySession swarmSDK]uuidText]];
}

-(void)onBeaconsChangeFound:(BLESBeaconContainer*)beaconContainer
{
    //[self sendCustomerLocationEventsWithBeacons:[beaconContainer getNewBeacons]];
    [self.beaconsCount setText:[NSString stringWithFormat:@"%lu",(unsigned long)[[beaconContainer getBeacons]count]]];
    if ([[beaconContainer getBeacons] count]>0) {
        [self updateLabelsWithBeaconData:[[beaconContainer getBeacons] firstObject]];
        [self setLastSeenBeacons:[NSArray arrayWithArray: [beaconContainer getBeacons]]];
    }
    else{
        [self updateLabelsWithBeaconData:nil];
        
    }
    
}

-(void)onWhatIsHereNotificationReceived:(SWARMWhatIsHereInformation *)whatIsHereInfo withError:(NSError *)error
{
    NSLog(@"WhatIsHereNotification received");
}

-(void)onWhereAmINotificationReceived:(SWARMWhatIsHereInformation *)locationInfo withError:(NSError *)error
{
    NSLog(@"WhereAmINotification received");
}

-(void)onUsersRequestComplete:(NSMutableArray*)users
{
    NSLog(@"Delegate called hurray!");
    
    
 //  BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    [mySession setDemoProfiles:users];
    
    if (users==nil) {
        [[self refreshSpinner]stopAnimating];
//TODO: error msg?
    }
    
    //TODO: if 0, handle
    [self recreateSegments:users];
    [self.targetSelector setSelectedSegmentIndex:0 ];
    [mySession setCurrentUser:[users firstObject]];
    [[mySession swarmSDK]setSwarmId:[[users firstObject]customerSwarmId]];
    [[mySession swarmSDK]initRemoteId:[[users firstObject]remoteId]];

    [[self refreshSpinner]stopAnimating];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)recreateSegments:(NSMutableArray*)users
{
    //Recreate the segments from the new users list
    

    NSUInteger cnt = [[self targetSelector]numberOfSegments];
    for (NSUInteger ix = 0; ix < cnt; ix++) {
        [[self targetSelector]removeSegmentAtIndex:0 animated:NO];
    }
    
    
    //Insert the user names as segments, the indexes will be the same as in the array
    for (SWARMUserProfile *bup in users) {
        [[self targetSelector]insertSegmentWithTitle:[bup userName] atIndex:[_targetSelector numberOfSegments] animated:NO];
        //NSLog(@"Inserting segment with name %@, the index of the user is %u",[bup userName], [_targetSelector numberOfSegments]-1);
    }
   
    
    //SWARMUserProfile *selectedUser;
    //Is there a user among them with the given name?
   // for (SWARMUserProfile *up in users) {
        
    
  /*  if ([[up userName]isEqualToString:userName]) {
        //the given username is present in the list, so we store that user
        selectedUser = up;
    }
    */
    
    
/*   for (idx =0; idx < [[self targetSelector]numberOfSegments ];idx++) {
        if ([[[self targetSelector]titleForSegmentAtIndex:idx]isEqualToString:userName]) {
            break;
        }
    }
    */
    
    //if there is one, select this segment + update the current demoProfile in the session
    
    
//    [[self targetSelector]setSelectedSegmentIndex:idx];
 //  [[mySession swarmSDK]setSwarmId:[[mySession getUserByName:userName] customerSwarmId ]];
    
    
    //if not, select the first user from the list, and select the appropriate segment
    
    
}



- (void)refreshSegments
{
    //BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    [[self refreshSpinner]startAnimating];
    if (![[mySession reachabilityChecker] isOnline]) {
        NSLog(@"No connection.");

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to use this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [[self refreshSpinner]stopAnimating];
        return;
    }

   
    [self.demoRestApi sendUsersRequest];

}




-(NSString*)getSelectedSegmentName
{
    return [[self targetSelector]titleForSegmentAtIndex: [[self targetSelector]selectedSegmentIndex]];
}


- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    if (region==nil) {
        NSLog(@"Error: Region was nil");
        return;
    }
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}
- (IBAction)refreshProfilesClicked:(id)sender {
    [self refreshSegments];
}
- (IBAction)uuidChanged:(id)sender {
    //TODO: check if valid uuid
    @try
    {
         NSUUID *uuid = [[ NSUUID alloc] initWithUUIDString:[self.uuidEdit text]];
        if (uuid == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong uuid"
                                                            message:@"You must provide a valid uuid."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    @catch (NSException *e)
    {
         NSLog(@"Exception: %@", e);
        return;
    }
//    BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    [mySession setUuid:[self.uuidEdit text]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uuid changed"
                                                    message:@"The uuid was changed succesfully."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [self initRegion];
}

- (void)initRegion {

    //TI tag:
    //NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"87C6317B-0C99-2F4C-DE12-57E9E64F679A"];
    
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[self.uuidEdit text]];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.Sonrisa.myRegion"];
    self.beaconRegion.notifyOnEntry = YES;
    self.beaconRegion.notifyOnExit = YES;
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
    self.beaconRegion.notifyEntryStateOnDisplay = true;

    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}
- (IBAction)targetChenged:(UISegmentedControl *)sender {
    
    NSString *kateText = @"Kate is 16, and she loves fashion. She spends most of her money on clothes and shoes.";
    //NSString *tylerText = @"Tyler is 35, and he is full of life. He loves hiking, parties, and gaming consoles.";
    //NSString *anneText = @"Anne is a 45 years old, and loves to read books sitting next to the fireplace.";
//   BLESDemoSession *mySession = [BLESDemoSession sharedManager];

    
//    NSString *selectedName =  [[self targetSelector] titleForSegmentAtIndex: sender.selectedSegmentIndex ];
    SWARMUserProfile *up = [[mySession demoProfiles]objectAtIndex:sender.selectedSegmentIndex];
    
    if (up!=nil)
    {
        //[mySession setSelectedProfileId:[up customerSwarmId]];
        [self.targetDescription setText:[up desc]];
        [mySession setCurrentUser:up];
        [[mySession swarmSDK] setSwarmId: [up customerSwarmId]];
        [[mySession swarmSDK]initRemoteId:[up remoteId]];
        NSLog(@"Selected user with index %ld, name: %@",(long)sender.selectedSegmentIndex,[up userName]);
    }
    else
    {
       //[mySession setSelectedProfileId:@"yelp0123"];
       //TODO:assert? error?
        [self.targetDescription setText:kateText];
        //[mySession setCurrentUser:[mySession demoProfiles]]
    }
    
    
//TODO: use selected user    [self onUserChanged:[mySession ]]
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
   #if logCallstack
    NSLog(@">>> %s",__PRETTY_FUNCTION__);
#endif
    NSLog(@"Beacon Found");

   #if logCallstack
    NSLog(@"<<< %s",__PRETTY_FUNCTION__);
#endif
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Left Region");
    //[self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    //self.beaconFoundLabel.text = @"No";
    
    //nd reset that flag when you leave the region
    //_firstOneSeen = NO;
    //As a bonus, this will also make your monitoring response times much faster when your app is in the foreground. See: http://developer.radiusnetworks.com/2013/11/13/ibeacon-monitoring-in-the-background-and-foreground.html
}




-(void)updateLabelsWithBeaconData:(SWARMBeacon *)beacon
{
    #if logCallstack
  //  NSLog(@">>> updateLabelsWithBeaconData");
#endif
    Boolean isNear = false;
    if (beacon == nil) {
        self.majorLabel.text = @"Out of range";
        self.distanceLabel.text = @"";
        self.rssiLabel.text = @"";
        self.accuracyLabel.text = @"";
        self.beaconsCount.text = @"0";
        [[self findActionsBtn]setEnabled:NO ];
        return;
    }
    [[self findActionsBtn]setEnabled:YES ];
    //self.beaconFoundLabel.text = @"Yes";
    self.proximityUUIDLabel.text = beacon.proximityUUID.UUIDString;
    self.majorLabel.text = [NSString stringWithFormat:@"%@ : %@", [beacon major], [beacon minor]];
    //self.minorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
    self.accuracyLabel.text = [NSString stringWithFormat:@"%f", beacon.accuracy];
    if (beacon.proximity == CLProximityUnknown) {
        self.distanceLabel.text = @"Unknown Proximity";
    } else if (beacon.proximity == CLProximityImmediate) {
        self.distanceLabel.text = @"Immediate";
    } else if (beacon.proximity == CLProximityNear) {
        self.distanceLabel.text = @"Near";
        isNear = true;
    } else if (beacon.proximity == CLProximityFar) {
        self.distanceLabel.text = @"Far";
    }
    
    if (isNear) {
        // [self getCountryInfo];
    }
    
    self.rssiLabel.text = [NSString stringWithFormat:@"%i", beacon.rssi];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@, %i (db)", self.distanceLabel.text, beacon.rssi];
    
    #if logCallstack
   // NSLog(@"<<< updateLabelsWithBeaconData");
#endif
}




#pragma mark Networking
#pragma mark Data


- (IBAction)dbgActionClicked:(id)sender {
    //SettingsCreateAccount *detailViewController = [[SettingsCreateAccount alloc] initWithStyle:UITableViewStyleGrouped];
   
    //[detailViewController release];
    BLESQRViewController *qrvc = [[BLESQRViewController alloc] init];
  //  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:qrvc];
    
 //   navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
 //   [self presentModalViewController:navController animated:YES];
   
    
    //SettingsCreateAccount *detailViewController = [[SettingsCreateAccount alloc] initWithStyle:UITableViewStyleGrouped];
    qrvc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    qrvc.navigationController.navigationBarHidden = NO;
    [self.navigationController presentModalViewController:qrvc animated:YES];
   // qrvc = nil;
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 * Called when the demo user is changed
 * - Change current user details around the whole app
 * - Send a CustomerLocationEvent with the current beacon
 **/
-(void)onUserChanged:(SWARMUserProfile *)currentUser
{
    //Update session to mirror the new user's data
    
    
    
    //Check if we found any beacons near, if yes, send the CustomerLocationEvents with the new profile
  /*  if ([beaconsContainer getNewBeacons] != nil) {
        for (CLBeacon *bc in [beaconsContainer getNewBeacons]) {
            BLESRestApi *restApi = [[BLESRestApi alloc]init];
            BLESCustomerLocationEvent *cle = [[BLESCustomerLocationEvent alloc]init];
            
            [restApi sendCustomerLocationEvent:cle];
        }
    }*/

}


- (IBAction)onFindActionsClicked:(id)sender {
    [self.locationManager stopMonitoringForRegion:self.beaconRegion];
    [self performSegueWithIdentifier:@"listCouponsForLocationSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"listCouponsForLocationSegue"]){
        SWARMActionsNearTVC *controller = (SWARMActionsNearTVC*)segue.destinationViewController;
        [controller setMinor:[[[beaconsContainer getBeacons]lastObject]minor]];
        [controller setMajor:[[[beaconsContainer getBeacons]lastObject]major]];
    }
    
    if ([segue.identifier isEqualToString:@"listAllBeaconsSegue"]) {
        BLESBeaconsListViewController *controller = (BLESBeaconsListViewController*)segue.destinationViewController;
        [controller setBeaconsArray:[self lastSeenBeacons]];
    }
}


@end


#pragma mark JSON serialization

@interface NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:
(NSString*)urlAddress;
-(NSData*)toJSON;
@end

@implementation NSDictionary(JSONCategories)
+(NSDictionary*)dictionaryWithContentsOfJSONURLString:
(NSString*)urlAddress
{
    NSData* data = [NSData dataWithContentsOfURL:
                    [NSURL URLWithString: urlAddress] ];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

-(NSData*)toJSON
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;    
}


-(void) saveContext
{
    
   /* NSManagedObjectContext *context = [myAppDelegate managedObjectContext];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }*/
}



@end

#pragma mark -


