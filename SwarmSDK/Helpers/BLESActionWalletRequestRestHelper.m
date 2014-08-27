//
//  BLESActionWalletRequestRestHelper.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.19..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import "BLESActionWalletRequestRestHelper.h"

@implementation BLESActionWalletRequestRestHelper
@synthesize restApi;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Connection %p did receive response %d", connection, [(NSHTTPURLResponse *) response statusCode]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Connection %p did receive %d bytes:\n%@", connection, [data length], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] );
    
    if (data==nil) {
        if ([restApi.actionWalletRequestDelegate respondsToSelector:@selector(onActionForMeRequestComplete:withError:)]) {
            [restApi.actionWalletRequestDelegate onActionForMeRequestComplete:nil withError:nil ];
        }
        return;
    }
    //parse out the json data
    NSError* parseError;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&parseError];
    
    if (parseError!=nil) {
        if ([restApi.actionWalletRequestDelegate respondsToSelector:@selector(onActionForMeRequestComplete:withError:)]) {
            [restApi.actionWalletRequestDelegate onActionForMeRequestComplete:nil withError:parseError ];
        }
        return;
    }
    NSArray* latestActions = [json objectForKey:@"actions"];
    
    NSLog(@"received data: %@", latestActions);
    
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    
    for (NSDictionary *cp in latestActions) {
        BLESAction *tmpAction = [BLESAction fromDictionary:cp];
        [actions addObject:tmpAction];
    }
    
    //    BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    //TODO: This should be called in the callback!
    //    [mySession setCurrentActions:actions];
    
    if ([restApi.actionWalletRequestDelegate respondsToSelector:@selector(onActionForMeRequestComplete:withError:)]) {
        [restApi.actionWalletRequestDelegate onActionForMeRequestComplete:actions withError:nil ];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection %p did fail with error %@", connection, error);
    if ([restApi.actionWalletRequestDelegate respondsToSelector:@selector(onActionForMeRequestComplete:withError:)]) {
        [restApi.actionWalletRequestDelegate onActionForMeRequestComplete:nil withError:error ];
    }
}
@end
