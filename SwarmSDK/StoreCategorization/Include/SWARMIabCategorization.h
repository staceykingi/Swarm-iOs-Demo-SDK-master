//
//  SWARMIabCategorization.h
//  SwarmSDK
//
//  Created by Ákos Radványi on 2014.02.12..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SWARMStoreCategorization.h"

@interface SWARMIabCategorization : SWARMStoreCategorization
@property (strong,nonatomic) NSString *iabTierOneCategory;
@property (strong,nonatomic) NSString *iabTierTwoCategory;
-(NSDictionary*)getDictionary;
@end
