//
//  SWARMLocationInformaion.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.31..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SWARMLocationInformaion.h"
#import "SWARMStoreCategoryBase.h"

@implementation SWARMLocationInformaion

@synthesize dbid, major, minor;
@synthesize storeName, storeAddress, storeType, latitude, longitude;
@synthesize title,desc,uuid;
@synthesize hasBeaconInfo, hasGeodata;
@synthesize brands,brandsSpecialLogic,categories, campaigns;

+(SWARMLocationInformaion*)locationInformationFromDictionary:(NSDictionary*)dictionary hasBeaconInfo:(BOOL)hasBeaconInfo hasGeodata:(BOOL)hasGeodata
{
    SWARMLocationInformaion *ret = [[SWARMLocationInformaion alloc]init];
    
    if (hasGeodata) {
        [ret setDbid:[dictionary objectForKey:@"id"]];
        [ret setStoreAddress:[dictionary objectForKey:@"storeAddress"]];
        [ret setStoreName:[dictionary objectForKey:@"storeName"]];
        [ret setStoreType:[dictionary objectForKey:@"storeType"]];
        [ret setBrandsSpecialLogic:[NSString stringWithString:[[dictionary objectForKey:@"brands"] objectForKey:@"specialLogic"]]];
        [ret setBrands:[NSArray arrayWithArray: [[dictionary objectForKey:@"brands"] objectForKey:@"list"]]];
        NSLog(@"Brands count: %lu",(unsigned long)[[ret brands]count]);
        [ret setCategories:[SWARMStoreCategoryBase getStoreCategorizationArrayFromDictionary:[dictionary objectForKey:@"categorization"]]];
        [ret setLatitude:[dictionary objectForKey:@"latitude"]];
        [ret setLongitude:[dictionary objectForKey:@"longitude"]];
        [ret setHasGeodata:YES];
    }
    else
    {
        [ret setHasGeodata:NO];
    }
    
    if (hasBeaconInfo) {
        [ret setUuid:[dictionary objectForKey:@"uuid"]];
        [ret setTitle:[dictionary objectForKey:@"title"]];
        [ret setDesc:[dictionary objectForKey:@"desc"]];
        [ret setMajor:[dictionary objectForKey:@"major"]];
        [ret setMinor:[dictionary objectForKey:@"minor"]];
        [ret setHasBeaconInfo:YES];
    }
    else
    {
        [ret setHasBeaconInfo:NO];
    }
    
    return ret;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self setCampaigns:[[NSMutableArray alloc]init]];
    }
    
    return self;
}

-(NSString*)toString
{
    NSMutableString *txtBrands = [[NSMutableString alloc]init];
    for (NSString *brand in [self brands]) {
        [txtBrands appendString:[NSString stringWithFormat:@"%@ ",brand]];
    }
    
    [txtBrands appendString:@", categories: "];
    for (SWARMStoreCategoryBase *sscb in [self categories]) {
        [txtBrands appendString:[sscb toJsonString]];
    }
    
    return [NSString stringWithFormat:@"(id: %@, storeAddress: %@, storeName: %@, storeType: %@, latitude: %@, longitude: %@, brands: %@)\n",[self dbid],[self storeAddress],[self storeName],[self storeType], [self latitude], [self longitude], txtBrands];
}
@end
