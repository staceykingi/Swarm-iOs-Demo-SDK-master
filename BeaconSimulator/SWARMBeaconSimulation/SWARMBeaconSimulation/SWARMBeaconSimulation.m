//
//  SWARMBeaconSimulation.m
//  SWARMBeaconSimulation
//
//  Created by Ákos Radványi on 2014.02.14..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import "SWARMBeaconSimulation.h"

@implementation SWARMBeaconSimulation
{
    
    CBPeripheralManager *peripheralManager;
    NSDictionary *beaconPeripheralData;
}
@synthesize beaconSimulationPeripheralUpdateDelegate;
@synthesize beaconRegion;

-(BOOL)initBeaconWithProximityUUID:(NSUUID *)uuid withMajor:(unsigned short)major withMinor:(unsigned short)minor withIdentifier:(NSString *)identifier
{
    if (uuid== nil || identifier == nil) {
        return NO;
    }
    //TODO: verify parameters
    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                major:major
                                                                minor:minor
                                                           identifier:identifier];
    return YES;
}

- (BOOL)startBeacon {
    if (beaconRegion==nil) {
        return NO;
    }
    beaconPeripheralData = [beaconRegion peripheralDataWithMeasuredPower:nil];
    peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
    return YES;
}

-(void)stopBeacon
{
    [peripheralManager stopAdvertising];
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Powered On");
        [peripheralManager startAdvertising:beaconPeripheralData];
        if ([self.beaconSimulationPeripheralUpdateDelegate respondsToSelector:@selector(onPeripheralManagerBroadcastStarted)]) {
            [self.beaconSimulationPeripheralUpdateDelegate onPeripheralManagerBroadcastStarted];
        }
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"Powered Off");

        [peripheralManager stopAdvertising];
        if ([self.beaconSimulationPeripheralUpdateDelegate respondsToSelector:@selector(onPeripheralManagerBroadcastStopped)]) {
            [self.beaconSimulationPeripheralUpdateDelegate onPeripheralManagerBroadcastStopped];
        }
    }
}
@end
