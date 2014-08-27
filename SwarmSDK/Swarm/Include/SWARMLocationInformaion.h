//
//  SWARMLocationInformaion.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.31..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWARMLocationInformaion : NSObject
//Id of the department in the database
@property (strong,nonatomic) NSNumber *dbid;
//Name of the store
@property (strong,nonatomic) NSString *storeName;
//Type of the store
@property (strong,nonatomic) NSString *storeType;
//Address of the store
@property (strong,nonatomic) NSString *storeAddress;
//List of brands
@property (strong,nonatomic) NSArray *brands;
//SpecialLogic for brands
@property (strong,nonatomic) NSString *brandsSpecialLogic;
//Categories in differenct systems - subclasses of SWARMStoreCategoryBase
@property (strong,nonatomic) NSArray *categories;
//Short title of the beacon
@property (strong,nonatomic) NSString *title;
//Description of the department
@property (strong,nonatomic) NSString *desc;
//UUID of the beacon
@property (strong,nonatomic) NSString *uuid;
//Major number of the beacon
@property (strong,nonatomic) NSNumber *major;
//Minor number of the beacon
@property (strong,nonatomic) NSNumber *minor;

// Latitude number of User's iPhone (double type)
@property (strong,nonatomic) NSNumber *latitude;
// Longitude number of User's iPhone (double type)
@property (strong,nonatomic) NSNumber *longitude;

@property (strong,nonatomic) NSMutableArray *campaigns;

//Is there beacon data stored in this instance?
@property (nonatomic) BOOL hasBeaconInfo;
//Is there location data present?
@property (nonatomic) BOOL hasGeodata;
//Create a new instance from the dictionary provided by the REST call
+(SWARMLocationInformaion*)locationInformationFromDictionary:(NSDictionary*)dictionary hasBeaconInfo:(BOOL)hasBeaconInfo hasGeodata:(BOOL)hasGeodata;
//Used for debugging
-(NSString*)toString;
@end
