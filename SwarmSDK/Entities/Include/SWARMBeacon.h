//
//  SWARMBeacon.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.13..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface SWARMBeacon : NSObject
@property (strong,nonatomic) NSString *proximityOld;
+(SWARMBeacon*)fromCLBeacon:(CLBeacon*)beacon;
-(NSUUID*)proximityUUID;
-(NSNumber*)major;
-(NSNumber*)minor;
-(CLProximity)proximity;
-(CLLocationAccuracy)accuracy;
-(NSInteger)rssi;
-(id)initWithCLBeacon:(CLBeacon*)beacon;
+(NSString*)proximityToLetter:(CLProximity)proximity;
-(NSString*)proximityLetter;
-(void)setLost:(BOOL)isBeaconLost;
@end
