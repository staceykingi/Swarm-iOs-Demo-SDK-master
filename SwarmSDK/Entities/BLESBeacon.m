//
//  BLESBeacon.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.07..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "BLESBeacon.h"
#import "SWARMStoreCategorization.h"

@implementation BLESBeacon
{
    @protected NSMutableArray *storeCategories;
    
}
@synthesize title;
@synthesize desc;
@synthesize minor;
@synthesize major;
@synthesize uuid;
@synthesize regionId;

-(id)init
{
    self = [super init];
    if (self)
    {
        storeCategories = [[NSMutableArray alloc]init];
    }
    return self;
}

/**
 * Add a categorization objec to the storeCategories dictionary
 * In case the same type is already present, it will be replaced
 **/
-(void)addCategorization:(SWARMStoreCategoryBase*)categorization
{
    //input not nil?
    if (categorization == nil) {
        return;
    }
    
    SWARMStoreCategoryBase *tmpRef = nil;
    //check, if the given categorization type already exists
    for (SWARMStoreCategoryBase *ssc in storeCategories) {
        if ([[ssc categoryType] isEqualToString:[categorization categoryType]]) {
            tmpRef = ssc;
        }
    }
    
    //if the object is present, remove it
    if (tmpRef!=nil) {
        [storeCategories removeObject:tmpRef];
    }
    
    //add the new one
    [storeCategories addObject:categorization];
}




/**
 * For DEMO
 * Create a beacon instance from the server's json
 **/
+(BLESBeacon *)fromDictionary:(NSDictionary *)dictionary
{
    BLESBeacon *bc = [[BLESBeacon alloc]init];
    [bc setTitle:[dictionary objectForKey:@"title"]];
    if ([bc title]==[NSNull null]) {
        [bc setTitle:@""];
    }
    
    [bc setDesc:[dictionary objectForKey:@"desc"]];
    if ([bc desc]==[NSNull null]) {
        [bc setDesc:@""];
    }
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *minor = [f numberFromString:[dictionary objectForKey:@"minor"]];
    NSNumber *major = [f numberFromString:[dictionary objectForKey:@"major"]];
        
    //TODO: exception handling?
    [bc setMinor:minor];
    [bc setMajor:major];
    [bc setUuid:[dictionary objectForKey:@"uuid"]];
    [bc setRegionId:[dictionary objectForKey:@"id"]];
    
    //TODO: populate categorization
    
    return bc;
}

/**
 * Returns an array of SWARMStoreCategoryBase objects which 
 * describe the store in different category systems
 **/
-(NSArray*)getCategorizationArray
{
    NSMutableArray *ret = [[NSMutableArray alloc]init];
    for (SWARMStoreCategoryBase *scb in storeCategories) {
        [ret addObject:scb];
    }
    
    return [NSArray arrayWithArray:ret];
}


//For developing purposes, to generate json representation
-(NSDictionary*)getCategorizationSample
{
    return @{
                @"swarm": @{@"category":@"m_field_id_29",
                            @"subcategory1":@"m_field_id_30",
                            @"subcategory2":@"m_field_id_31",
                            @"speciallogic":@"we'll find out later what this is"},
                @"sic":   @{@"siccode":@"m_field_id_107",
                            @"speciallogic":@"stg else"},
                @"naics": @{@"naicscode": @"m_field_id_108",
                            @"speciallogic": @"stg else else"},
                @"iab":   @{@"tier1": @"m_field_id_109",
                            @"tier2": @"m_field_id_110",
                            @"speciallogic":@"guess what"}
                };
}

-(NSDictionary*)getBrandsSample
{
    return @{@"brand1": @"m_field_id_111",
             @"brand2": @"m_field_id_112",
             @"brand3": @"m_field_id_113",
             @"brand4": @"m_field_id_114",
             @"brand5": @"m_field_id_115",
             @"brand6": @"m_field_id_116",
             @"brand7": @"m_field_id_117",
             @"brand8": @"m_field_id_118",
             @"brand9": @"m_field_id_119",
             @"brand10": @"m_field_id_120",
             @"speciallogic": @"at least one brand"
            };
}
@end
