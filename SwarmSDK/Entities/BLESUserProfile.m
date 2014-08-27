//
//  BLESUserProfile.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.08..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "BLESUserProfile.h"
#import "BLESMock.h"

@implementation BLESUserProfile
@synthesize userName;
@synthesize remoteId;
@synthesize desc;
@synthesize locationEventBase;

-(NSString*)toJson
{
    /*
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[self expiration]];*/
    
    NSDictionary *requestData = @{@"name": [self userName],
                                  @"desc": [self desc],
                                  @"remoteId": [self remoteId],
                                  @"ssv": [[[self locationEventBase] sourceSegmentVector]ssvDictionary],
                                  @"customerSwarmId": [[self locationEventBase] customerGearsId ],
                                  @"sourceId":[[self locationEventBase]customerSourceId]
                                  };
    
//    [requestData objectForKey:@"ssv"]
    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:requestData
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *tmpJson = [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    //TODO: error handling
    return tmpJson;
}

+(BLESUserProfile*)fromDictionary:(NSDictionary*)dictionary
{
    BLESUserProfile *up = [[BLESUserProfile alloc]init];
    
    [up setUserName:[dictionary objectForKey:@"name"]];
    [up setDesc:[dictionary objectForKey:@"desc"]];

    BLESCustomerLocationEvent *tmpLeb = [BLESMock getCustomerLocationEventSample];
    [tmpLeb setCustomerGearsId:[dictionary objectForKey:@"customerSwarmId"]];
    [tmpLeb setCustomerSourceId:[dictionary objectForKey:@"sourceId"]];
    [up setRemoteId:[dictionary objectForKey:@"remoteId"]];
    [tmpLeb setSourceSegmentVector:[SWARMSourceSegmentVector fromDictionary:[dictionary objectForKey:@"ssv"]]];
    
    
    [up setLocationEventBase:tmpLeb];
    return up;
}
@end
