//
//  SWARMBeacon.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.13..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SWARMBeacon.h"

@implementation SWARMBeacon
{
    CLBeacon *beaconRef;
    BOOL isLost;
}

@synthesize proximityOld;



-(NSUUID*)proximityUUID
{
    return [beaconRef proximityUUID];
}

-(NSNumber*)major
{
    return [beaconRef major];
}

-(NSNumber*)minor
{
    return [beaconRef minor];
}

-(CLProximity)proximity
{
    return [beaconRef proximity];
}

-(NSString*)proximityLetter
{
    if (isLost) {
        return @"L";
    }
    return [SWARMBeacon proximityToLetter:beaconRef.proximity];
}

-(CLLocationAccuracy)accuracy
{
    return [beaconRef accuracy];
}

-(NSInteger)rssi
{
    return [beaconRef rssi];
}

-(id)initWithCLBeacon:(CLBeacon*)beacon
{
    self = [super init];
    if (self) {
        beaconRef = beacon;
        isLost = NO;
    }
    return self;
}

-(void)setLost:(BOOL)isBeaconLost
{
    isLost = isBeaconLost;
}

+(SWARMBeacon*)fromCLBeacon:(CLBeacon *)beacon
{
    SWARMBeacon *bc = [[SWARMBeacon alloc]initWithCLBeacon:beacon];
    [bc setProximityOld:@"L"];
    return bc;
}

+(NSString*)proximityToLetter:(CLProximity)proximity
{
    if ( proximity== CLProximityFar) {
        return @"F";
    }
    if (proximity==CLProximityImmediate) {
        return @"I";
    }
    if (proximity==CLProximityNear) {
        return @"N";
    }
    if (proximity==CLProximityUnknown) {
        return @"U";
    }
    return @"X";
}
@end
