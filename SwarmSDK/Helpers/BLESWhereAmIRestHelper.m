//
//  BLESWhereAmIRestHelper.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.04..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "BLESWhereAmIRestHelper.h"
#import "BLESUrlDefinitions.h"
@implementation BLESWhereAmIRestHelper
@synthesize restApi;
@synthesize isPersonalized, d;




- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    RestLog(@"BLESWhereAmIRestHelper Connection %p did receive response %ld", connection, (long)[(NSHTTPURLResponse *) response statusCode]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    RestLog(@"BLESWhereAmIRestHelper Connection %p did receive %lu bytes:\n%@", connection, (unsigned long)[data length], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] );
    
    if (d==nil) {
        d =  [[NSMutableData alloc] init];
    }
    
    [d appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSData *data = [NSData dataWithData:d];
    d=nil;
    NSString *tmpBuffer = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *arr = [tmpBuffer componentsSeparatedByString:@"}{"];
    
    NSData *ret;
    
    if ([arr count]>1) {
        NSString *retString = [NSString stringWithFormat:@"%@}",[arr objectAtIndex:0]];
        ret = [retString dataUsingEncoding:NSUTF8StringEncoding];
        
    }
    else
    {
        ret = [[arr objectAtIndex:0]dataUsingEncoding:NSUTF8StringEncoding];
    }
    d=nil;

    RestLog(@"BLESWhereAmIRestHelper Connection %p finished loading:\n%@", connection, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

    if ([restApi.whereAmIRequestCompletedDelegate respondsToSelector:@selector(onWhereAmIRequestCompleted:withError:)]) {
        [restApi.whereAmIRequestCompletedDelegate onWhereAmIRequestCompleted:ret withError:nil ];
    }

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

    RestLog(@"BLESWhereAmIRestHelper Connection %p did fail with error %@", connection, error);

    if ([restApi.whereAmIRequestCompletedDelegate respondsToSelector:@selector(onWhereAmIRequestCompleted:withError:)]) {
        [restApi.whereAmIRequestCompletedDelegate onWhereAmIRequestCompleted:nil withError:error ];
    }
}
@end
