//
//  BLESAction.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.19..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//

#import "BLESAction.h"

@implementation BLESAction

@synthesize desc;
@synthesize pictureUrl;
@synthesize title;
@synthesize expiration;
@synthesize actionId;
@synthesize status;
@synthesize deliveryText;
@synthesize externalUrl;

-(NSString *)toJson
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[self expiration]];
    
    NSDictionary *requestData = @{@"title": [self title],
                                  @"text": [self desc],
                                  @"pictureurl": [self pictureUrl],
                                  @"expiration": dateString,
                                  @"id": [self actionId],
                                  @"deliveryText": [self deliveryText],
                                  @"externalUrl":[self externalUrl]
                                  };
    
    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:requestData
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *tmpJson = [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    //TODO: error handling
    return tmpJson;
}

-(NSString*)expirationAsString
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[self expiration]];

    return dateString;
}

+(BLESAction *)fromJson:(NSString *)jsonString
{
    BLESAction *cp = [[BLESAction alloc] init];
    //TODO: replace with deserialization
    //TODO: error handling
    [cp setDesc:@"This is a demo action"];
    [cp setPictureUrl:@"http://192.168.10.100/action.png"];
    [cp setTitle:@"Xmas great deals"];
    [cp setActionId:@"asdf1234" ];
    [cp setExpiration:[NSDate date]];
    [cp setStatus:@"accepted"];
    [cp setDeliveryText:@"deliverytext"];
    [cp setExternalUrl:@""];
    
    //TODO: parse as a dictionary and call fromDictionary - return created action ref
    return cp;
}

+(BLESAction *)fromDictionary:(NSDictionary *)actionDictionary
{
    BLESAction *cp = [[BLESAction alloc] init];
    
    NSString* CPtitle = [actionDictionary objectForKey:@"title"];
    NSString* CPdesc = [actionDictionary objectForKey:@"text"];
    NSString* CPpicurl = [actionDictionary objectForKey:@"url"];
    NSString* CPid = [actionDictionary objectForKey:@"id"];
    
    if (CPid==nil) {
        CPid = @"noid";
    }
    NSString* CPstatus = [actionDictionary objectForKey:@"status"];
    NSString* cpDeliveryText = [actionDictionary objectForKey:@"deliveryText"];
    NSString *extUrl = [actionDictionary objectForKey:@"externalUrl"];
    
    //TODO: non existing key exception?
    
    //TODO: dictionary is null?
    
    
    NSString* CPexpiration = [actionDictionary objectForKey:@"expiration"];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *tmpDate = [dateFormatter dateFromString:CPexpiration];

    //todo: if datestring is not valid
    
    NSDate* CPexpDate;
    if (CPexpiration == nil || tmpDate == nil) {
        CPexpDate = [NSDate date];
    }
    else
    {
        CPexpDate = tmpDate;
    }
    
    
    [cp setDesc:CPdesc];
    [cp setPictureUrl:CPpicurl];
    [cp setTitle:CPtitle];
    [cp setActionId:CPid];
    [cp setExpiration:CPexpDate];
    [cp setStatus:CPstatus];
    [cp setDeliveryText:cpDeliveryText];
    [cp setExternalUrl:extUrl];
    return cp;
    
}

-(NSDictionary*)toDictionary
{
    NSDictionary *ret = @{@"title":[self title],@"text":[self desc],@"url":[self pictureUrl],@"id":[self actionId],@"deliveryText":[self deliveryText],@"status":[self status],@"expiration":[self expirationAsString], @"externalUrl":[self externalUrl]};
    return ret;
}

@end
