//
//  BLESAction.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.19..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLESAction : NSObject

//Description of the action
@property (nonatomic, retain) NSString * desc;
//Optional url for a picture or a barcode
@property (nonatomic, retain) NSString * pictureUrl;
//Title of the action, can be the same as the campaigns title
@property (nonatomic, retain) NSString * title;
//External url for more details, forms
@property (strong, nonatomic) NSString *externalUrl;
//Expiration date
@property (nonatomic, retain) NSDate * expiration;
//ActionId used in the services
@property (nonatomic, retain) NSString * actionId;
//Status of the action, 'new', 'accepted'
@property (nonatomic, retain) NSString * status;
//Optional field, it can contain a text which you can show after redeeming the action
@property (nonatomic, retain) NSString *deliveryText;

//Helper functions for the SDK
-(NSString *)toJson;
-(NSDictionary*)toDictionary;
+(BLESAction *)fromJson:(NSString *)jsonString;
+(BLESAction *)fromDictionary:(NSDictionary *)actionDictionary;
-(NSString*)expirationAsString;

@end
