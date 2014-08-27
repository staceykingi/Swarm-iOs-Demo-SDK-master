//
//  SWARMHmacHelper.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.27..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SWARMHmacHelper.h"
#import "BLESUrlDefinitions.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation SWARMHmacHelper


#pragma mark HMAC
+(NSString*)getHMACForPartner:(NSString*)partnerIdP forUserId:(NSString*)remoteIdP withTimestamp:(NSDate*)timestamp withApiKey:(NSString*)apiKey
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    NSString *dateString = [dateFormatter stringFromDate:timestamp];
    NSString *stepOne = [SWARMHmacHelper getHMACSignature:partnerIdP withSalt:apiKey];
    NSString *stepTwo = [SWARMHmacHelper getHMACSignature:stepOne withSalt:remoteIdP];
    NSString *stepThree = [self getHMACSignature:stepTwo withSalt:dateString];
    
    return stepThree;
}

+(NSString*)getHMACSignature:(NSString*)textToSign withSalt:(NSString*)salt
{
    
    NSString * parameters = textToSign;
    if ([textToSign isEqualToString:@""]) {
        parameters = @"none";
    }
    
    NSData *saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH ];
    CCHmac(kCCHmacAlgSHA256, saltData.bytes, saltData.length, paramData.bytes, paramData.length, hash.mutableBytes);
    NSData *dataHash = [NSData dataWithData:hash];
    NSString *base64Hash = [dataHash base64EncodedStringWithOptions:0];
#if logHmac
    NSLog(@"\n******************************************************\nText: %@\nSalt: %@\nHMAC: %@\n******************************************************\n",textToSign,salt,base64Hash);
#endif
    return base64Hash;
}






#pragma mark Request header setup
+(void)setRequestHeader:(NSMutableURLRequest*)request withUserId:(NSString*)userIdP withPartnerId:(NSString*)partnerIdP withApiKey:(NSString*)apiKey
{
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDate *tmpDate = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    NSString *dateString = [dateFormatter stringFromDate:tmpDate];
    [request addValue:dateString forHTTPHeaderField:@"Swarm-Timestamp"];
    NSString *signature;
    if (userIdP==nil) {
        signature = [SWARMHmacHelper getHMACForPartner:partnerIdP forUserId:@"none" withTimestamp:tmpDate withApiKey:apiKey];
        [request addValue:@"none" forHTTPHeaderField:@"Swarm-Remote-Id"];
    }
    else{
        signature = [SWARMHmacHelper getHMACForPartner:partnerIdP forUserId:userIdP withTimestamp:tmpDate withApiKey:apiKey];
        [request addValue:userIdP forHTTPHeaderField:@"Swarm-Remote-Id"];
    }
    
    [request addValue:partnerIdP forHTTPHeaderField: @"Swarm-Partner-Id"];
    
    [request addValue:signature forHTTPHeaderField:@"Swarm-Api-Challange"];

    RestLog(@"\n*******setRequestHeader*************************************\nTimestamp: %@\nRemoteId: %@\nPartnerId: %@\nHMAC: %@\n************************************************",dateString,userIdP,partnerIdP,signature);
    
}

+(NSMutableURLRequest*)getAuthenticatedGETRequestForUrl:(NSURL*)url withUserId:(NSString*)remoteIdP withPartnerId:(NSString*)partnerIdP withApiKey:(NSString*)apiKey
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDate *tmpDate = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    NSString *dateString = [dateFormatter stringFromDate:tmpDate];
    [request addValue:dateString forHTTPHeaderField:@"Swarm-Timestamp"];
    NSString *signature = [SWARMHmacHelper getHMACForPartner:partnerIdP forUserId:remoteIdP withTimestamp:tmpDate withApiKey:apiKey];
    
    //NSLog(@"Signature for %@: %@",dateString,signature);
    [request addValue:signature forHTTPHeaderField:@"Swarm-Api-Challange"];
    [request addValue:remoteIdP forHTTPHeaderField:@"Swarm-Remote-Id"];
    [request addValue:partnerIdP forHTTPHeaderField: @"Swarm-Partner-Id"];
    
    RestLog(@"\n*******setRequestHeader*************************************\nTimestamp: %@\nRemoteId: %@\nPartnerId: %@\nHMAC: %@\n************************************************",dateString,remoteIdP,partnerIdP,signature);
    
    return request;
}


#pragma mark -
@end
