//
//  BLESMock.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.07..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "BLESMock.h"
#import "SWARMAction.h"
#import "BLESBeacon.h"
#import "BLESUserProfile.h"
#import "BLESCustomerLocationEvent.h"

@implementation BLESMock


/**
 * Mock fetchMyCouponsFromServer
 */
-(NSMutableArray *)getMyActions
{
    SWARMAction *cp1 = [[SWARMAction alloc] init];
    [cp1 setTitle:@"First coupon"];
    [cp1 setDesc:@"Description of first coupon"];
    [cp1 setPictureUrl:@"http://192.168.10.100/coupon.png"];
    [cp1 setExpiration:1];
    
    SWARMAction *cp2 = [[SWARMAction alloc] init];
    [cp2 setTitle:@"2nd coupon"];
    [cp2 setDesc:@"Description of 2nd coupon"];
    [cp2 setPictureUrl:@"http://192.168.10.100/coupon.png"];
    [cp2 setExpiration:1];
    
    
    NSMutableArray *actions = [[NSMutableArray alloc] initWithObjects:cp1, cp2, nil];

    return actions;
}

/**
 * Get a CustomerLocationEvent json to send in
 **/
-(NSString *)getCustomerLocationEventSampleJson
{
    
  //  NSURL *url = [NSURL URLWithString:@"http://192.168.10.100:88/swarm.asp"];
    
    NSArray *ssvInterest = @[@"Music", @"Hiking"];
    
    NSArray *ssvGender = @[@"Male"];
    
    NSDictionary *ssv = @{@"Interest" : ssvInterest, @"Gender" : ssvGender};
    
    NSDictionary *requestData = @{@"customerGearsId": @"12345678",
                                  @"partnerId":@"12",
                                  @"customerSourceId":@"yelp12345678",
                                  @"sourceSegmentVector":ssv,
                                  @"locationId": @"99991234",
                                  @"eventTimestamp":@1386785992679};
    
    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:requestData
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *tmpJson = [[NSString alloc] initWithData:jsonData
                                              encoding:NSUTF8StringEncoding];
    
    return tmpJson;
}

-(NSMutableArray *)getMockBeacons
{
    BLESBeacon *shoes = [[BLESBeacon alloc]init];
    [shoes setUuid:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
    [shoes setTitle:@"Shoes"];
    [shoes setDesc:@"Our shoes department offers a variety of fency and high quality products."];
    [shoes setRegionId:@"com.Swarm.myRegion"];
    [shoes setMinor:@42];
    [shoes setMajor:@5586];
    
    BLESBeacon *candies = [[BLESBeacon alloc]init];
    [candies setUuid:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
    [candies setTitle:@"Candies"];
    [candies setDesc:@"If you love sweet things as we do, don't miss our candies department."];
    [candies setRegionId:@"com.Swarm.myRegion"];
    [candies setMinor:@3349];
    [candies setMajor:@41];
    
    BLESBeacon *entt = [[BLESBeacon alloc]init];
    [entt setUuid:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
    [entt setTitle:@"Entertainment"];
    [entt setDesc:@"Do you spend your time with movies or Xbox games? Our entertainment department will be the heaven for you!"];
    [entt setRegionId:@"com.Swarm.myRegion"];
    [entt setMinor:@2210];
    [entt setMajor:@40];
    
    
    NSMutableArray *ret = [[NSMutableArray alloc]initWithArray:@[shoes, candies, entt]];
    return ret;
}

+(BLESCustomerLocationEvent *)getCustomerLocationEventSample
{
    BLESCustomerLocationEvent *tmpCle = [[BLESCustomerLocationEvent alloc]init];
    
    NSString *customerSourceId = @"customerSourceId";
    NSString *customerGearsId = @"customerGearsId";
  //  NSString *eventTimestamp = [dictionary objectForKey:@"timestamp"];//[NSDate date]; //TODO
    NSString *locationId = @"locationId";
    NSArray *ssvInterest = @[@"Music", @"Hiking"];
    
    NSArray *ssvGender = @[@"Male"];
    
    NSMutableDictionary *ssvDict = [[NSMutableDictionary alloc]initWithDictionary: @{@"Interest" : ssvInterest, @"Gender" : ssvGender}];
    
    [tmpCle setCustomerSourceId:customerSourceId];
    [tmpCle setCustomerGearsId:customerGearsId];
    [tmpCle setLocationId:locationId];
    [tmpCle setEventTimestamp:[NSDate date]];//eventTimestamp]; //TODO: check final format, and modify parsing if needed
    SWARMSourceSegmentVector *tmpSSV = [[SWARMSourceSegmentVector alloc]init];
    [tmpSSV setSsvDictionary:ssvDict];
    [tmpCle setSourceSegmentVector:tmpSSV];
    [tmpCle setPartnerId:@"partnerId"];
    [tmpCle setMinor:@0];
    [tmpCle setMajor:@0];
    
    return tmpCle;
}

+(SWARMSourceSegmentVector*)getSourceSegmentVectorSample
{
    NSArray *ssvInterest = @[@"Music", @"Hiking"];
    
    NSArray *ssvGender = @[@"Male"];
    
    NSMutableDictionary *ssvDict = [[NSMutableDictionary alloc]initWithDictionary: @{@"Interest" : ssvInterest, @"Gender" : ssvGender}];
    SWARMSourceSegmentVector *ssv = [[SWARMSourceSegmentVector alloc]init];
    [ssv setSsvDictionary:ssvDict];
    return ssv;
}

+(NSArray*)getDemoProfiles
{
    BLESUserProfile *kateProfile = [[BLESUserProfile alloc]init];
    BLESUserProfile *tylerProfile = [[BLESUserProfile alloc]init];
    BLESUserProfile *anneProfile = [[BLESUserProfile alloc]init];
    
    
    NSString *kateText = @"Kate is 16, and she loves fashion. She spends most of her money on clothes and shoes.";
    NSString *tylerText = @"Tyler is 35, and he is full of life. He loves hiking, parties, and gaming consoles.";
    NSString *anneText = @"Anne is a 45 years old, and loves to read books sitting next to the fireplace.";
    NSString *donovanText = @"Donovan is a millionaire, and he buys only high end products.";
    
    [kateProfile setUserName:@"Kate"];
    [kateProfile setRemoteId:@"yelp0123"];
    [kateProfile setLocationEventBase:[BLESMock getCustomerLocationEventSample]];
    [[kateProfile locationEventBase]setCustomerGearsId:@"kateGearsId"];
    [kateProfile setDesc:kateText];
    
    [anneProfile setUserName:@"Anne"];
    [anneProfile setRemoteId:@"yelp2345"];
    [anneProfile setLocationEventBase:[BLESMock getCustomerLocationEventSample]];
    [[anneProfile locationEventBase]setCustomerGearsId:@"anneGearsId"];
    [anneProfile setDesc:anneText];
    
    [tylerProfile setUserName:@"Tyler"];
    [tylerProfile setRemoteId:@"yelp1234"];
    [tylerProfile setLocationEventBase:[BLESMock getCustomerLocationEventSample]];
    [[tylerProfile locationEventBase]setCustomerGearsId:@"tylerGearsId"];
    [tylerProfile setDesc:tylerText];
    
    BLESUserProfile *donovanProfile = [[BLESUserProfile alloc]init];
    [donovanProfile setUserName:@"Donovan"];
    [donovanProfile setRemoteId:@"yelp3456"];
    [donovanProfile setLocationEventBase:[BLESMock getCustomerLocationEventSample]];
    [[donovanProfile locationEventBase]setCustomerGearsId:@"donovanGearsId"];
    [donovanProfile setDesc:donovanText];
    
    NSMutableArray *tmpProfiles = [[NSMutableArray alloc]initWithArray:@[kateProfile,tylerProfile,anneProfile,donovanProfile]];
    return tmpProfiles;
}
@end
