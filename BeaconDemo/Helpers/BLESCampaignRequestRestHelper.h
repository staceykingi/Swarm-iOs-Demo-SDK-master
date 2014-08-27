//
//  BLESCampaignRequestRestHelper.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.27..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLESDemoRestApi.h"

@interface BLESCampaignRequestRestHelper : NSObject <NSURLConnectionDataDelegate>
@property (strong, nonatomic) BLESDemoRestApi *restApi;
@property (nonatomic) BOOL isPersonalized;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@end
