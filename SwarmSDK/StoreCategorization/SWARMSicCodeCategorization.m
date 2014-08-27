//
//  SWARMSicCodeCategorization.m
//  SwarmSDK
//
//  Created by Ákos Radványi on 2014.02.12..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SWARMSicCodeCategorization.h"

@implementation SWARMSicCodeCategorization
@synthesize sicCode;
-(id)init
{
    self = [super init];
    if (self) {
        [self setCategoryType:@"SIC Code Categorization"];
        [self setJsonKey:@"sic"];
    }
    return self;
}

-(NSDictionary*)getDictionary
{
    return @{@"categoryType":[self categoryType],
             @"specialLogic":[self specialLogic],
             @"sicCode":[self sicCode]
            };
}
@end
