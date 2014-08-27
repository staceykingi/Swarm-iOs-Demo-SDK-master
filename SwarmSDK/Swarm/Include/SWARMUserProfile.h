//
//  SWARMUserProfile.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.31..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWARMSourceSegmentVector.h"

@interface SWARMUserProfile : NSObject
//the customer's id in our backend
@property (retain,nonatomic) NSString *customerSwarmId;
//the user's id in your database
@property (retain,nonatomic) NSString *remoteId;
//an id which identifies the user of this sdk
@property (retain,nonatomic) NSString *partnerId;
//the name of the user
@property (retain,nonatomic) NSString *userName;
//optional description of the user
@property (retain,nonatomic) NSString *desc;
//the users interests in a multimap
@property (retain,nonatomic) SWARMSourceSegmentVector *sourceSegmentVector;
//Id tracking every app by the same developer e.g. (Apple's identifierForVendor)
@property (strong,nonatomic) NSString *vendorId;
//Unique advertiser identifier for phone e.g. (Apple's identifierForAdvertising)
// Gan's mark
@property (strong,nonatomic) NSString *advertiserId;
//customized json serialization
-(NSString*)toJson;
+(SWARMUserProfile*)fromDictionary:(NSDictionary*)dictionary;
+(SWARMUserProfile*)copyProfile:(SWARMUserProfile*)profile filterForCategories:(NSArray*)categories;
@end
