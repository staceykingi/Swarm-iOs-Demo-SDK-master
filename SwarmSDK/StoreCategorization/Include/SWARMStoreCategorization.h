//
//  SWARMStoreCategorization.h
//  SwarmSDK
//
//  Created by Ákos Radványi on 2014.02.12..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWARMStoreCategoryBase.h"
@interface SWARMStoreCategorization : SWARMStoreCategoryBase
@property (strong,nonatomic) NSString *category;
@property (strong,nonatomic) NSString *subCategoryOne;
@property (strong,nonatomic) NSString *subCategoryTwo;
-(NSDictionary*)getDictionary;
@end
