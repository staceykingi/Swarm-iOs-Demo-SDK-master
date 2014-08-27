//
//  SWARMNaicsCategorization.h
//  SwarmSDK
//
//  Created by Ákos Radványi on 2014.02.12..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SWARMStoreCategorization.h"

@interface SWARMNaicsCategorization : SWARMStoreCategorization
@property (strong,nonatomic) NSString *naicsCode;
-(NSDictionary*)getDictionary;
@end
