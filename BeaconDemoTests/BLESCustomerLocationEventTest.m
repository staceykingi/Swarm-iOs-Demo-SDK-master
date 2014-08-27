//
//  BLESCustomerLocationEventTest.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.07..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SWARMSourceSegmentVector.h"
#import "BLESCustomerLocationEvent.h"

@interface BLESCustomerLocationEventTest : XCTestCase

@end

@implementation BLESCustomerLocationEventTest

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
{/*
    BLESSourceSegmentVector *ssv = [[BLESSourceSegmentVector alloc]init];
    [ssv addTagToCategory:@"hiking" forCategory:@"hobbies"];
    [ssv addTagToCategory:@"skiing" forCategory:@"hobbies"];
    [ssv addTagToCategory:@"male" forCategory:@"gender"];

    BLESCustomerLocationEvent *cle = [[BLESCustomerLocationEvent alloc]init];
    [cle setPartnerId:@"yelp1234"];
    [cle setLocationId:@"tesco1"];
    [cle setCustomerSourceId:@"microsoftdynamics"];
    [cle setSourceSegmentVector:ssv];
    [cle setCustomerGearsId:@"gears1234"];
    [cle setEventTimestamp:[NSDate date]];
    
    NSString *outString =[cle toJson];
    NSLog(outString);
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);*/
}

@end
