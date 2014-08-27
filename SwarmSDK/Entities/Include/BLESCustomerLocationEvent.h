//
//  BLESCustomerLocationEvent.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.07..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWARMSourceSegmentVector.h"

@interface BLESCustomerLocationEvent : NSObject
@property (retain,nonatomic) SWARMSourceSegmentVector *sourceSegmentVector;
@property (retain,nonatomic) NSDate *eventTimestamp;
@property (retain,nonatomic) NSString *customerGearsId;
@property (retain,nonatomic) NSString *partnerId;
@property (retain,nonatomic) NSString *locationId;
@property (retain,nonatomic) NSString *customerSourceId;
@property (retain,nonatomic) NSNumber *major;
@property (retain,nonatomic) NSNumber *minor;


-(NSString *)toJson;
+(BLESCustomerLocationEvent *)fromDictionary:(NSDictionary *)dictionary;

@end
