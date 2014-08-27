//
//  BLESSourceSegmentVectorTest.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.07..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SWARMSourceSegmentVector.h"

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
    NSLog(@"Testing SWARMSourceSegmentVector...");
    SWARMSourceSegmentVector *ssv = [[SWARMSourceSegmentVector alloc]init];
    [ssv addTagToCategory:@"hiking" forCategory:@"hobbies"];
    [ssv addTagToCategory:@"skiing" forCategory:@"hobbies"];
    [ssv addTagToCategory:@"male" forCategory:@"gender"];
    
    NSLog(@"SSV filled");
    
    XCTAssertEqual([[ssv getCategoryNames]count],(NSUInteger)2 );
    XCTAssertEqual([[ssv getTagsInCategory:@"hobbies"]count], (NSUInteger)2);
    XCTAssertEqual([[ssv getTagsInCategory:@"gender"]count],(NSUInteger)1);
    XCTAssertTrue([[[ssv getTagsInCategory:@"gender"]firstObject]isEqualToString:@"male"]);
    
    
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
