//
//  BLESWhatIsHereRestHelper.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.07..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLESRestApi.h"
@interface BLESWhatIsHereRestHelper : NSObject  <NSURLConnectionDataDelegate>

@property (strong,nonatomic) BLESRestApi *restApi;
//@property (nonatomic) BOOL isPersonalized;
@property (strong,nonatomic) NSMutableData *d;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
-(void)connectionDidFinishLoading:(NSURLConnection *)connection;
@end
