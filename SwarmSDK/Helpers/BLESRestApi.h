//
//  BLESRestApi.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.17..
//  Copyright (c) 2013 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLESCustomerLocationEvent.h"
#import "SWARMUserProfile.h"
#import "SWARMAction.h"
#import "BLESReachabilityChecker.h"
#import "SWARMUserProfile.h"


@protocol ActionForMeRequestCompleteDelegate;
@protocol ReplyForJsonRequestArrivedDelegate;
@protocol ActionGenerationRequestCompleteDelegate;
@protocol ActionReactionCompleteDelegate;
@protocol WhereAmIRequestCompletedDelegate;
@protocol WhatIsHereRequestCompletedDelegate;
@protocol SwarmLoginRequestCompletedDelegate;


@interface BLESRestApi : NSObject
//- (BOOL)sendJsonRequest;
//- (void) sendCustomerLocationEvent:(BLESCustomerLocationEvent *)customerLocationEvent toUrl:(NSURL *)targetUrl;
//- (void) sendCustomerLocationEvent:(BLESCustomerLocationEvent *)customerLocationEvent;
//- (BOOL)sendJsonRequest:(NSURL *)targetUrl withRequest:(NSString *)jsonRequest;
//- (NSString *)fetchActionsFromServer;
- (BOOL)reactToAction:(NSString *)actionId acceptAction:(BOOL)accepted forUser:(NSString *)userId;
//- (NSMutableArray *)getMyCoupons;
//- (void)sendRequest;
//-(BOOL)sendJsonRequest:(NSURL *)targetUrl withRequest:(NSString *)jsonRequest;
-(BOOL)sendActionForMeRequestForUser:(NSString*)userId;
-(void)requestActionForCampaign:(NSString*)campaignId forSwarmId:(NSString*)swarmId withRemoteId:(NSString*)remoteIdP withPartnerId:(NSString*)partnerIdP;
-(void)sendWhereAmIRequest:(NSString*)beaconsJsonString isPersonalized:(BOOL)isPersonalized withUserId:(NSString*)userIdP withRemoteId:(NSString*)remoteId withPartnerId:(NSString*)partnerIdP;
-(void)setSwarmApiKey:(NSString*)key;
-(NSString*)getHMACForPartner:(NSString*)partnerIdP forUserId:(NSString*)remoteIdP withTimestamp:(NSDate*)timestamp;
-(NSString*)getHMACSignature:(NSString*)textToSign withSalt:(NSString*)salt;
-(void)sendSwarmLoginRequest:(SWARMUserProfile*)profile;

@property (nonatomic,weak) id<ActionForMeRequestCompleteDelegate> actionForMeRequestDelegate;
@property (nonatomic,weak) id<ReplyForJsonRequestArrivedDelegate> replyForJsonRequestArrivedDelegate;
@property (nonatomic,weak) id<ActionGenerationRequestCompleteDelegate> actionGenerationRequestCompleteDelegate;
@property (nonatomic,weak) id<ActionReactionCompleteDelegate> actionReactionCompleteDelegate;
@property (nonatomic,weak) id<WhereAmIRequestCompletedDelegate> whereAmIRequestCompletedDelegate;
@property (nonatomic,weak) id<WhatIsHereRequestCompletedDelegate> whatIsHereRequestCompletedDelegate;
@property (nonatomic,weak) id<SwarmLoginRequestCompletedDelegate> swarmLoginRequestCompletedDelegate;
@property (strong,nonatomic) NSObject *whatIsHereRestHelper;
@property (strong,nonatomic) NSObject *whereAmIRestHelper;
@property (strong,nonatomic) NSObject *actionReactionHelper;
@property (strong,nonatomic) NSObject *requestActionForCampaignRestHelper;
@property (strong,nonatomic) NSObject *actionForMeRequestRestHelper;
@property (strong,nonatomic) NSObject *swarmLoginRestHelper;
@property (strong,nonatomic) BLESReachabilityChecker *reachabilityChecker;
@property (strong,nonatomic) NSString *remoteId;
@property (strong,nonatomic) NSString *partnerId;
@property (strong,nonatomic) NSString *apiKey;
@end


@protocol ActionForMeRequestCompleteDelegate <NSObject>
-(void)onActionForMeRequestComplete:(NSMutableArray*)actions withError:(NSError*)error;
@end

@protocol ReplyForJsonRequestArrivedDelegate <NSObject>
-(void)onJsonPostRequestComplete:(NSMutableData*)responseData;
@end

@protocol ActionGenerationRequestCompleteDelegate <NSObject>
-(void)onActionGenerationRequestComplete:(NSMutableArray*)actions withError:(NSError*)error;
@end

@protocol ActionReactionCompleteDelegate <NSObject>
-(void)onActionReactionComplete:(NSData*)responseData withError:(NSError*)error;
@end

@protocol WhereAmIRequestCompletedDelegate <NSObject>
-(void)onWhereAmIRequestCompleted:(NSData*)responseData withError:(NSError *)error;
@end

@protocol WhatIsHereRequestCompletedDelegate <NSObject>
-(void)onWhatIsHereRequestCompleted:(NSData*)responseData withError:(NSError *)error;
@end

@protocol SwarmLoginRequestCompletedDelegate <NSObject>
-(void)onSwarmLoginRequestCompleted:(SWARMUserProfile*)responseData withError:(NSError*)error;
@end