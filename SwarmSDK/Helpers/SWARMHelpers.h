//
//  SWARMHelpers.h
//  SwarmSDK
//
//  Created by Ákos Radványi on 2014.02.12..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWARMHelpers : NSObject
+(NSString*)dictionaryToJson:(NSDictionary*)dict;
+(NSString*)arrayToJson:(NSDictionary*)array;
@end
