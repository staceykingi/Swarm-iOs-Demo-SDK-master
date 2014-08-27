//
//  SwarmSDK.h
//  SwarmSDK
//
//  Created by Ákos Radványi on 2014.01.31..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SWARMLocationInformaion.h"
#import "SWARMUserProfile.h"
#import "SWARMWhatIsHereInformation.h"
#import "SwarmSDKConfiguration.h"
#import "BLESBeaconContainer.h"
#import "BLESCampaign.h"

#pragma mark Protocol declarations
@protocol WhereAmINotificationDelegate;
@protocol SwarmLoginCompletedDelegate;
@protocol WhatIsHereNotificationDelegate;
@protocol RequestActionCompletedDelegate;
@protocol RequestForMeCompletedDelegate;
@protocol ReactToActionCompletedDelegate;
@protocol RegionStateChangedDelegate;


//Just for the demo app
@protocol BeaconsChangeFoundDelegate;

#pragma mark -

#pragma mark Interface definition
@interface SwarmSDK : NSObject <CLLocationManagerDelegate>
#pragma mark Properties

@property (nonatomic,weak) id<WhereAmINotificationDelegate> whereAmINotificationDelegate;
@property (nonatomic,weak) id<SwarmLoginCompletedDelegate> swarmLoginCompletedDelegate;
@property (nonatomic,weak) id<WhatIsHereNotificationDelegate> whatIsHereNotificationDelegate;
@property (nonatomic,weak) id<RequestActionCompletedDelegate> requestActionCompletedDelegate;
@property (nonatomic,weak) id<RequestForMeCompletedDelegate> requestForMeCompletedDelegate;
@property (nonatomic,weak) id<BeaconsChangeFoundDelegate> beaconsChangeFoundDelegate;
@property (nonatomic,weak) id<ReactToActionCompletedDelegate> reactToActionCompletedDelegate;
@property (nonatomic,weak) id<RegionStateChangedDelegate> regionStateChangedDelegate;

@property (strong, nonatomic) NSString *swarmId;

@property (nonatomic) BOOL whatIsHereServiceEnabled;
@property (strong, nonatomic) NSString *version;
@property (nonatomic) BOOL monitorBeaconsChange;
@property (nonatomic) BOOL whereAmIServiceEnabled;
@property (nonatomic) BOOL showNotificationEnabled;
@property (nonatomic) BOOL useLongJobForBackgroundRequests;


-(void)initRemoteId:(NSString*)remoteId;
-(void)initPartnerId:(NSString*)partnerId;



-(NSString*)getPartnerId;
-(NSString*)getRemoteId;

-(id)initWithApiKey:(NSString*)apiKeyP withSwarmUUID:(NSUUID*)uuidP withPartnerId:(NSString*)partnerIdP withRemoteId:(NSString*)remoteIdP;

-(BOOL)setSwarmUuid:(NSUUID*)uuid;

-(NSString*)uuidText;

/**
 * Sets the Api key to use the sdk
 **/
-(void)setSwarmApiKey:(NSString *)key;

#pragma mark -
#pragma mark API Calls
/**
 * Starts WhereAmI service. When a beacons are located, the framework will provide LocationInformations
 * when a new beacon is found.
 * Implement the WhereAmICompletedDelegate protocol, and subscribe to onWhereAmINotificationReceived to
 * get these infos.
 **/
-(BOOL)startWhereAmIService;




/**
 * If the user does not have a SwarmID yet, this call can be used to retrieve one. It's up to you,
 * if you store it on the phone, or recreate each time. The point is, you need to have it to use most
 * Swarm services.
 * After the request is complete, the onSwarmLoginCompleted callback will deliver the result, to use it
 * subscribe to the SwarmLoginRequestCompletedDelegate protocol.
 *
 * remoteId : the user's id in your CRM system
 **/
-(BOOL)doSwarmLogin:(SWARMUserProfile*)profile;

/**
 * This call starts the WhatIsHere service. It's similar to the WhereAmIService, but needs a
 * SwarmID. It gives back the same data as WhereAmI, plus it provides the users currently
 * redeemable coupons list and the running campaigns at the current location.
 * In case of an error it gives back NO, otherwise YES.
 * Callback: onWhatIsHereNotificationReceived in WhatIsHereCompletedDelegate
 **/
-(BOOL)startWhatIsHereService;

-(BOOL)startMonitorBeaconsChange;

/**
 * Request a coupon for a given campaign.
 * The result * arrives in the onRequestCouponCompleted callback, in an array. 
 * If there is no coupon available, the array is empty.
 **/
-(void)requestActionForUser:(NSString*)swarmIdP forCampaign:(NSString*)campaignId;


/**
 * React to a coupon
 * accepted:
 * - YES means coupon accepted, it will be saved in the user's wallet
 * - NO  means coupon rejected
 * There is no response for this call.
 **/
-(void)reactToActionForUser:(NSString*)swarmId forAction:(NSString*)couponId withReaction:(BOOL)accepted;

/**
 * Request the user's coupon wallet. 
 * The response comes in the onRequestForMeComplated callback defined in
 * RequestForMeCompletedDelegate.
 **/
-(void)requestForMe:(NSString*)swarmId;


@end
#pragma mark Protocol definitions
/**
 * When the WhereAmI service is started, at each location change (found new beacons or left region)
 * the seen beacon's location will be provided.
 **/
@protocol WhereAmINotificationDelegate <NSObject>
-(void)onWhereAmINotificationReceived:(SWARMWhatIsHereInformation*)locationInfo withError:(NSError*)error;
@end

/**
 * After the doSwarmLogin call is completed, this protocol can be used to retrieve the user's profile data
 **/
@protocol SwarmLoginCompletedDelegate <NSObject>
-(void)onSwarmLoginCompleted:(SWARMUserProfile*)userProfile withError:(NSError*)error;
@end

/**
 * After startWhatIsHereService is called, this delegate provides location based data as mentioned above.
 **/
@protocol WhatIsHereNotificationDelegate <NSObject>
-(void)onWhatIsHereNotificationReceived:(SWARMWhatIsHereInformation*)whatIsHereInfo withError:(NSError*)error;
@end

/**
 * RequestCouponCompletedDelegate
 **/
@protocol RequestActionCompletedDelegate <NSObject>
-(void)onRequestActionCompleted:(NSArray*)actions withError:(NSError*)error;//errorhandler for http not separated yet
@end


/**
 * RequestForMeCompletedDelegate
 **/
@protocol RequestForMeCompletedDelegate <NSObject>
-(void)onRequestForMeCompleted:(NSArray*)forMe withError:(NSError*)error;//errorhandler for http not separated yet
@end


@protocol BeaconsChangeFoundDelegate <NSObject>
-(void)onBeaconsChangeFound:(BLESBeaconContainer*)beaconContainer;
@end

@protocol ReactToActionCompletedDelegate <NSObject>

-(void)onReactToActionCompleted:(NSData*)responseData withError:(NSError*)error;

@end

@protocol RegionStateChangedDelegate <NSObject>
-(void)onRegionStateChanged:(CLRegion *)region withState:(CLRegionState)state withConditoin:(BOOL) isNotification;
@end