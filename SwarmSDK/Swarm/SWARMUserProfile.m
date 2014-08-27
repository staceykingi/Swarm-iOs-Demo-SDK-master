//
//  SWARMUserProfile.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.31..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "SWARMUserProfile.h"

@implementation SWARMUserProfile

//@synthesize customerSourceId;
@synthesize customerSwarmId, remoteId, partnerId, userName, desc,sourceSegmentVector, vendorId, advertiserId;

-(NSString*)toJson
{
    
    NSDictionary *requestData = @{@"name": [self userName],
                                  @"desc": [self desc],
                                  @"remoteId": [self remoteId],
                                  @"sourceId": [self partnerId],
                                  @"ssv": [[self sourceSegmentVector]ssvDictionary],
                                  @"customerSwarmId": [self customerSwarmId],
                                  @"vendorId":[self vendorId],
                                  @"advertiserId":[self advertiserId]
                                  };
    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:requestData
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *tmpJson = [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    //TODO: error handling
    if (error)
    {
        return nil;
    }
    return tmpJson;
    
}

-(id)init
{
    self = [super init];
    if (self)
    {
        [self setSourceSegmentVector:[[SWARMSourceSegmentVector alloc]init]];
        [self setUserName:@""];
        [self setDesc:@""];
        [self setPartnerId:@"0"];
        [self setCustomerSwarmId:@"0"];
        [self setVendorId:@"0"];
        [self setAdvertiserId:@"0"];
    }
    return self;
}

+(SWARMUserProfile*)fromDictionary:(NSDictionary*)dictionary
{
    //TODO:implement
    SWARMUserProfile *up = [[SWARMUserProfile alloc]init];
    
    [up setUserName:[dictionary objectForKey:@"name"]];
    [up setDesc:[dictionary objectForKey:@"desc"]];
    
    
    [up setCustomerSwarmId:[dictionary objectForKey:@"customerSwarmId"]];
    //[up setCustomerSourceId:[dictionary objectForKey:@"sourceId"]];
    [up setRemoteId:[dictionary objectForKey:@"remoteId"]];
    [up setSourceSegmentVector:[SWARMSourceSegmentVector fromDictionary:[dictionary objectForKey:@"ssv"]]];
    [up setPartnerId:[dictionary objectForKey:@"sourceId"]];
    [up setVendorId:[dictionary objectForKey:@"vendorId"]];
    [up setAdvertiserId:[dictionary objectForKey:@"advertiserId"]];
    

    return up;
}

+(SWARMUserProfile*)copyProfile:(SWARMUserProfile*)profile filterForCategories:(NSArray*)categories
{
    SWARMUserProfile *up = [[SWARMUserProfile alloc]init];
    [up setUserName:[NSString stringWithString:[profile userName]]];
    [up setVendorId:[NSString stringWithString:[profile vendorId]]];
    [up setAdvertiserId:[NSString stringWithString:[profile advertiserId]]];
    [up setCustomerSwarmId:[NSString stringWithString:[profile customerSwarmId]]];
    [up setPartnerId:[NSString stringWithString:[profile partnerId]]];
    [up setRemoteId:[NSString stringWithString:[profile remoteId]]];
    
    SWARMSourceSegmentVector *ssv = [SWARMSourceSegmentVector copyVector:[profile sourceSegmentVector] onlyCategories:categories];
    
    [up setSourceSegmentVector:ssv];
    
    return up;
}
@end
