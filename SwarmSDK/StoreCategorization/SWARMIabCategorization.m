//
//  SWARMIabCategorization.m
//  SwarmSDK
//
//  Created by Ákos Radványi on 2014.02.12..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SWARMIabCategorization.h"

@implementation SWARMIabCategorization
@synthesize iabTierOneCategory;
@synthesize iabTierTwoCategory;
-(id)init
{
    self = [super init];
    if (self) {
        [self setCategoryType:@"IAB Code Categorization"];
    }
    return self;
}

-(NSDictionary*)getDictionary
{
    return @{@"categoryType":[self categoryType],
             @"specialLogic":[self specialLogic],
             @"iabTierOneCategory":[self iabTierOneCategory],
             @"iabTierTwoCategory":[self iabTierTwoCategory]
            };
}

@end
