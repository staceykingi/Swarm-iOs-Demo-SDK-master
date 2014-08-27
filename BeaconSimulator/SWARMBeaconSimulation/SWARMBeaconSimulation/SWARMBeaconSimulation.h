//
//  SWARMBeaconSimulation.h
//  SWARMBeaconSimulation
//
//  Created by Ákos Radványi on 2014.02.14..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@protocol BeaconSimulationPeripheralUpdateDelegate;

@interface SWARMBeaconSimulation : NSObject <CBPeripheralManagerDelegate>
//sets up beacon to advertize. when a parameter is not ok, returns NO, when configuration was successful, returns YES
-(BOOL)initBeaconWithProximityUUID:(NSUUID*)uuid withMajor:(unsigned short)major withMinor:(unsigned short)minor withIdentifier:(NSString*)identifier;
//starts advertising when beacon is (re)configured
-(BOOL)startBeacon;
//stops advertising
-(void)stopBeacon;
@property (strong,nonatomic) CLBeaconRegion *beaconRegion;

@property (weak,nonatomic) id<BeaconSimulationPeripheralUpdateDelegate> beaconSimulationPeripheralUpdateDelegate;
@end

@protocol BeaconSimulationPeripheralUpdateDelegate <NSObject>
//tells you when transmission started. Happens when you start broadcasting, or if it was started, but bluetooth got turned off and on again
-(void)onPeripheralManagerBroadcastStarted;
//tells when advertising is stopped, eg. when bluetooth gets turned off
-(void)onPeripheralManagerBroadcastStopped;
@end
