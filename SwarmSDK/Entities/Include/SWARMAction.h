//
//  BLESCoupon.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.19..
//  Copyright (c) 2013 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWARMAction : NSObject

//Description of the coupon
@property (nonatomic, strong) NSString * desc;
//Optional url for a picture or a barcode
@property (nonatomic, strong) NSString * pictureUrl;
//Title of the coupon, can be the same as the campaigns title
@property (nonatomic, strong) NSString * title;
//External url for more details, forms
@property (strong, nonatomic) NSString *externalUrl;
//Expiration date
@property (nonatomic) NSInteger expiration;
//CouponId used in the services
@property (nonatomic, strong) NSString * actionId;
//Status of the coupon, 'new', 'accepted'
@property (nonatomic, strong) NSString * status;
//Optional field, it can contain a text which you can show after redeeming the coupon
@property (nonatomic, strong) NSString *deliveryText;
//Id of the campaign this coupon belongs to
@property (nonatomic, strong) NSNumber *campaignId;

//Helper functions for the SDK
-(NSString *)toJson;
-(NSDictionary*)toDictionary;
+(SWARMAction *)fromJson:(NSString *)jsonString;
+(SWARMAction *)fromDictionary:(NSDictionary *)actionDictionary;
-(NSString*)expirationAsString;
+(NSString*)getStringNullable:(NSString*)otherString;

@end
