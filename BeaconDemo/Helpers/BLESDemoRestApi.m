//
//  BLESDemoRestApi.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.10..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define mySession [BLESDemoSession sharedManager]
//Get customers for demo
//#define urlGetCustomersForDemo @"http://webservices.swarm-mobile.com/swarm-demo/services/customer"
//List active campaigns for location id (beacon id) - GET
//TODO: where is this called?!
//#define urlBaseGetActiveCampaignsForLocation  @"http://webservices.swarm-mobile.com/swarm-demo/services/campaign/"
//+{major}/{minor}"


#import "BLESDemoRestApi.h"
#import "SWARMHmacHelper.h"
#import "BLESCampaignRequestRestHelper.h"

@implementation BLESDemoRestApi
@synthesize usersRqCompleteDelegate, campaignRequestRestHelper;

#pragma mark Get demo users from server

- (void)sendUsersRequest
{
    
#if useMockUrls
    NSString *urlString = urlGetMockCustomersForDemo;
    NSURL *fullUrl = [NSURL URLWithString: urlString];
#else
    NSString *urlString = urlGetCustomersForDemo;
    NSURL *fullUrl = [NSURL URLWithString: urlString];
#endif
    
    
    NSLog(@"Sending Request to %@ ...",urlString);
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:fullUrl];
        [self performSelectorOnMainThread:@selector(fetchedUsersData:)
                               withObject:data waitUntilDone:YES];
    });
}

- (NSMutableArray *)fetchedUsersData:(NSData *)responseData {
    
    
    if (responseData==nil) {
        NSLog(@"BLESDemoRestApi - No data received.");
        NSMutableArray *emptyArray =[[NSMutableArray alloc]init];
        if ([self.usersRqCompleteDelegate respondsToSelector:@selector(onUsersRequestComplete:)]) {
            [self.usersRqCompleteDelegate onUsersRequestComplete:nil ];
        }
        [mySession setDemoProfiles:emptyArray];
        return emptyArray;
    }
    
    //parse out the json data
    NSError* error;
    //#if useMockUrls
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    NSArray* demoUsers = [json objectForKey:@"users"];
    /*#else
     NSArray* demoUsers = [NSJSONSerialization
     JSONObjectWithData:responseData
     options:kNilOptions
     error:&error];
     
     //    NSArray* demoUsers = [json objectForKey:@"users"];
     #endif*/
#if logRest
    NSLog(@"received data: %@", demoUsers);
#endif
    NSMutableArray *users = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *cp in demoUsers) {
        SWARMUserProfile *tmpUser = [SWARMUserProfile fromDictionary:cp];
        [users addObject:tmpUser];
    }
    
    
    [mySession setDemoProfiles:users];
    [mySession setUsersLoaded:YES];
    
    if ([self.usersRqCompleteDelegate respondsToSelector:@selector(onUsersRequestComplete:)]) {
        [self.usersRqCompleteDelegate onUsersRequestComplete:users ];
    }
    
    return users;
}

#pragma mark -
#pragma mark Get campaings from the server

- (BOOL)sendCampaignsRequest:(NSNumber*)major withMinor:(NSNumber*)minor {
    
    
   /* if ([[self reachabilityChecker]isOnline] !=YES) {
        //Error: no network!
        //TODO: Handle it!
        
        return NO;
    }*/
    
    NSLog(@"Sending Request...");
#if useMockUrls
    
    NSString *fullUrl = [NSString stringWithFormat:@"%@",mockCampaignsUrl];
    NSURL *url = [NSURL URLWithString:fullUrl];
#else
    //http://webservices.swarm-mobile.com/swarm-demo/services/campaign/40/2210
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@/%@",urlBaseGetActiveCampaignsForLocation,major,minor ];
    NSURL *url = [NSURL URLWithString:fullUrl];
#endif
    NSLog(@"%@",fullUrl);
    NSLog(@"Getting campaigns for location minor:major=%hu:%hu",[major unsignedShortValue],[minor unsignedShortValue]);

    
    NSMutableURLRequest *request = [SWARMHmacHelper getAuthenticatedGETRequestForUrl:url withUserId:@"none" withPartnerId:@"sonrisa" withApiKey:[mySession apiKey]];

    
    if ([self campaignRequestRestHelper]==nil) {
        [self setCampaignRequestRestHelper:[[BLESCampaignRequestRestHelper alloc]init]];
        [(BLESCampaignRequestRestHelper*)[self campaignRequestRestHelper]setRestApi:self];
    }
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:campaignRequestRestHelper];
    
    [connection start];
    
    
 /*   dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:url];
        [self performSelectorOnMainThread:@selector(fetchedCampaignsData:)
                               withObject:data waitUntilDone:YES];
    });*/
    return YES;
}


//TODO: remove
- (NSMutableArray *)fetchedCampaignsData:(NSData *)responseData {
    if (responseData==nil) {
        NSLog(@"BLESCouponsNearTVC - No data received.");
       /* UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No data received"
                                                        message:@"The server did not return any data. Please, try again later."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        */
        //return [self cleanCoupons];
        return nil;
    }
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    NSArray* latestCampaigns = [json objectForKey:@"campaigns"];
    
    NSLog(@"received data: %@", latestCampaigns);
    
    NSMutableArray *campaigns = [[NSMutableArray alloc] init];
    
    for (NSDictionary *cp in latestCampaigns) {
        BLESCampaign *camp = [BLESCampaign fromDictionary:cp];
        [campaigns addObject:camp];
    }
    
    //TODO: elegansabban, pl meg egy esemenykezelo atadasaval?
    //   BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    //TODO:set coupons in callback
    // [mySession setCurrentCoupons:coupons];
    // maTheData = campaigns;
    //[self.tableView reloadData];
    
    if ([self.campaignsRqCompleteDelegate respondsToSelector:@selector(onCampaignsRequestComplete:withError:)]) {
        [self.campaignsRqCompleteDelegate onCampaignsRequestComplete:campaigns withError:nil];
    }
    return campaigns;
}


- (void)sendBeaconsRequest {
#if useMockUrls
    NSString *fullUrlString = mockBeaconsUrl;
#else
    NSString *fullUrlString = urlGetLocations;
#endif
    NSURL *fullUrl = [NSURL URLWithString:fullUrlString];
    NSLog(@"Sending Request to %@ ...",fullUrlString);
   
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:fullUrl];
        [self performSelectorOnMainThread:@selector(fetchedBeaconsData:) withObject:data waitUntilDone:YES];
        
        /* // once the code above returns you schedule a block on the main queue:
         dispatch_async(dispatch_get_main_queue(), ^{
         //      [self.delegate myDealderReturnedSomeData:[_myDealer someData] anotherArg:...];
         });*/
    });
}

- (NSMutableArray *)fetchedBeaconsData:(NSData *)responseData {
    if (responseData==nil) {
        NSLog(@"Getting beacon list - No beacon data received.");
        if ([self.beaconsListRequestCompletedDelegate respondsToSelector:@selector(onBeaconsListRequestCompleted:withError:)]) {
            [self.beaconsListRequestCompletedDelegate onBeaconsListRequestCompleted:nil withError:nil];
        }
        return nil;
    }
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    if (error!=nil) {
        if ([self.beaconsListRequestCompletedDelegate respondsToSelector:@selector(onBeaconsListRequestCompleted:withError:)]) {
            [self.beaconsListRequestCompletedDelegate onBeaconsListRequestCompleted:nil withError:error];
        }
        return nil;
    }
    
    NSArray* beaconsArray = [json objectForKey:@"locations"];
    
    NSLog(@"received data: %@", beaconsArray);
    
    NSMutableArray *beacons = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *tmpBeacon in beaconsArray) {
        BLESBeacon *beacon = [BLESBeacon fromDictionary:tmpBeacon];
        [beacons addObject:beacon];
    }
    
    if ([self.beaconsListRequestCompletedDelegate respondsToSelector:@selector(onBeaconsListRequestCompleted:withError:)]) {
        [self.beaconsListRequestCompletedDelegate onBeaconsListRequestCompleted:[NSArray arrayWithArray: beacons] withError:nil];
    }
    
    return beacons;
}




@end
