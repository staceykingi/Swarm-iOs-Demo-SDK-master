//
//  BLESRequestActionViewController.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.10..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLESCampaign.h"
#import "SWARMAction.h"

#import "SWARMUserProfile.h"
#import "BLESDemoSession.h"
#import "SwarmSDK.h"

@interface BLESRequestActionViewController : UIViewController <RequestActionCompletedDelegate,ReactToActionCompletedDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;
@property (weak, nonatomic) IBOutlet UILabel *campaignTitle;
@property (weak, nonatomic) IBOutlet UILabel *campaignDesc;
@property (weak, nonatomic) IBOutlet UILabel *actionTitle;
@property (weak, nonatomic) IBOutlet UILabel *actionDesc;
@property (weak, nonatomic) IBOutlet UILabel *actionExpiration;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;
@property (weak, nonatomic) IBOutlet UILabel *foundMessage;
@property (strong,nonatomic) BLESCampaign *myCampaign;
//just for the pre-demo, while the server is not online
@property (strong,nonatomic) SWARMAction *myAction;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *reactionSpinner;
@property (weak, nonatomic) IBOutlet UIButton *simulateSuccessBtn;
@property (weak, nonatomic) IBOutlet UILabel *waitText;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageSpinner;

@end
