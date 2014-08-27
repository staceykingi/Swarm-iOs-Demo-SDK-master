//
//  BLESRequestActionForCampaignRestHelper.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.19..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import "BLESRequestActionForCampaignRestHelper.h"

@implementation BLESRequestActionForCampaignRestHelper
@synthesize restApi;


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Connection %p did receive response %d", connection, [(NSHTTPURLResponse *) response statusCode]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
#if logCallstack
    NSLog(@">>> fetchedActionRequestData");
#endif
    NSLog(@"Connection %p did receive %lu bytes:\n%@", connection, (unsigned long)[data length], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] );
    
    if (data==nil) {
        NSLog(@"BLESRestApi - No data received.");
        //NSMutableArray *emptyArray =[[NSMutableArray alloc]init];
        if ([restApi.actiongenerationRequestCompleteDelegate respondsToSelector:@selector(onActionGenerationRequestComplete:withError:)]) {
            [restApi.actiongenerationRequestCompleteDelegate onActionGenerationRequestComplete:nil withError:nil];
        }
#if logCallstack
        NSLog(@"<<< fetchedActionRequestData");
#endif
        return;
    }
    
    //parse out the json data
    NSError* parseError;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&parseError];
    
    if (parseError!=nil) {
        if ([restApi.actiongenerationRequestCompleteDelegate respondsToSelector:@selector(onActionGenerationRequestComplete:withError:)]) {
            [restApi.actiongenerationRequestCompleteDelegate onActionGenerationRequestComplete:nil withError:parseError];
        }
#if logCallstack
        NSLog(@"<<< fetchedActionRequestData");
#endif
        return;
    }
    
    NSArray* latestActions = [json objectForKey:@"actions"];
    
    NSLog(@"received data: %@", latestActions);
    
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *cp in latestActions) {
        BLESAction *tmpAction = [BLESAction fromDictionary:cp];
        [actions addObject:tmpAction];
    }
    
    // BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    // [mySession setCurrentActions:actions];
    if ([restApi.actiongenerationRequestCompleteDelegate respondsToSelector:@selector(onActionGenerationRequestComplete:withError:)]) {
        [restApi.actiongenerationRequestCompleteDelegate onActionGenerationRequestComplete:actions withError:nil];
    }
    
#if logCallstack
    NSLog(@"<<< fetchedActionRequestData");
#endif
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection %p did fail with error %@", connection, error);
    if ([restApi.actiongenerationRequestCompleteDelegate respondsToSelector:@selector(onActionGenerationRequestComplete:withError:)]) {
        [restApi.actiongenerationRequestCompleteDelegate onActionGenerationRequestComplete:nil withError:error];
    }
}
@end
