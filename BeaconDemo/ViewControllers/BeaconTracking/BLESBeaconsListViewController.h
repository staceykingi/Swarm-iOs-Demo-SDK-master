//
//  BLESBeaconsListViewController.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.25..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLESDemoSession.h"


@interface BLESBeaconsListViewController : UITableViewController <BeaconsChangeFoundDelegate>
@property (strong,nonatomic) NSArray *beaconsArray;

@end
