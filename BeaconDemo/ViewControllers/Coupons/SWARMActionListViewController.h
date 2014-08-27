//
//  BLESCouponListViewController.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.19..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwarmSDK.h"
@interface SWARMActionListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, RequestForMeCompletedDelegate, UIAlertViewDelegate >
@property (strong, nonatomic) NSArray *maTheData;


@end
