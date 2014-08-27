//
//  BLESCoupon.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.19..
//  Copyright (c) 2013 Swarm. All rights reserved.
//

#import "SWARMAction.h"

@implementation SWARMAction

@synthesize desc;
@synthesize pictureUrl;
@synthesize title;
@synthesize expiration;
@synthesize actionId;
@synthesize status;
@synthesize deliveryText;
@synthesize externalUrl;
@synthesize campaignId;

-(NSString *)toJson
{
  /* NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[self expiration]];
    */
    NSDictionary *requestData = @{@"title": [self title],
                                  @"text": [self desc],
                                  @"imageUrl": [self pictureUrl],
                                  @"expiration": [NSNumber numberWithInt:[self expiration]] ,
                                  @"id": [self actionId],
                                  @"deliveryText": [self deliveryText],
                                  @"externalUrl":[self externalUrl],
                                  @"campaignId":[self campaignId]
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
    //NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString *dateString = [dateFormatter stringFromDate:[self expiration]];
    if ([self expiration]<1) {
        return @"This coupon does not expire.";
    }
    else
    {
        return [NSString stringWithFormat:@"Expires in %ld days.",(long)[self expiration]];
    }

}

+(SWARMAction *)fromJson:(NSString *)jsonString
{
    SWARMAction *cp = [[SWARMAction alloc] init];
    //TODO: replace with deserialization
    //TODO: error handling
    [cp setDesc:@"This is a demo coupon"];
    [cp setPictureUrl:@"http://192.168.10.100/coupon.png"];
    [cp setTitle:@"Xmas great deals"];
    [cp setActionId:@"asdf1234" ];
    [cp setExpiration:0];
    [cp setStatus:@"accepted"];
    [cp setDeliveryText:@"deliverytext"];
    [cp setExternalUrl:@""];
    [cp setCampaignId:0];
    
    //TODO: parse as a dictionary and call fromDictionary - return created coupon ref
    return cp;
}

+(SWARMAction *)fromDictionary:(NSDictionary *)actionDictionary
{
    SWARMAction *cp = [[SWARMAction alloc] init];
    

    NSString* CPtitle = [SWARMAction getStringNullable: [actionDictionary objectForKey:@"title"]];
    NSString* CPdesc =  [SWARMAction getStringNullable:[actionDictionary objectForKey:@"text"]];
    NSString* CPpicurl = [SWARMAction getStringNullable:[actionDictionary objectForKey:@"imageUrl"]];
    NSString* CPid = [SWARMAction getStringNullable:[actionDictionary objectForKey:@"id"]];
    
    NSString* CPstatus = [SWARMAction getStringNullable:[actionDictionary objectForKey:@"status"]];
    NSString* cpDeliveryText = [SWARMAction getStringNullable:[actionDictionary objectForKey:@"deliveryText"]];
    NSString *extUrl = [SWARMAction getStringNullable:[actionDictionary objectForKey:@"externalUrl"]];
    NSNumber *campId = [actionDictionary objectForKey:@"campaignId"];
    //TODO: non existing key exception?
    
    //TODO: dictionary is null?
    
    NSInteger CPexpiration = [[actionDictionary objectForKey:@"expiration"]intValue];
    //[SWARMAction getStringNullable:[actionDictionary objectForKey:@"expiration"]];
    
  /*  @try {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *tmpDate = [dateFormatter dateFromString:CPexpiration];
        
        //todo: if datestring is not valid
        
        
        if (CPexpiration == nil || tmpDate == nil) {
            CPexpDate = [NSDate date];
        }
        else
        {
            CPexpDate = tmpDate;
        }

    }
    @catch (NSException *exception) {
        [cp setExpiration:CPexpDate];
    }
    @finally {
        
    }
    */
   
    [cp setExpiration:CPexpiration];
    
    [cp setDesc:CPdesc];
    [cp setPictureUrl:CPpicurl];
    [cp setTitle:CPtitle];
    [cp setActionId:CPid];
    
    [cp setStatus:CPstatus];
    [cp setDeliveryText:cpDeliveryText];
    [cp setExternalUrl:extUrl];
    [cp setCampaignId:campId];
    return cp;
    
}

+(NSString*)getStringNullable:(NSString*)otherString
{
    if (otherString==nil || otherString == [NSNull null]) {
        return @"";
    }
    
    if ([otherString isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",(NSNumber*)otherString];
    }
    
    return [NSString stringWithString:otherString];
}

-(NSDictionary*)toDictionary
{
    NSDictionary *ret = @{@"title":[self title],@"text":[self desc],@"url":[self pictureUrl],@"id":[self actionId],@"deliveryText":[self deliveryText],@"status":[self status],@"expiration":[self expirationAsString], @"externalUrl":[self externalUrl], @"campaignId":[self campaignId]};
    return ret;
}

@end
