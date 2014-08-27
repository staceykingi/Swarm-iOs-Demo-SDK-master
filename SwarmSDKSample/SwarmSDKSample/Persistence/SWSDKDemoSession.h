//
//  SWSDKDemoSession.h
//  SwarmSDKSample
//
//  Created by Ákos Radványi on 2014.02.20..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SwarmSDK.h"

/**
 * This class is simulating the persis
 **/
@interface SWSDKDemoSession : NSObject

@property (nonatomic, strong) SwarmSDK *swarmSDK;
@property (strong, nonatomic) SWARMUserProfile *myUser;
+ (id)sharedManager;

@end
