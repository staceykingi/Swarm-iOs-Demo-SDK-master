//
//  BLESUserProfileTest.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.09..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BLESUserProfile.h"
#import "BLESMock.h"

@interface BLESUserProfileTest : XCTestCase

@end

@implementation BLESUserProfileTest

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
    BLESUserProfile *up = [[BLESUserProfile alloc]init];
    [up setUserName:@"Tyler"];
    [up setDesc:@"Tyler, the rich millionaire"];
    [up setRemoteId:@"yelpId"];
    BLESCustomerLocationEvent *cle = [BLESMock getCustomerLocationEventSample];
    [cle setPartnerId:@"yelp"];
    [cle setSourceSegmentVector:[BLESMock getSourceSegmentVectorSample]];
    
    [up setLocationEventBase:cle];
    
    NSLog([up toJson]);
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
