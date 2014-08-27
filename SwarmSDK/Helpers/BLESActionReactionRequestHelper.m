//
//  BLESCouponReactionRequestHelper.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.10..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import "BLESCouponReactionRequestHelper.h"

@implementation BLESCouponReactionRequestHelper
@synthesize restApi;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Connection %p did receive response %d", connection, [(NSHTTPURLResponse *) response statusCode]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Connection %p did receive %lu bytes:\n%@", connection, (unsigned long)[data length], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] );
    
    if ([restApi.actionReactionCompleteDelegate respondsToSelector:@selector(onCouponReactionComplete:withError:)]) {
        [restApi.actionReactionCompleteDelegate onCouponReactionComplete:data withError:nil];
        
    }

    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection %p did fail with error %@", connection, error);
    
    if ([restApi.actionReactionCompleteDelegate respondsToSelector:@selector(onCouponReactionComplete:withError:)]) {
        [restApi.actionReactionCompleteDelegate onCouponReactionComplete:nil withError:error];
        
    }
}
@end
