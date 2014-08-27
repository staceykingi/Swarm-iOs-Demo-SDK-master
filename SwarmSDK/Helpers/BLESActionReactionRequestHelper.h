//
//  BLESCouponReactionRequestHelper.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.10..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLESRestApi.h"

@interface BLESCouponReactionRequestHelper : NSObject <NSURLConnectionDataDelegate>

@property (strong,nonatomic) BLESRestApi *restApi;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end
