//
//  SWSDKRequestMyWalletDemoViewController.h
//  SwarmSDKSample
//
//  Created by Ákos Radványi on 2014.02.20..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWSDKDemoSession.h"
#import "SwarmSDK.h"

@interface SWSDKRequestMyWalletDemoViewController : UIViewController <RequestForMeCompletedDelegate >
@property (weak, nonatomic) IBOutlet UIButton *reqBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong,nonatomic) SwarmSDK *swarmSDK;
@end
