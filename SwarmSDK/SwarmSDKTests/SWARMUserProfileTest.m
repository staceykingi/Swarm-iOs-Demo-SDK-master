//
//  SWARMUserProfileTest.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.19..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SWARMUserProfile.h"

@interface SWARMUserProfileTest : XCTestCase
@property (strong,nonatomic) SWARMUserProfile *testProfile;
@end

@implementation SWARMUserProfileTest
@synthesize testProfile;
- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    NSLog(@"Testing SWARMUserProfile...");
    testProfile = [[SWARMUserProfile alloc]init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testExample
{
    
    [testProfile setCustomerSwarmId:@"testCustomerSwarmId"];
    XCTAssertTrue([[testProfile customerSwarmId]isEqualToString:@"testCustomerSwarmId"]);
    
    [testProfile setRemoteId:@"testRemoteId"];
    XCTAssertTrue([[testProfile remoteId]isEqualToString:@"testRemoteId"]);
    
    [testProfile setCustomerSourceId:@"testCustomerSourceId"];
    XCTAssertTrue([[testProfile customerSourceId]isEqualToString:@"testCustomerSourceId"]);
    
    [testProfile setPartnerId:@"testPartnerId"];
    XCTAssertTrue([[testProfile partnerId]isEqualToString:@"testPartnerId"]);
    
    [testProfile setUserName:@"userNameTest"];
    XCTAssertTrue([[testProfile userName] isEqualToString:@"userNameTest"]);
    
    [testProfile setDesc:@"testDesc"];
    XCTAssertTrue([[testProfile desc] isEqualToString:@"testDesc"]);
    
    XCTAssertNotNil([testProfile sourceSegmentVector]);
    
    [testProfile setVendorId:@"testVendorId"];
    XCTAssertTrue([[testProfile vendorId]isEqualToString:@"testVendorId"]);
    
    [testProfile setAdvertiserId:@"testAdvertiserId"];
    XCTAssertTrue([[testProfile advertiserId]isEqualToString:@"testAdvertiserId"]);
    
    NSLog(@"%@", [testProfile toJson]);
    
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


@end
