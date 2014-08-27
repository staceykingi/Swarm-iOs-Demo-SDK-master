//
//  SWSDKDemoSession.m
//  SwarmSDKSample
//
//  Created by Ákos Radványi on 2014.02.20..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//
#import "SWSDKDemoSession.h"

@implementation SWSDKDemoSession

@synthesize swarmSDK;
@synthesize myUser;

#pragma mark Singleton methods

+ (id)sharedManager {
    static SWSDKDemoSession *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
        
        [self setSwarmSDK:[[SwarmSDK alloc]init]];
        [[self swarmSDK] setSwarmApiKey:@"488668AF-0487-4563-9ED8-C4C0D3D896E4"];
        [[self swarmSDK] setSwarmUuid: [[NSUUID alloc]initWithUUIDString: @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"]];
        [[self swarmSDK] initPartnerId:@"collect_rewards"];
        [[self swarmSDK] initRemoteId:@"3"];
        [[self swarmSDK] setSwarmId:@"1"];
        
        /*[[self swarmSDK] setSwarmApiKey:@"D57092AC-DFAA-446C-8EF3-C81AA22815B5"];
        [[self swarmSDK] setSwarmUuid: [[NSUUID alloc]initWithUUIDString: @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"]];
        [[self swarmSDK] initPartnerId:@"sonrisa"];
        [[self swarmSDK] initRemoteId:@"tyler"];
        [[self swarmSDK] setSwarmId:@"1"];*/
        
        
        
        //Set your user profile. First it won't have a swarmId, you get it later.
        SWARMUserProfile *demoUser = [[SWARMUserProfile alloc]init];
        
        [demoUser setUserName:@"tyler"];
        [demoUser setRemoteId:@"tyler"];
        [demoUser setPartnerId:@"collect_rewards"];
        [demoUser setVendorId:@"demo.app.implementer"];
        [demoUser setAdvertiserId:@"youCanFindOutThisLater"];
        [demoUser setDesc:@"Tyler, the non-existing millionaire demo user"];
       
        //You will get this by calling swarmLogin, first time it will be empty.
        [demoUser setCustomerSwarmId:@"1"];

        SWARMSourceSegmentVector *ssv = [[SWARMSourceSegmentVector alloc]init];
        [ssv addTagToCategory:@"male" forCategory:@"gender"];
        [ssv addTagToCategory:@"reading" forCategory:@"hobbies"];
        [ssv addTagToCategory:@"golf" forCategory:@"hobbies"];
        [demoUser setSourceSegmentVector:ssv];
        
    }
    return self;
}
#pragma mark -




@end
