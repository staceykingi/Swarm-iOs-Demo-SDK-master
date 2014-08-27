//
//  SWARMStoreCategorization.m
//  SwarmSDK
//
//  Created by Ákos Radványi on 2014.02.12..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SWARMStoreCategorization.h"

@implementation SWARMStoreCategorization
@synthesize category,subCategoryOne,subCategoryTwo;
-(id)init
{
    self = [super init];
    if (self) {
        [self setCategoryType:@"Swarm's Store Categorization"];
        [self setJsonKey:@"swarm"];
    }
    return self;
}

-(NSDictionary*)getDictionary
{
    return @{@"categoryType":[self categoryType],
             @"specialLogic":[self specialLogic],
             @"subCategoryOne":[self subCategoryOne],
             @"subCategoryTwo":[self subCategoryTwo]
            };
}
@end
