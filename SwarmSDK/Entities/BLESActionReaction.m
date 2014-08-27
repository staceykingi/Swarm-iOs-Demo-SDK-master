//
//  BLESActionReaction.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.07..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import "BLESActionReaction.h"

@implementation BLESActionReaction
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


+(BLESActionReaction *)getAcceptCommandWithUserId: (NSString *)userId
{
    BLESActionReaction *blc = [[BLESActionReaction alloc]init];
    [blc setUserid:userId];
    [blc setAction:@"accept"];
    return blc;
}


+(BLESActionReaction *)getRejectCommandWithUserId: (NSString *)userId
{
    BLESActionReaction *blc = [[BLESActionReaction alloc]init];
    [blc setUserid:userId];
    [blc setAction:@"reject"];
    return blc;
}

@end
