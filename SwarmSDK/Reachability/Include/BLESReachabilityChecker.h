//
//  BLESReachabilityChecker.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.10..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWARMReachability.h"


@interface BLESReachabilityChecker : NSObject
@property (nonatomic) SWARMReachability *hostReachability;
@property (nonatomic) SWARMReachability *internetReachability;
@property (nonatomic) SWARMReachability *wifiReachability;
@property  (nonatomic) BOOL isOnline;
@end
