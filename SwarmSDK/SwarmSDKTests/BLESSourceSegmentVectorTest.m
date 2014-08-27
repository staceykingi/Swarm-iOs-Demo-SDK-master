//
//  BLESSourceSegmentVectorTest.m
//  SwarmSDK
//
//  Created by Ákos Radványi on 2014.02.11..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BLESSourceSegmentVector.h"

@interface BLESSourceSegmentVectorTest : XCTestCase

@end

@implementation BLESSourceSegmentVectorTest

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
    BLESSourceSegmentVector *ssv = [[BLESSourceSegmentVector alloc]init];
    [ssv addTagToCategory:@"male" forCategory:@"gender"];
    XCTAssertTrue([[ssv getCategoryNames]count]==1);
    XCTAssert([[NSString stringWithString:@"male"] isEqualToString:[[ssv getTagsInCategory:@"gender"]firstObject]]);
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
