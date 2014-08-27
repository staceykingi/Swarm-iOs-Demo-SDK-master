//
//  SWARMStoreCategory.m
//  SwarmSDK
//
//  Created by Ákos Radványi on 2014.02.12..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SWARMStoreCategoryBase.h"
#import "SWARMStoreCategorization.h"
#import "SWARMSicCodeCategorization.h"
#import "SWARMNaicsCategorization.h"
#import "SWARMIabCategorization.h"
#import "SWARMHelpers.h"

@implementation SWARMStoreCategoryBase
@synthesize specialLogic,categoryType,jsonKey;
-(id)init
{
    self = [super init];
    if (self) {
        [self setCategoryType:@"SWARMStoreCategory base class"];
        [self setJsonKey:@"storeCategoryBase"];
    }
    return self;
}

-(NSDictionary*)getDictionary
{
    return @{@"categoryType":[self categoryType],@"specialLogic":[self specialLogic]};
}

+(SWARMStoreCategoryBase*)fromDictionary:(NSDictionary*)dict withType:(NSString*)categoryType
{
    if ([categoryType isEqualToString:@"swarm"]) {
        SWARMStoreCategorization *ssc = [[SWARMStoreCategorization alloc]init];
        [ssc setCategory:[dict objectForKey:@"category"]];
        [ssc setSubCategoryOne:[dict objectForKey:@"subcategory1"]];
        [ssc setSubCategoryTwo:[dict objectForKey:@"subcategory2"]];
        [ssc setSpecialLogic:[dict objectForKey:@"speciallogic"]];
        return ssc;
    }
    
    if ([categoryType isEqualToString:@"sic"]) {
        SWARMSicCodeCategorization *sscc = [[SWARMSicCodeCategorization alloc]init];
        [sscc setSpecialLogic:[dict objectForKey:@"speciallogic"]];
        [sscc setSicCode:[dict objectForKey:@"siccode"]];
        return sscc;
    }
    
    if ([categoryType isEqualToString:@"naics"]) {
        SWARMNaicsCategorization *snc = [[SWARMNaicsCategorization alloc]init];
        [snc setNaicsCode:[dict objectForKey:@"naicscode"]];
        [snc setSpecialLogic:[dict objectForKey:@"speciallogic"]];
        return snc;
    }
    
    if ([categoryType isEqualToString:@"iab"]) {
        SWARMIabCategorization *sic = [[SWARMIabCategorization alloc]init];
        [sic setSpecialLogic:[dict objectForKey:@"speciallogic"]];
        [sic setIabTierOneCategory:[dict objectForKey:@"tier1"]];
        [sic setIabTierTwoCategory:[dict objectForKey:@"tier2"]];
        return sic;
    }
    
    return nil;
}

+(NSArray*)getStoreCategorizationArrayFromDictionary:(NSDictionary*)dict
{
    NSMutableArray *ret = [[NSMutableArray alloc]init ];
    
    for (NSString *tmpKey in [dict allKeys]) {
        SWARMStoreCategoryBase *scb = [SWARMStoreCategoryBase fromDictionary:[dict objectForKey:tmpKey] withType:tmpKey];
        if (scb!=nil) {
            [ret addObject:scb];
        }
        else
        {
            NSLog(@"%@",@"Store category object could not be parsed and was skipped.");
        }
    }
    
    return [NSArray arrayWithArray:ret];
}

-(NSString*)toJsonString
{
    return [SWARMHelpers dictionaryToJson:[self getDictionary]];
}

@end
