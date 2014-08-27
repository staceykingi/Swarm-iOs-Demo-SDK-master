//
//  BLESCouponReaction.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.07..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SWARMActionReaction.h"

@implementation SWARMActionReaction
@synthesize userid;
@synthesize action;


-(NSString *)toJson
{
    NSDictionary *tmpDict = @{
                              @"userid":userid,
                              @"action":action
                              };
    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:tmpDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *tmpJson = [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    //TODO: error handling
    return tmpJson;
}


+(SWARMActionReaction *)getAcceptCommandWithUserId: (NSString *)userId
{
    SWARMActionReaction *blc = [[SWARMActionReaction alloc]init];
    [blc setUserid:userId];
    [blc setAction:@"accept"];
    return blc;
}


+(SWARMActionReaction *)getRejectCommandWithUserId: (NSString *)userId
{
    SWARMActionReaction *blc = [[SWARMActionReaction alloc]init];
    [blc setUserid:userId];
    [blc setAction:@"reject"];
    return blc;
}

@end
