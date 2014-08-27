//
//  SWARMSicCodeCategorization.h
//  SwarmSDK
//
//  Created by Ákos Radványi on 2014.02.12..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import "SWARMStoreCategorization.h"

@interface SWARMSicCodeCategorization : SWARMStoreCategorization
@property (strong,nonatomic) NSString *sicCode;
-(NSDictionary*)getDictionary;
@end
