//
//  SWARMStoreCategory.h
//  SwarmSDK
//
//  Created by Ákos Radványi on 2014.02.12..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWARMStoreCategoryBase : NSObject
@property (strong,nonatomic) NSString *specialLogic;
@property (strong,nonatomic) NSString *categoryType;

//Used in the SDK, you won't need it:
@property (strong,nonatomic) NSString *jsonKey;
-(NSDictionary*)getDictionary;
//+(SWARMStoreCategoryBase*)fromDictionary:(NSDictionary*)dict;
+(SWARMStoreCategoryBase*)fromDictionary:(NSDictionary*)dict withType:(NSString*) categoryType;
+(NSArray*)getStoreCategorizationArrayFromDictionary:(NSDictionary*)dict;
-(NSString*)toJsonString;
@end
