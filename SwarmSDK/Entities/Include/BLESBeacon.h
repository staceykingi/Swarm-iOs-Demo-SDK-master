//
//  BLESBeacon.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.07..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLESBeacon : NSObject
@property (retain,nonatomic) NSString *title;
@property (retain,nonatomic) NSString *desc;
@property (retain,nonatomic) NSString *uuid;
@property (retain, nonatomic) NSNumber *minor;
@property (retain, nonatomic) NSNumber *major;
@property (retain, nonatomic) NSString *regionId;
//-(NSDictionary*)getCategorization;
//-(NSDictionary*)getBrands;

//-(NSArray*)getCategorizationArray;
+(BLESBeacon *)fromDictionary:(NSDictionary *)dictionary;
@end
