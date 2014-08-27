//
//  SWARMBeaconCell.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.25..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWARMBeacon.h"
@interface SWARMBeaconCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;
@property (weak, nonatomic) IBOutlet UILabel *mamiLabel;
@property (weak, nonatomic) IBOutlet UILabel *proximityLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *snrLabel;
@property (strong,nonatomic) SWARMBeacon *myBeacon;
-(void)updateLabels;
@end
