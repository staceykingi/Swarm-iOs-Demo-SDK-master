//
//  BLESCustomerLocationEvent.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.07..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "BLESCustomerLocationEvent.h"
#import "BLESUserProfile.h"
#import "BLESBeacon.h"

@implementation BLESCustomerLocationEvent
@synthesize sourceSegmentVector;
@synthesize customerGearsId;
@synthesize customerSourceId;
@synthesize partnerId;
@synthesize locationId;
@synthesize eventTimestamp;
@synthesize major;
@synthesize minor;

-(NSString *)toJson
{
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[self eventTimestamp]];
    
    NSDictionary *requestData = @{@"customerGearsId": [self customerSourceId],
                                  @"partnerId":[self partnerId ],
                                  @"customerSourceId":[self customerSourceId],
                                  @"sourceSegmentVector":[self.sourceSegmentVector ssvDictionary],
                                  @"locationId": [self locationId ],
                                  @"major":[self major],
                                  @"minor":[self minor],
                                  @"eventTimestamp":dateString};
    
    NSError *error;
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:requestData
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *tmpJson = [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    if (error!=nil) {
        return nil;
    }
    return tmpJson;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self setSourceSegmentVector:[[SWARMSourceSegmentVector alloc]init]];
    }
    return self;
}

+(BLESCustomerLocationEvent *)fromDictionary:(NSDictionary *)dictionary
{
    BLESCustomerLocationEvent *tmpCle = [[BLESCustomerLocationEvent alloc]init];
    
    NSString *customerSourceId = [dictionary objectForKey:@"customerSourceId"];
    NSString *customerGearsId = [dictionary objectForKey:@"customerGearsId"];
  //  NSString *eventTimestamp = [dictionary objectForKey:@"timestamp"];//[NSDate date]; //TODO
    NSString *locationId = [dictionary objectForKey:@"locationId"];
    NSMutableDictionary *ssvDict = [[NSMutableDictionary alloc]initWithDictionary:[dictionary objectForKey:@"sourceSegmentVector"]];
    
    
    [tmpCle setCustomerSourceId:customerSourceId];
    [tmpCle setCustomerGearsId:customerGearsId];
    [tmpCle setLocationId:locationId];
    [tmpCle setEventTimestamp:[NSDate date]];//eventTimestamp]; //TODO: check final format, and modify parsing if needed
    SWARMSourceSegmentVector *tmpSSV = [[SWARMSourceSegmentVector alloc]init];
    [tmpSSV setSsvDictionary:ssvDict];
    [tmpCle setSourceSegmentVector:tmpSSV];
    

    return tmpCle;
}

+(BLESCustomerLocationEvent*)fromUser:(BLESUserProfile*) userProfile withBeaconMajor:(NSNumber*)major withBeaconMinor:(NSNumber*)minor
{
    /*BLESCustomerLocationEvent *tmpCle = [[BLESCustomerLocationEvent alloc] init];
    [tmpCle setCustomerSourceId:[[userProfile locationEventBase]customer ]];
    [tmpCle setCustomerGearsId:customerGearsId];
    [tmpCle setLocationId:locationId];
    [tmpCle setEventTimestamp:[NSDate date]];
    [tmpCle setMajor:major];
    [tmpCle setMinor:minor];*/
   
//TODO:continue here
    return nil;
}

@end
