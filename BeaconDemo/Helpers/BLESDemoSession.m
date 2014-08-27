//
//  BLESSession.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.19..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//
#import "BLESDemoSession.h"
#import "BLESReachabilityChecker.h"
#import "BLESMock.h"
#import "BLESUserProfile.h"


@interface BLESDemoSession ()
@end

@implementation BLESDemoSession


@synthesize someProperty;
@synthesize currentAction;
@synthesize currentActions;
@synthesize isOnline;
@synthesize currentBeacons;
@synthesize demoProfiles;
@synthesize currentUser;
@synthesize reachabilityChecker;
@synthesize usersLoaded;
@synthesize currentCampaign;
@synthesize uuid;
@synthesize swarmSDK, apiKey;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static BLESDemoSession *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        BLESMock *mock = [[BLESMock alloc]init];
        [self setCurrentBeacons:[mock getMockBeacons]];
        [self setReachabilityChecker:[[BLESReachabilityChecker alloc]init]];

        
        [self setSwarmSDK:[[SwarmSDK alloc]
                           initWithApiKey:@"488668AF-0487-4563-9ED8-C4C0D3D896E4"
                           withSwarmUUID:[[NSUUID alloc]initWithUUIDString: @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"]
                           withPartnerId:@"collect_rewards"
                           withRemoteId:@"3"]];
        
/*------You could initialize the SDK this way as well:--------------------------------------------------------------
        [self setSwarmSDK:[[SwarmSDK alloc]init]];
        [[self swarmSDK]setSwarmApiKey:@"D57092AC-DFAA-446C-8EF3-C81AA22815B5"];
        [[self swarmSDK]setSwarmUuid:[[NSUUID alloc]initWithUUIDString: @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"]];
        NSLog(@"Swarm SDK %@",[self.swarmSDK version]);
        //for the demo, set auth data:
        [[self swarmSDK]initPartnerId:@"sonrisa"];
        [[self swarmSDK]initRemoteId:@"3"];
------------------------------------------------------------------------------------------------------------------*/
        [[self swarmSDK]setShowNotificationEnabled:YES];
        [[self swarmSDK]setUseLongJobForBackgroundRequests:YES];
        
        /*[self setApiKey:@"488668AF-0487-4563-9ED8-C4C0D3D896E4"];
        
        [self setUsersLoaded:NO];
        [self setDemoProfiles:nil];
        [self setCurrentUser:(SWARMUserProfile*)[[self demoProfiles]objectAtIndex:0]];
        [self setUuid:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
        
        
        
        
        SWARMUserProfile *tmpProfile = [[SWARMUserProfile alloc]init];
        [tmpProfile setRemoteId:@"3"];
        [tmpProfile setPartnerId:@"collect_rewards"];
        [tmpProfile setUserName:@"Anne Mirage"];
        [tmpProfile setCustomerSwarmId:@"anne3"];*/
        
        [[self swarmSDK]setSwarmLoginCompletedDelegate:self ];
        
    }
    return self;
}

-(NSString*)selectedProfileId
{
    if ([self currentUser]==nil) {
        return 0;
    }
    return [[self currentUser]customerSwarmId];
}

-(void)onSwarmLoginCompleted:(SWARMUserProfile *)userProfile withError:(NSError *)error
{
    if (error!=nil || userProfile ==nil) {
        return;
    }
    
    NSLog(@"Swarm login completed. SwarmId: %@",[userProfile customerSwarmId]);
}

-(SWARMUserProfile*)getUserByName:(NSString*)name
{
    if ([self demoProfiles]==nil) {
        return nil;
    }
    for (SWARMUserProfile *up in [self demoProfiles]) {
        if ([[up userName]isEqualToString:name]) {
            return up;
        }
    }
    return nil;
}

-(SWARMUserProfile*)getUserBySwarmId:(NSString*)swarmId
{
    if ([self demoProfiles]==nil) {
        return nil;
    }
    
    for (SWARMUserProfile *up in [self demoProfiles]) {
        if ([[up customerSwarmId] isEqualToString:swarmId]) {
            return up;
        }
    }
    
    return nil;
}

@end


