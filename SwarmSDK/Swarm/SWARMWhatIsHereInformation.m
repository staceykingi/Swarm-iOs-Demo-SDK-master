//
//  SWARMWhatIsHereInformation.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.31..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SWARMWhatIsHereInformation.h"
#import "SWARMLocationInformaion.h"
#import "BLESCampaign.h"
#import "SWARMAction.h"
@implementation SWARMWhatIsHereInformation
@synthesize locations;

-(NSArray*)getActions
{
    if (locations==nil) {
        return nil;
    }
    
    NSMutableArray *ret = [[NSMutableArray alloc]init];
    for (BLESCampaign *cms in [self getCampaigns]) {
        for (SWARMAction *sa in [cms coupons]) {
            [ret addObject:sa];
        }
    }
    return [NSArray arrayWithArray:ret];
    
}
-(NSArray*)getCampaigns
{
    if (locations==nil) {
        return nil;
    }
    
    NSMutableArray *ret = [[NSMutableArray alloc]init];
    for (SWARMLocationInformaion *sli in locations) {
        for (BLESCampaign *cmp in [sli campaigns]) {
            [ret addObject:cmp];
        }
    }
    return [NSArray arrayWithArray:ret];
}
@end
