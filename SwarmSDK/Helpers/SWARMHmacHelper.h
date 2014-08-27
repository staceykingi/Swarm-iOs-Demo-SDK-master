//
//  SWARMHmacHelper.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.27..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWARMHmacHelper : NSObject

+(NSString*)getHMACForPartner:(NSString*)partnerIdP forUserId:(NSString*)remoteIdP withTimestamp:(NSDate*)timestamp withApiKey:(NSString*)apiKey;
+(NSString*)getHMACSignature:(NSString*)textToSign withSalt:(NSString*)salt;
+(void)setRequestHeader:(NSMutableURLRequest*)request withUserId:(NSString*)userIdP withPartnerId:(NSString*)partnerIdP withApiKey:(NSString*)apiKey;
+(NSMutableURLRequest*)getAuthenticatedGETRequestForUrl:(NSURL*)url withUserId:(NSString*)remoteIdP withPartnerId:(NSString*)partnerIdP withApiKey:(NSString*)apiKey;

@end
