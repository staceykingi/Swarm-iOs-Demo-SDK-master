//
//  BLESWhatIsHereViewController.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.03.05..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwarmSDK.h"

@interface BLESWhatIsHereViewController : UITableViewController <WhatIsHereNotificationDelegate >
@property (strong,nonatomic) NSArray *myCampaigns;
@property (strong,nonatomic) NSArray *myActions;

@end
