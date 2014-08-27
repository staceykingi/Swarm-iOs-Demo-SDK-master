//
//  BLESChangeUUIDViewController.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.25..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLESDemoSession.h"
#import "BLESDemoRestApi.h"
@interface BLESChangeUUIDViewController : UIViewController <BeaconsListRequestCompletedDelegate, UIPickerViewDataSource, UIPickerViewDelegate >
@property (weak, nonatomic) IBOutlet UIPickerView *uuidChooser;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;


@end
