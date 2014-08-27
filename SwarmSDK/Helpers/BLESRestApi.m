//
//  BLESRestApi.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.17..
//  Copyright (c) 2013 Swarm. All rights reserved.
//
#pragma mark Defines for readability
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#ifdef DEBUG
#define _AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES_
#endif

#pragma mark URL setup


#pragma mark Header imports

/**
 * Import headers
 **/
#import "BLESRestApi.h"
#import "SWARMAction.h"
#import "SWARMActionReaction.h"
#import "BLESUrlDefinitions.h"
#import "BLESBeacon.h"
#import "SWARMUserProfile.h"
#import "BLESCampaign.h"
#import "BLESWhereAmIRestHelper.h"
#import "BLESWhatIsHereRestHelper.h"
#import "SWARMActionReactionRequestHelper.h"
#import "BLESReachabilityChecker.h"
#import "BLESRequestActionForCampaignRestHelper.h"
#import "SWARMActionForMeRequestRestHelper.h"
#import "BLESSwarmLoginRestHelper.h"
#import "SWARMHmacHelper.h"

#pragma mark -
@interface BLESRestApi ()

@end
#pragma mark REST part implementation
@implementation BLESRestApi
@synthesize apiKey;
@synthesize whatIsHereRequestCompletedDelegate, whereAmIRequestCompletedDelegate;
@synthesize whatIsHereRestHelper;
@synthesize whereAmIRestHelper;
@synthesize actionReactionCompleteDelegate;
@synthesize actionReactionHelper;
@synthesize reachabilityChecker;
@synthesize partnerId,remoteId;
@synthesize requestActionForCampaignRestHelper,actionForMeRequestRestHelper,swarmLoginRestHelper;
@synthesize swarmLoginRequestCompletedDelegate;
-(id)init
{
    self=[super init];
    if (self) {
        [self setReachabilityChecker:[[BLESReachabilityChecker alloc]init]];
        [self setPartnerId:@""];
        [self setRemoteId:@""];

    }
    return self;
}

-(void)setSwarmApiKey:(NSString*)key
{
    [self setApiKey:key];
    NSLog(@"Signature: %@",[self getHMACForPartner:[self partnerId] forUserId:[self remoteId] withTimestamp:[NSDate date]]);
}

#pragma mark Data


-(void)sendSwarmLoginRequest:(SWARMUserProfile*)profile
{
    //swarmApi validates the content before passing it here...
    if (profile==nil) {
        return;
    }
    
    RestLog(@"Sending swarmLoginRequest to %@",urlPostSwarmLogin);

    NSURL *targetUrl = [NSURL URLWithString:urlPostSwarmLogin];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:targetUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    [self setRequestHeader:request withUserId:[profile remoteId] withPartnerId:[profile partnerId]];

    
    NSMutableData *requestData = [NSMutableData data];
    
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
     [requestData appendData:[[NSString stringWithString:[profile toJson]] dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableString *jostr = [NSMutableString stringWithString:@"Content-Type: application/json"];
    [jostr appendString:[profile toJson]];
    
    [request setHTTPBody: requestData];
    
    RestLog(@"SwarmLogin request data: %@",[profile toJson]);

    NSURLConnection *connection;
    
    if ([self swarmLoginRestHelper]==nil) {
        [self setSwarmLoginRestHelper:[[BLESSwarmLoginRestHelper alloc]init] ];
        [(BLESSwarmLoginRestHelper*)[self swarmLoginRestHelper] setRestApi:self];
    }
    
    connection= [[NSURLConnection alloc]initWithRequest:request delegate:swarmLoginRestHelper];
    
    [connection start];

    
}


-(BOOL) sendJsonRequest:(NSURL *)targetUrl withRequest:(NSString *)jsonRequest withRemoteId:(NSString*)remoteIdP withPartnerId:(NSString*)partnerIdP
{
    
    TraceLog(@">>> sendJsonRequest");
    //NSURL *url = [NSURL URLWithString:@"http://192.168.10.100:88/swarm.asp"];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:targetUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    [self setRequestHeader:request withUserId:remoteIdP withPartnerId:partnerIdP];
    NSMutableData *requestData = [NSMutableData data];
    [requestData appendData:[[NSString stringWithString:jsonRequest] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableData* receivedData;
    
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    
    NSMutableString *jostr = [NSMutableString stringWithString:@"Content-Type: application/json"];
    [jostr appendString:jsonRequest];
    
    [request setHTTPBody: requestData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        receivedData = [NSMutableData data];
        
        //TODO: maybe a callback could be handy?

        RestLog(@"%@",jsonRequest);
        RestLog(@"data POST-ed");

        if ([self.replyForJsonRequestArrivedDelegate respondsToSelector:@selector(onJsonPostRequestComplete:)]) {
            [self.replyForJsonRequestArrivedDelegate onJsonPostRequestComplete:receivedData ];
        }

    }
    
    TraceLog(@"<<< sendJsonRequest");
    
    return TRUE;
}


/**
 * React to a coupon - accept or reject, depending on 'accepted'
 **/
-(BOOL)reactToAction:(NSString *)actionId acceptAction:(BOOL)accepted forUser:(NSString *)userId
{

    TraceLog(@">>> reactToAction");

    SWARMActionReaction *blcr;
    if (accepted) {
        blcr = [SWARMActionReaction getAcceptCommandWithUserId:userId];
        NSLog(@"coupon accepted");
    }
    else
    {
        blcr = [SWARMActionReaction getRejectCommandWithUserId:userId];
        NSLog(@"coupon rejected");
    }
    
#if useMockUrls
    NSString *fullUrl =[NSString stringWithFormat:@"%@%@", urlPostReactionForCoupon,couponId];
    NSURL *url = [NSURL URLWithString:fullUrl];
#else
    NSString *fullUrl =[NSString stringWithFormat:@"%@%@", urlPostReactionForCoupon,actionId];
    NSURL *url = [NSURL URLWithString:fullUrl];
#endif
    
    RestLog(@"%@",fullUrl);
    
    if ([self actionReactionHelper]==nil) {
        [self setActionReactionHelper:[[SWARMActionReactionRequestHelper alloc]init]];
        [(SWARMActionReactionRequestHelper*)[self actionReactionHelper]setRestApi:self ];
    }
    
    NSString *jsonRequest = [blcr toJson];
    

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    [self setRequestHeader:request withUserId:[self remoteId] withPartnerId:[self partnerId]];
    NSMutableData *requestData = [NSMutableData data];
    [requestData appendData:[[NSString stringWithString:jsonRequest] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    
    NSMutableString *jostr = [NSMutableString stringWithString:@"Content-Type: application/json"];
    [jostr appendString:jsonRequest];
    
    [request setHTTPBody: requestData];
    
    NSURLConnection *connection;

    connection= [[NSURLConnection alloc]initWithRequest:request delegate:actionReactionHelper];

    RestLog(@"%@",jsonRequest);

    [connection start];

    TraceLog(@"<<< reactToAction");
    
    return TRUE;
}

#pragma mark -


#pragma mark Get copons from server
#pragma mark -

#pragma mark Authentication

#pragma mark -




#pragma mark Get coupon wallet from the server
- (BOOL)sendActionForMeRequestForUser:(NSString*)userId {
    
    //TODO:reachability msg
    if ([[self reachabilityChecker]isOnline]!=YES) {
        NSLog(@"No connection.");
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
         message:@"You must be connected to the internet to use this app."
         delegate:nil
         cancelButtonTitle:@"OK"
         otherButtonTitles:nil];
         [alert show];
         */
        
        return NO;
    }

    RestLog(@"ActionForMe - Sending Request...");
    
    
#if useMockUrls
    NSString *fullUrl = [NSString stringWithFormat:@"%@?userid=%@",mockCouponsUrl,userId];
#else
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@",urlBaseGetWallet,userId];
#endif

    
    RestLog(@"%@",fullUrl);

    NSMutableURLRequest *request = [self getAuthenticatedGETRequestForUrl:[NSURL URLWithString:fullUrl] withUserId:remoteId withPartnerId:partnerId];
    
    if ([self actionForMeRequestRestHelper]==nil) {
        [self setActionForMeRequestRestHelper:[[SWARMActionForMeRequestRestHelper alloc]init]];
        [(SWARMActionForMeRequestRestHelper*)[self actionForMeRequestRestHelper]setRestApi:self];
    }
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:actionForMeRequestRestHelper];
    
    [connection start];
    
    return YES;
}


- (BOOL)sendActionWalletRequestForUserOld:(NSString*)userId {
    
 //TODO:reachability msg
    if ([[self reachabilityChecker]isOnline]!=YES) {
        NSLog(@"No connection.");
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to use this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        */

        return NO;
    }
    
    RestLog(@"ActionWalletOld - Sending Request...");
    
#if useMockUrls
    NSString *fullUrl = [NSString stringWithFormat:@"%@?userid=%@",mockCouponsUrl,userId];
#else
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@",urlBaseGetWallet,userId];
#endif
    
    RestLog(@"%@",fullUrl);

    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fullUrl]];
        [self performSelectorOnMainThread:@selector(fetchedActionForMeData:)
                               withObject:data waitUntilDone:YES];
    });
    return YES;
}

- (NSMutableArray *)fetchedActionForMeData:(NSData *)responseData {
    if (responseData==nil) {
     /*   NSLog(@"BLESCouponListViewController - No data received.");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No data received"
                                                        message:@"The server did not return any data. Please, try again later."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
       */
        
        if ([self.actionForMeRequestDelegate respondsToSelector:@selector(onActionForMeRequestComplete:withError:)]) {
            [self.actionForMeRequestDelegate onActionForMeRequestComplete:nil withError:nil ];
        }
        return nil;
        //[self cleanCoupons];
    }
    //parse out the json data
    NSError* parseError;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&parseError];
    
    if (parseError!=nil) {
        if ([self.actionForMeRequestDelegate respondsToSelector:@selector(onActionForMeRequestComplete:withError:)]) {
            [self.actionForMeRequestDelegate onActionForMeRequestComplete:nil withError:parseError ];
        }
        return nil;
    }
    NSArray* latestCoupons = [json objectForKey:@"coupons"];

    
    RestLog(@"received data: %@", latestCoupons);

    NSMutableArray *coupons = [[NSMutableArray alloc] init];
    
    for (NSDictionary *cp in latestCoupons) {
        SWARMAction *tmpCoupon = [SWARMAction fromDictionary:cp];
        [coupons addObject:tmpCoupon];
    }
    
//    BLESDemoSession *mySession = [BLESDemoSession sharedManager];
//TODO: This should be called in the callback!
//    [mySession setCurrentCoupons:coupons];

    if ([self.actionForMeRequestDelegate respondsToSelector:@selector(onActionForMeRequestComplete:withError:)]) {
        [self.actionForMeRequestDelegate onActionForMeRequestComplete:coupons withError:nil ];
    }
    
    return coupons;
}


#pragma mark -

#pragma mark Request coupon for campaign
-(void)requestActionForCampaign:(NSString*)campaignId forSwarmId:(NSString*)swarmId withRemoteId:(NSString*)remoteIdP withPartnerId:(NSString*)partnerIdP
{

    TraceLog(@">>> requestActionForCampaign");
    
#if useMockUrls
    NSString *urlString =[NSString stringWithFormat:@"%@?campaignid=%@&userid=%@&title=%@&desc=%@",urlBaseGetMockCouponForCampaign,campaignId,swarmId,@"title",@"description"];
#else
    NSString *urlString =[NSString stringWithFormat:@"%@%@?userid=%@",urlBaseGetCouponForCampaign,campaignId,swarmId];
#endif
    
    
    NSURL *fullUrl = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [self getAuthenticatedGETRequestForUrl:fullUrl withUserId:remoteIdP withPartnerId:partnerIdP];
    
    
    NSMutableData *requestData = [NSMutableData data];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    
    RestLog(@"%@",urlString);

    if ([self requestActionForCampaignRestHelper]== nil) {
        [self setRequestActionForCampaignRestHelper:[[BLESRequestActionForCampaignRestHelper alloc]init]];
        [(BLESRequestActionForCampaignRestHelper*)[self requestActionForCampaignRestHelper]setRestApi:self];
    }
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:requestActionForCampaignRestHelper];
    
    [connection start];
    
    TraceLog(@"<<< requestActionForCampaign");
}



#pragma mark -

#pragma mark Reverse geolocation services (WhereAmI, WhatIsHere)
-(void)sendWhereAmIRequest:(NSString*)beaconsJsonString isPersonalized:(BOOL)isPersonalized withUserId:(NSString*)userIdP withRemoteId:(NSString*)remoteIdP withPartnerId:(NSString*)partnerIdP
{
    
    TraceLog(@">>> sendWhereAmIRequest - isPersonalized: %hhd - userId: %@ - partnerId: %@",isPersonalized,userIdP,partnerIdP);
    
    NSString *urlString;
    if (isPersonalized) {
        //Use the whatIsHere service url
#if useMockUrls
       urlString = [NSString stringWithFormat:@"%@%@", urlBaseWhatIsHereService,userIdP];
#else
       urlString =  [NSString stringWithFormat:@"%@%@", urlBaseWhatIsHereService,userIdP];
#endif

    }
    else
    {
        //use whereAmI service url
#if useMockUrls
        urlString = urlWhereAmIService;
#else
        urlString =urlWhereAmIService;
#endif

    }
    
    NSURL *fullUrl = [NSURL URLWithString:urlString];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fullUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    
    NSMutableData *requestData = [NSMutableData data];
    [requestData appendData:[[NSString stringWithString:beaconsJsonString] dataUsingEncoding:NSUTF8StringEncoding]];

    
    [self setRequestHeader:request withUserId:remoteIdP withPartnerId:partnerIdP];
    
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];

    
    NSMutableString *jostr = [NSMutableString stringWithString:@"Content-Type: application/json"];
    [jostr appendString:beaconsJsonString];
    
    [request setHTTPBody: requestData];
  
    RestLog(@"%@",urlString);
    
    NSURLConnection *connection;// = [[NSURLConnection alloc] initWithRequest:request delegate:wairh];
    
    if ([self whatIsHereRestHelper]==nil) {
        [self setWhatIsHereRestHelper:[[BLESWhatIsHereRestHelper alloc]init]] ;
        [(BLESWhatIsHereRestHelper *)[self whatIsHereRestHelper]setRestApi:self];
        
    }
    
    if ([self whereAmIRestHelper]==nil) {
        [self setWhereAmIRestHelper:[[BLESWhereAmIRestHelper alloc]init]] ;
        [(BLESWhereAmIRestHelper*)[self whereAmIRestHelper]setRestApi:self];
    }
    
    if (isPersonalized) {
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:whatIsHereRestHelper];
    }
    else
    {
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:whereAmIRestHelper];
    }
    
 
    [connection start];
    
    TraceLog(@"<<< sendWhereAmIRequest - isPersonalized: %hhd - userId: %@, partnerId: %@",isPersonalized,userIdP,partnerIdP);
}
#pragma mark -
#pragma mark HMAC
-(NSString*)getHMACSignature:(NSString*)textToSign withSalt:(NSString*)salt
{
    return [SWARMHmacHelper getHMACSignature:textToSign withSalt:salt];
}



#pragma mark Request header setup
-(NSString*)getHMACForPartner:(NSString*)partnerIdP forUserId:(NSString*)remoteIdP withTimestamp:(NSDate*)timestamp
{
  return [SWARMHmacHelper getHMACForPartner:partnerIdP forUserId:remoteIdP withTimestamp:timestamp withApiKey:[self apiKey]];
    
}

-(void)setRequestHeader:(NSMutableURLRequest*)request withUserId:(NSString*)userIdP withPartnerId:(NSString*)partnerIdP
{
     [SWARMHmacHelper setRequestHeader:request withUserId:userIdP withPartnerId:partnerId withApiKey:[self apiKey]];
}

-(NSMutableURLRequest*)getAuthenticatedGETRequestForUrl:(NSURL*)url withUserId:(NSString*)remoteIdP withPartnerId:(NSString*)partnerIdP
{
    return [SWARMHmacHelper getAuthenticatedGETRequestForUrl:url withUserId:remoteIdP withPartnerId:partnerIdP withApiKey:[self apiKey]];

}
#pragma mark -

@end

