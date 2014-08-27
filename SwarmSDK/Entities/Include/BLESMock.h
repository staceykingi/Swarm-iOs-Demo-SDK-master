//
//  BLESMock.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.07..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLESCustomerLocationEvent.h"

@interface BLESMock : NSObject
-(NSMutableArray *)getMyActions;
-(NSMutableArray *)getMockBeacons;
+(BLESCustomerLocationEvent *)getCustomerLocationEventSample;
+(NSMutableArray*)getDemoProfiles;
+(SWARMSourceSegmentVector*)getSourceSegmentVectorSample;
@end
