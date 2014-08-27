//
//  BLESActionReaction.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.07..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLESActionReaction : NSDictionary
@property (retain, nonatomic) NSString *action;
@property (retain, nonatomic) NSString *userid;
-(NSString *)toJson;
+(BLESActionReaction *)getAcceptCommandWithUserId: (NSString *)userId;
+(BLESActionReaction *)getRejectCommandWithUserId: (NSString *)userId;
@end
