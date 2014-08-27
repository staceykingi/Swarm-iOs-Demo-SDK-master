//
//  BLESBeaconTest.m
//  SwarmSDK
//
//  Created by Ákos Radványi on 2014.02.12..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BLESBeacon.h"
#import "SWARMHelpers.h"

@interface BLESBeaconTest : XCTestCase

@end

@implementation BLESBeaconTest

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
    BLESBeacon *bc = [[BLESBeacon alloc]init];
    //NSLog(@"%@",[SWARMHelpers dictionaryToJson:[bc getBrands]]);
    //NSLog(@"%@",[SWARMHelpers dictionaryToJson:[bc getCategorization]]);
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
