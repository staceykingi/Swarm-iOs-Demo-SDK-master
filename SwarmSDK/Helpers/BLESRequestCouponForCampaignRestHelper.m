//
//  BLESRequestActionForCampaignRestHelper.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.19..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "BLESRequestActionForCampaignRestHelper.h"
#import "BLESUrlDefinitions.h"
@implementation BLESRequestActionForCampaignRestHelper
@synthesize restApi, d;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    RestLog(@"BLESRequestActionForCampaignRestHelper - Connection %p did receive response %ld", connection, (long)[(NSHTTPURLResponse *) response statusCode]);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSData *data= [NSData dataWithData:d];
    d=nil;
    TraceLog(@">>> fetchedCouponRequestData");
    RestLog(@"BLESRequestActionForCampaignRestHelper - Connection %p finished loading", connection );
    if (data==nil) {
        RestLog(@"BLESRestApi - No data received.");
        //NSMutableArray *emptyArray =[[NSMutableArray alloc]init];
        if ([restApi.actionGenerationRequestCompleteDelegate respondsToSelector:@selector(onActionGenerationRequestComplete:withError:)]) {
            [restApi.actionGenerationRequestCompleteDelegate onActionGenerationRequestComplete:nil withError:nil];
        }
        TraceLog(@"<<< fetchedCouponRequestData");
        return;
    }
    
    //parse out the json data
    NSError* parseError;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&parseError];
    
    if (parseError!=nil) {
        if ([restApi.actionGenerationRequestCompleteDelegate respondsToSelector:@selector(onActionGenerationRequestComplete:withError:)]) {
            [restApi.actionGenerationRequestCompleteDelegate onActionGenerationRequestComplete:nil withError:parseError];
        }
        TraceLog(@"<<< fetchedCouponRequestData");
        return;
    }
    
    NSArray* latestCoupons = [json objectForKey:@"coupons"];
    RestLog(@"received data: %@", latestCoupons);
    NSMutableArray *coupons = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *cp in latestCoupons) {
        SWARMAction *tmpCoupon = [SWARMAction fromDictionary:cp];
        [coupons addObject:tmpCoupon];
    }
    
    // BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    // [mySession setCurrentCoupons:coupons];
    if ([restApi.actionGenerationRequestCompleteDelegate respondsToSelector:@selector(onActionGenerationRequestComplete:withError:)]) {
        [restApi.actionGenerationRequestCompleteDelegate onActionGenerationRequestComplete:coupons withError:nil];
    }
    
    TraceLog(@"<<< fetchedCouponRequestData");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    RestLog(@"BLESRequestActionForCampaignRestHelper - Connection %p did receive %lu bytes:\n%@", connection, (unsigned long)[data length], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] );
    if (d==nil) {
        d =  [[NSMutableData alloc] init];
    }
    
    [d appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    RestLog(@"BLESRequestActionForCampaignRestHelper - Connection %p did fail with error %@", connection, error);
    if ([restApi.actionGenerationRequestCompleteDelegate respondsToSelector:@selector(onActionGenerationRequestComplete:withError:)]) {
        [restApi.actionGenerationRequestCompleteDelegate onActionGenerationRequestComplete:nil withError:error];
    }
}
@end
