//
//  BLESCouponReaction.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.07..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWARMActionReaction : NSDictionary
@property (retain, nonatomic) NSString *action;
@property (retain, nonatomic) NSString *userid;
-(NSString *)toJson;
+(SWARMActionReaction *)getAcceptCommandWithUserId: (NSString *)userId;
+(SWARMActionReaction *)getRejectCommandWithUserId: (NSString *)userId;
@end
