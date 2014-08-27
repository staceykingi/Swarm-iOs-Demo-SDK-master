//
//  BLESCouponsNearTVC.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.08..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLESDemoRestApi.h"

@interface SWARMActionsNearTVC : UITableViewController <CampaignsRequestCompleteDelegate>
@property (strong, nonatomic) NSMutableArray *maTheData;
@property (strong,nonatomic) NSNumber *major;
@property (strong,nonatomic) NSNumber *minor;
@end
