//
//  SWARMHelpers.m
//  SwarmSDK
//
//  Created by Ákos Radványi on 2014.02.12..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SWARMHelpers.h"

@implementation SWARMHelpers

+(NSString*)dictionaryToJson:(NSDictionary*)dict
{
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted error:&error];

    NSString *tmpJson = [[NSString alloc] initWithData:jsonData
                                        encoding:NSUTF8StringEncoding];
    return tmpJson;
}

+(NSString*)arrayToJson:(NSArray*)array
{
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *tmpJson = [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    return tmpJson;
}

@end
