//
//  BLESCouponTest.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.19..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SWARMAction.h"

@interface SWARMActionTest : XCTestCase

@end

@implementation SWARMActionTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testExample
{
    SWARMAction *cp =[[SWARMAction alloc] init];
    
    [cp setDesc:@"This is a demo coupon"];
    [cp setPictureUrl:@"http://192.168.10.100/coupon.png"];
    [cp setTitle:@"Xmas great deals"];
   // [cp setId:@"asdf1234" ];
    [cp setExpiration:[NSDate date]];
    
    NSString *serialized = [cp toJson];
    NSLog(serialized);
    
    SWARMAction *cpCopy = [SWARMAction fromJson:serialized];
    //TODO: check after agreed on date format
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
