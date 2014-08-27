//
//  BLESSwarmLoginViewController.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.27..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLESDemoSession.h"
#import "BLESDemoRestApi.h"

@interface BLESSwarmLoginViewController : UIViewController <SwarmLoginCompletedDelegate, UsersRequestCompleteDelegate >
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UITextView *requestText;
@property (weak, nonatomic) IBOutlet UITextView *responseText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refreshSpinner;
@property (weak, nonatomic) IBOutlet UISegmentedControl *targetSelector;

@end
