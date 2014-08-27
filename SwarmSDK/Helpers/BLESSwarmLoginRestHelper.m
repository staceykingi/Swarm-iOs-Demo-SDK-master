//
//  BLESSwarmLoginRestHelper.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.24..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "BLESSwarmLoginRestHelper.h"
#import "BLESUrlDefinitions.h"
@implementation BLESSwarmLoginRestHelper
@synthesize restApi;
@synthesize d;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    RestLog(@"SwarmLogin connection %p did receive response %ld", connection, (long)[(NSHTTPURLResponse *) response statusCode]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    RestLog(@"SwarmLogin connection %p did receive %lu bytes:\n%@", connection, (unsigned long)[data length], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] );
    if (d==nil) {
        d =  [[NSMutableData alloc] init];
    }
    
    [d appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSData *data = [NSData dataWithData:d];
    d=nil;
    RestLog(@"SwarmLogin connection %p finished loading", connection);
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];

    if (error!=nil) {
        if ([restApi.swarmLoginRequestCompletedDelegate respondsToSelector:@selector(onSwarmLoginRequestCompleted:withError:)]) {
            [restApi.swarmLoginRequestCompletedDelegate onSwarmLoginRequestCompleted:nil withError:error ];
        }
    }
    
    SWARMUserProfile *up = [SWARMUserProfile fromDictionary:json];
    
    
    if ([restApi.swarmLoginRequestCompletedDelegate respondsToSelector:@selector(onSwarmLoginRequestCompleted:withError:)]) {
        [restApi.swarmLoginRequestCompletedDelegate onSwarmLoginRequestCompleted:up withError:nil ];
        
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    RestLog(@"SwarmLogin connection %p did fail with error %@", connection, error);
    
    if ([restApi.swarmLoginRequestCompletedDelegate respondsToSelector:@selector(onSwarmLoginRequestCompleted:withError:)]) {
        [restApi.swarmLoginRequestCompletedDelegate onSwarmLoginRequestCompleted:nil withError:error];
        
    }
}
@end
