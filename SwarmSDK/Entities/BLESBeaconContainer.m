//
//  BLESBeaconContainer.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.30..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "BLESBeaconContainer.h"
#import "SWARMBeacon.h"

@implementation BLESBeaconContainer
NSMutableArray *beaconsNear;
NSMutableArray *addedNow;

-(NSMutableArray*)addOrReplaceBeacon:(CLBeacon *)beacon filterProximity:(BOOL)filterImmediate
{
    NSMutableArray *ret = [[NSMutableArray alloc]init];
    
    
    
    
    
    return ret;
}

-(void)setNewBeacons:(NSMutableArray*)beacons
{
    addedNow = beacons;
}


-(void)setBeacons:(NSMutableArray*)beacons
{
    beaconsNear = beacons;
}

-(NSMutableArray*)getBeacons
{
    return beaconsNear;
}

-(NSMutableArray*)getNewBeacons
{
    return addedNow;
}

-(NSArray*)updateBeacons:(NSArray*)CLBeacons
{
    //will contain the list of beacons which have proximity transitions
    NSMutableArray *lastChangedSwarmBeacons = [[NSMutableArray alloc]init];
    //contains the list of beacons around
    NSMutableArray *swarmBeaconsNear = [[NSMutableArray alloc]init];
    
    //iterate through the list of the CLBeacons which the framwork just gave us
    for (CLBeacon *clBeacon in CLBeacons) {
        //check, if it was present before in the cycle before
        SWARMBeacon *tmpBeacon = [self getSWARMBeaconFromArray:beaconsNear withMajor:[clBeacon major] withMinor:[clBeacon minor]];
        //our little beacon just appeared, create a SWARMBeacon with a Lost->Near/Far/etc transtition
        if (tmpBeacon==nil) {
            tmpBeacon = [[SWARMBeacon alloc]initWithCLBeacon:clBeacon];
            //set old proximity Lost
            [tmpBeacon setProximityOld:@"L"];
            //add it to the seen beacons list
            [swarmBeaconsNear addObject:tmpBeacon];
            //and add it to the new ones as well
            [lastChangedSwarmBeacons addObject:tmpBeacon];
        }
        else
        {
            if ([[tmpBeacon proximityLetter]isEqualToString:@"L"]) {
                //it was lost, but we see it again - set old proximity to lost, and keep the new one
                [tmpBeacon setProximityOld:@"L"];
                //don't forget to set Lost to NO
                [tmpBeacon setLost:NO];
                [lastChangedSwarmBeacons addObject:tmpBeacon];
            }
            else
            {
            //the beacon was found, so it was already present - but did it's proximity change?
            if ([tmpBeacon proximity]!=[clBeacon proximity]) {
                //the proximity changed, set the new beacons exProximity accordingly
                NSString *oldPRX = [NSString stringWithString:[tmpBeacon proximityLetter]];
                tmpBeacon = [[SWARMBeacon alloc]initWithCLBeacon:clBeacon];
                [tmpBeacon setProximityOld:oldPRX];
                //add it to the recently changed beacon's list
                [lastChangedSwarmBeacons addObject:tmpBeacon];
                //add it to the nearby beacons list
                [swarmBeaconsNear addObject:tmpBeacon];
            }
            else
            {
                //it was present, proximity did not change, so just add it to the nearby list
                tmpBeacon = [[SWARMBeacon alloc]initWithCLBeacon:clBeacon];
                [tmpBeacon setProximityOld:[tmpBeacon proximityLetter]];
                
                [swarmBeaconsNear addObject:tmpBeacon];
            }
            }
        }
    }
    
    //now check the list of the previously seen beacons, whether any of the beacons disappeared
    for (SWARMBeacon *swb in beaconsNear) {
        CLBeacon *clb = [self getBeaconFromArray:CLBeacons withMajor:[swb major] withMinor:[swb minor]];
        if (clb ==nil) {
            [swb setProximityOld:[SWARMBeacon proximityToLetter:[swb proximity]]];
            [swb setLost:YES];
            //add to the changes list
            [lastChangedSwarmBeacons addObject:swb];
        }
    }
    
    beaconsNear = swarmBeaconsNear;
    addedNow = lastChangedSwarmBeacons;
    
    return beaconsNear;
}

-(NSArray*)updateBeaconsOld:(NSArray *)beacons
{
    NSMutableArray *newBeacons= [[NSMutableArray alloc]init];
    
    //Fill the newBeacons list
    //- new immediate beacons (was not in the list at all)
    for (CLBeacon *bc in beacons) {
        CLBeacon *tmpBeacon = [self getBeaconFromArray:beaconsNear withMajor:[bc major] withMinor:[bc minor]];
        if(tmpBeacon!=nil)
        {
            continue;
        }
        else
        {
            if ([bc proximity]== CLProximityImmediate) {
                [newBeacons addObject:bc];
            }
        }
        
    }
    
    //- was already present, but signal is stronger
    for (CLBeacon *bc in beacons) {
        CLBeacon *tmpBeacon = [self getBeaconFromArray:beaconsNear withMajor:[bc major] withMinor:[bc minor]];
        if(tmpBeacon!=nil)
        {
            if ([tmpBeacon proximity]!=CLProximityImmediate && [bc proximity]== CLProximityImmediate ) {
                [newBeacons addObject:bc];
            }
        }
    }
    
    
    //add new immediate beacons
    NSMutableArray *newBeaconsNear = [[NSMutableArray alloc]init];
    for (CLBeacon *bc in beacons) {
        if ([bc proximity]==CLProximityImmediate) {
            [newBeaconsNear addObject:bc];
        }
    }
    
    beaconsNear = newBeaconsNear;
    addedNow = newBeacons;
    
    return beaconsNear;
}


/**
 * Return the proximity of a beacon in an array. If the beacon is not in the array, or the
 **/
-(CLProximity)getBeaconProximity:(CLBeacon*)beacon inArray:(NSArray *)beaconArray
{
    
    for (CLBeacon *bc in beaconArray) {
        if ([[bc minor]isEqualToNumber:[beacon minor]] && [[bc major]isEqualToNumber:[beacon major]]) {
            return [bc proximity];
            
            
        }
    }
    return CLProximityFar;
}

/**
 * Get a beacon from an array by major:minor values. If beacon is not found, returns nil.
 **/
-(CLBeacon*)getBeaconFromArray:(NSArray*)array withMajor:(NSNumber*)major withMinor:(NSNumber*)minor
{
    
    for (CLBeacon *bc in array) {
        if ([[bc minor]isEqualToNumber:minor] && [[bc major]isEqualToNumber: major]) {
            return bc;
        }
    }
    return nil;
}

/**
 * Get a SWARMBeacon from an array by major:minor values. If beacon is not found, returns nil.
 **/
-(SWARMBeacon*)getSWARMBeaconFromArray:(NSArray*)array withMajor:(NSNumber*)major withMinor:(NSNumber*)minor
{
    
    for (SWARMBeacon *bc in array) {
        if ([[bc minor]isEqualToNumber:minor] && [[bc major]isEqualToNumber: major]) {
            return bc;
        }
    }
    return nil;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        beaconsNear = [[NSMutableArray alloc]init];
        addedNow = [[NSMutableArray alloc]init];
    }
    return self;
}

+(BOOL)didBeaconAppear:(CLBeacon*)beacon withArrays:(NSArray*)beaconsOld newList:(NSArray*)beaconsNow
{
    return ![BLESBeaconContainer isBeaconInArray:beacon inArray:beaconsOld] && [BLESBeaconContainer isBeaconInArray:beacon inArray:beaconsNow];
}

+(BOOL)didBeaconDisppear:(CLBeacon*)beacon withArrays:(NSArray*)beaconsOld newList:(NSArray*)beaconsNow
{
    return [BLESBeaconContainer isBeaconInArray:beacon inArray:beaconsOld] && ![BLESBeaconContainer isBeaconInArray:beacon inArray:beaconsNow];
}

+(BOOL)didBeaconProximityChange:(CLBeacon*)beaconBefore versus:(CLBeacon*)beaconNow
{
    return [beaconBefore proximity] != [beaconNow proximity];
}

+(BOOL)isBeaconInArray:(CLBeacon *)beacon inArray:(NSArray *)beaconArray
{    
    for (CLBeacon *bc in beaconArray) {
        if ([[bc minor]isEqualToNumber:[beacon minor]] && [[bc major]isEqualToNumber:[beacon major]]) {
            return YES;
        }
    }

    return NO;
}

@end
