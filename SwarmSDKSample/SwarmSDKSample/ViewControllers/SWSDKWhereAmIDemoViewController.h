//
//  SWSDKWhereAmIDemoViewController.h
//  SwarmSDKSample
//
//  Created by Ákos Radványi on 2014.02.20..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWSDKDemoSession.h"
@interface SWSDKWhereAmIDemoViewController : UIViewController  < WhereAmINotificationDelegate   >
@property (strong,nonatomic) SwarmSDK *swarmSDK;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;


@end
