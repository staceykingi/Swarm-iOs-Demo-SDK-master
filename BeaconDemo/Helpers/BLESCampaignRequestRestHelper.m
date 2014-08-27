//
//  BLESCampaignRequestRestHelper.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.27..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import "BLESCampaignRequestRestHelper.h"

@implementation BLESCampaignRequestRestHelper
@synthesize restApi;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Campaign request connection %p did receive response %ld", connection, (long)[(NSHTTPURLResponse *) response statusCode]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Campaign request connection %p did receive %lu bytes:\n%@", connection, (unsigned long)[data length], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] );
    
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    if (error!=nil) {
        if ([restApi.campaignsRqCompleteDelegate respondsToSelector:@selector(onCampaignsRequestComplete:withError:)]) {
            [restApi.campaignsRqCompleteDelegate onCampaignsRequestComplete:nil withError:error ];
            
        }
        return;
    }
    
    NSArray* latestCampaigns = [json objectForKey:@"campaigns"];
#if logRest
    NSLog(@"received data: %@", latestCampaigns);
#endif
    NSMutableArray *campaigns = [[NSMutableArray alloc] init];
    
    for (NSDictionary *cp in latestCampaigns) {
        BLESCampaign *camp = [BLESCampaign fromDictionary:cp];
        [campaigns addObject:camp];
    }
    
    //TODO: elegansabban, pl meg egy esemenykezelo atadasaval?
    //   BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    //TODO:set coupons in callback
    // [mySession setCurrentCoupons:coupons];
    // maTheData = campaigns;
    //[self.tableView reloadData];
    

    
    
    
    if ([restApi.campaignsRqCompleteDelegate respondsToSelector:@selector(onCampaignsRequestComplete:withError:)]) {
        [restApi.campaignsRqCompleteDelegate onCampaignsRequestComplete:campaigns withError:nil ];
        
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Campaign request connection %p did fail with error %@", connection, error);
    
    if ([restApi.campaignsRqCompleteDelegate respondsToSelector:@selector(onCampaignsRequestComplete:withError:)]) {
        [restApi.campaignsRqCompleteDelegate onCampaignsRequestComplete:nil withError:error];
        
    }
}
@end
