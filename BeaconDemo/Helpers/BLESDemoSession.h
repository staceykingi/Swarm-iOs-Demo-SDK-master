//
//  BLESSession.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.19..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWARMAction.h"
#import "BLESUserProfile.h"
#import "BLESReachabilityChecker.h"
#import "BLESCampaign.h"
#import "SwarmSDK.h"
@interface BLESDemoSession : NSObject < SwarmLoginCompletedDelegate> {
    NSString *someProperty;
    SWARMAction *currentAction;
    NSMutableArray *currentActions;
    BOOL isOnline;
    NSString *selectedProfileId;
    NSMutableArray *demoProfiles;
    SWARMUserProfile *currentUser;
   
    BOOL usersLoaded;
}

@property (nonatomic, retain) NSString *someProperty;
@property (nonatomic,retain) BLESCampaign *currentCampaign;
@property (nonatomic, strong) SWARMAction *currentAction;
@property (nonatomic, retain) NSMutableArray *currentActions;
@property (nonatomic, retain) NSMutableArray *currentBeacons;
@property (nonatomic) BOOL isOnline;

//@property (nonatomic, strong) NSString *selectedProfileId;
-(NSString*)selectedProfileId;

@property (nonatomic, strong) NSMutableArray *demoProfiles;
@property (nonatomic, strong) SWARMUserProfile *currentUser;
@property (nonatomic, retain) BLESReachabilityChecker *reachabilityChecker;
@property (nonatomic) BOOL usersLoaded;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) SwarmSDK *swarmSDK;
@property (nonatomic, strong) NSString* apiKey;

+ (id)sharedManager;
-(SWARMUserProfile*)getUserByName:(NSString*)name;
-(SWARMUserProfile*)getUserBySwarmId:(NSString*)swarmId;
@end
