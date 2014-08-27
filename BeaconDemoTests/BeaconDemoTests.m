//
//  BeaconDemoTests.m
//  BeaconDemoTests
//
//  Created by Ákos Radványi on 2013.12.11..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BLESRestApi.h"

@interface BeaconDemoTests : XCTestCase

@end

@implementation BeaconDemoTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    BLESRestApi *restApi = [[BLESRestApi alloc]init];
    NSDate *tmpDate = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    NSString *dateString = @"2014-02-19 13:27:00:245";
    [restApi setApiKey:@"D57092AC-DFAA-446C-8EF3-C81AA22815B5"];
    tmpDate = [dateFormatter dateFromString:dateString];
    //[dateFormatter stringFromDate:tmpDate];
    
    
    NSLog(@"Date: %@, Api-key: %@",dateString, [restApi apiKey]);

    NSLog(@"ParnedID: %@ UserId: %@ Hash: %@",@"yelp",@"tyler",
          [restApi getHMACForPartner:@"" forUserId:@"" withTimestamp:tmpDate]);
    
    NSLog(@"ParnedID: %@ UserId: %@ Hash: %@",@"yelp",@"-",
          [restApi getHMACForPartner:@"yelp" forUserId:@"" withTimestamp:tmpDate]);
    
    NSLog(@"ParnedID: %@ UserId: %@ Hash: %@",@"yelp",@"tyler",
          [restApi getHMACForPartner:@"yelp" forUserId:@"tyler" withTimestamp:tmpDate]);
    
    NSLog(@"ParnedID: %@ UserId: %@ Hash: %@",@"-",@"-",
          [restApi getHMACForPartner:@"" forUserId:@"" withTimestamp:tmpDate]);
    
    NSLog(@"ParnedID: %@ UserId: %@ Hash: %@",@"yelp",@"-",
          [restApi getHMACForPartner:@"yelp" forUserId:@"" withTimestamp:tmpDate]);
    
    NSLog(@"ParnedID: %@ UserId: %@ Hash: %@",@"yelp",@"anne",
          [restApi getHMACForPartner:@"yelp" forUserId:@"anne" withTimestamp:tmpDate]);

    [restApi getHMACSignature:@"tyler" withSalt:[restApi apiKey]];
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
