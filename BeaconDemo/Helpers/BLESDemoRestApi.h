//
//  BLESDemoRestApi.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.10..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWARMUserProfile.h"
#import "BLESUrlDefinitions.h"
#import "BLESDemoSession.h"
#import "BLESBeacon.h"

@protocol UsersRequestCompleteDelegate;
@protocol CampaignsRequestCompleteDelegate;
@protocol BeaconsListRequestCompletedDelegate;


@interface BLESDemoRestApi : NSObject
- (void)sendUsersRequest;
- (BOOL)sendCampaignsRequest:(NSNumber*)major withMinor:(NSNumber*)minor;
- (void)sendBeaconsRequest;

@property (nonatomic,weak) id<UsersRequestCompleteDelegate> usersRqCompleteDelegate;
@property (nonatomic,weak) id<CampaignsRequestCompleteDelegate> campaignsRqCompleteDelegate;
@property (nonatomic,weak) id<BeaconsListRequestCompletedDelegate> beaconsListRequestCompletedDelegate;

@property (strong,nonatomic) NSObject *campaignRequestRestHelper;

@end
@protocol UsersRequestCompleteDelegate <NSObject>
-(void)onUsersRequestComplete:(NSMutableArray*)users;

@end

@protocol CampaignsRequestCompleteDelegate <NSObject>
-(void)onCampaignsRequestComplete:(NSMutableArray*)campaigns withError:(NSError*)error;
@end

@protocol BeaconsListRequestCompletedDelegate <NSObject>
-(void)onBeaconsListRequestCompleted:(NSArray*)responseData withError:(NSError*)error;
@end