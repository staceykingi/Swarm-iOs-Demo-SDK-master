//
//  SWARMNaicsCategorization.m
//  SwarmSDK
//
//  Created by Ákos Radványi on 2014.02.12..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SWARMNaicsCategorization.h"

@implementation SWARMNaicsCategorization
@synthesize naicsCode;
-(id)init
{
    self = [super init];
    if (self) {
        [self setCategoryType:@"NAICS Code Categorization"];
        [self setJsonKey:@"naucs"];
    }
    return self;
}

-(NSDictionary*)getDictionary
{
    return @{@"categoryType":[self categoryType],
             @"specialLogic":[self specialLogic],
             @"naicsCode":[self naicsCode]
            };
}

@end
