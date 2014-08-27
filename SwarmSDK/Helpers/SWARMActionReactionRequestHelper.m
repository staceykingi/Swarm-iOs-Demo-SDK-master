//
//  BLESCouponReactionRequestHelper.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.10..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SWARMActionReactionRequestHelper.h"
#import "BLESUrlDefinitions.h"
@implementation SWARMActionReactionRequestHelper
@synthesize restApi,d;


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    RestLog(@"SWARMActionReactionRequestHelper Connection %p did receive response %ld", connection, (long)[(NSHTTPURLResponse *) response statusCode]);
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    RestLog(@"SWARMActionReactionRequestHelper Connection %p did receive %lu bytes:\n%@", connection, (unsigned long)[data length], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] );
    
    if (d==nil) {
        d  = [[NSMutableData alloc] init];
    }
    
    [d appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSData *data = [NSData dataWithData:d];
    d=nil;

    RestLog(@"SWARMActionReactionRequestHelper Connection %p finished loading", connection);

    if ([restApi.actionReactionCompleteDelegate respondsToSelector:@selector(onActionReactionComplete:withError:)]) {
        [restApi.actionReactionCompleteDelegate onActionReactionComplete:data withError:nil];
        
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

    RestLog(@"SWARMActionReactionRequestHelper Connection %p did fail with error %@", connection, error);

    if ([restApi.actionReactionCompleteDelegate respondsToSelector:@selector(onActionReactionComplete:withError:)]) {
        [restApi.actionReactionCompleteDelegate onActionReactionComplete:nil withError:error];
        
    }
}
@end
