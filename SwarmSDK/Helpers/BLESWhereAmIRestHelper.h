//
//  BLESWhereAmIRestHelper.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.04..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLESRestApi.h"

@interface BLESWhereAmIRestHelper : NSObject <NSURLConnectionDataDelegate>
@property (strong, nonatomic) BLESRestApi *restApi;
@property (nonatomic) BOOL isPersonalized;
@property (strong,nonatomic) NSMutableData *d;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
-(void)connectionDidFinishLoading:(NSURLConnection *)connection;
@end
