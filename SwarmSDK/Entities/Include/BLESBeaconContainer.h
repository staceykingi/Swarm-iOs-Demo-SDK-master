//
//  BLESBeaconContainer.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.30..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface BLESBeaconContainer : NSObject
-(NSMutableArray*)addOrReplaceBeacon:(CLBeacon*)beacon filterProximity:(BOOL)filterImmediate;
-(NSArray*)updateBeacons:(NSArray*)beacons;
-(NSMutableArray*)getBeacons;
-(NSMutableArray*)getNewBeacons;

//for internal use inside the SDK, never-ever call it directly
-(void)setNewBeacons:(NSMutableArray*)beacons;
-(void)setBeacons:(NSMutableArray*)beacons;



//Checks an array for a beacon with the same Major and Minor values as the given beacon
+(BOOL)isBeaconInArray:(CLBeacon *)beacon inArray:(NSArray *)beaconArray;

+(BOOL)didBeaconProximityChange:(CLBeacon*)beaconBefore versus:(CLBeacon*)beaconNow;
+(BOOL)didBeaconAppear:(CLBeacon*)beacon withArrays:(NSArray*)beaconsOld newList:(NSArray*)beaconsNow;
+(BOOL)didBeaconDisppear:(CLBeacon*)beacon withArrays:(NSArray*)beaconsOld newList:(NSArray*)beaconsNow;

@end
