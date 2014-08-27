//
//  SWARMActionForMeRequestRestHelper.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.19..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SWARMActionForMeRequestRestHelper.h"
#import "BLESUrlDefinitions.h"
@implementation SWARMActionForMeRequestRestHelper
@synthesize restApi;
@synthesize d;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

    RestLog(@"SWARMActionForMeRequestRestHelper - Connection %p did receive response %ld", connection, (long)[(NSHTTPURLResponse *) response statusCode]);

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{

    RestLog(@"SWARMActionForMeRequestRestHelper - Connection %p did receive %lu bytes:\n%@", connection, (unsigned long)[data length], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] );

    if (d==nil) {
        d  = [[NSMutableData alloc] init];
    }
    
    [d appendData:data];
    
    }

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    RestLog(@"SWARMActionForMeRequestRestHelper - Connection %p finished loading", connection);

    NSData *data = [NSData dataWithData:d];
    d=nil;
    NSString *tmpBuffer = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *arr = [tmpBuffer componentsSeparatedByString:@"}{"];
    
    NSData *ret;
    
    if ([arr count]>1) {
        NSString *retString = [NSString stringWithFormat:@"%@}",[arr objectAtIndex:0]];
        ret = [retString dataUsingEncoding:NSUTF8StringEncoding];
        d = nil;
    }
    else
    {
        ret = [[arr objectAtIndex:0]dataUsingEncoding:NSUTF8StringEncoding];
        d=nil;
    }

    
    
    
    if (ret==nil) {
        if ([restApi.actionForMeRequestDelegate respondsToSelector:@selector(onActionForMeRequestComplete :withError:)]) {
            [restApi.actionForMeRequestDelegate onActionForMeRequestComplete:nil withError:nil ];
        }
        return;
    }
    //parse out the json data
    NSError* parseError;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:ret
                          options:kNilOptions
                          error:&parseError];
    
    if (parseError!=nil) {
        if ([restApi.actionForMeRequestDelegate respondsToSelector:@selector(onActionForMeRequestComplete:withError:)]) {
            [restApi.actionForMeRequestDelegate onActionForMeRequestComplete:nil withError:parseError ];
        }
        return;
    }
    NSArray* latestCoupons = [json objectForKey:@"coupons"];

    RestLog(@"received data: %@", latestCoupons);

    NSMutableArray *coupons = [[NSMutableArray alloc] init];
    
    for (NSDictionary *cp in latestCoupons) {
        SWARMAction *tmpCoupon = [SWARMAction fromDictionary:cp];
        [coupons addObject:tmpCoupon];
    }
    
    //    BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    //TODO: This should be called in the callback!
    //    [mySession setCurrentCoupons:coupons];
    
    if ([restApi.actionForMeRequestDelegate respondsToSelector:@selector(onActionForMeRequestComplete:withError:)]) {
        [restApi.actionForMeRequestDelegate onActionForMeRequestComplete:coupons withError:nil ];
    }

}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

    RestLog(@"SWARMActionForMeRequestRestHelper - Connection %p did fail with error %@", connection, error);

    if ([restApi.actionForMeRequestDelegate respondsToSelector:@selector(onActionForMeRequestComplete:withError:)]) {
        [restApi.actionForMeRequestDelegate onActionForMeRequestComplete:nil withError:error ];
    }
}
@end
