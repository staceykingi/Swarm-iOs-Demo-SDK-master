//
//  BLESUserProfile.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.08..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLESCustomerLocationEvent.h"

@interface BLESUserProfile : NSObject
@property (retain,nonatomic) NSString *userName;
@property (retain,nonatomic) NSString *remoteId;
@property (retain,nonatomic) NSString *desc;
@property (retain,nonatomic) BLESCustomerLocationEvent *locationEventBase;
-(NSString*)toJson;
+(BLESUserProfile*)fromDictionary:(NSDictionary*)dictionary;
@end
