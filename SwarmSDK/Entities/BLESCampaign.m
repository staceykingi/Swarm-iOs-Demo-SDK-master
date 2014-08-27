//
//  BLESCampaign.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.08..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "BLESCampaign.h"

@implementation BLESCampaign
@synthesize title;
@synthesize desc;
@synthesize campaignId;
@synthesize locationId;
@synthesize coupons;

+(BLESCampaign *)fromDictionary:(NSDictionary *)campaignDictionary
{
    BLESCampaign *cp = [[BLESCampaign alloc] init];
    
    NSString* cmpTitle = [campaignDictionary objectForKey:@"title"];
    NSString* cmpDesc = [campaignDictionary objectForKey:@"desc"];
    NSString* cmpId = [campaignDictionary objectForKey:@"id"];
    NSNumber *locId = [campaignDictionary objectForKey:@"locationId"];
    
    //TODO: non existing key exception?
    
    //TODO: dictionary is null?
    
    
    [cp setDesc:cmpDesc];
    [cp setTitle:cmpTitle];
    [cp setCampaignId:cmpId];
    [cp setLocationId:locId];
    return cp;
    
}

-(id)init
{
    self = [super init];
    if (self) {
        [self setCoupons:[[NSMutableArray alloc]init]];
    }
    return self;
}

@end
