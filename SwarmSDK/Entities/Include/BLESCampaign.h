//
//  BLESCampaign.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.08..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLESCampaign : NSObject
//Title of the campaign
@property (retain,nonatomic) NSString *title;
//Description of the campaign
@property (retain,nonatomic) NSString *desc;
//Id of the campaign. Can be used when requesting a coupon for a given campaign
@property (retain,nonatomic) NSString *campaignId;
//Id of the location this campaign belongs to
@property (retain,nonatomic) NSNumber *locationId;
//
@property (retain,nonatomic) NSMutableArray *coupons;

//Creates an instance from the data provided by the backend
+(BLESCampaign *)fromDictionary:(NSDictionary *)campaignDictionary;
@end
