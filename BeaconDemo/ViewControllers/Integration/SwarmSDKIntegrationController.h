//
//  SwarmSDKIntegrationController.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.31..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwarmSDK.h"
//Note: this Controller has a reference to the SwarmSDK, and implements some of it's protocols
@interface SwarmSDKIntegrationController : UIViewController <BeaconsChangeFoundDelegate, WhereAmINotificationDelegate, WhatIsHereNotificationDelegate,UIAlertViewDelegate >
//This textbox lists transisions of the fist seen beacon (if there are more beacons around, the first one in the collection returned
@property (weak, nonatomic) IBOutlet UITextView *transitons;

//a label showing number of new beaocns (=just discovered, or already seen but it's proximity changed) / number of all visible beacons - Previous and current porximity of the first beacon
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UITextView *whatIsHereNotifBox;
@property (weak, nonatomic) IBOutlet UITextView *whereAmINotifBox;
@property (weak, nonatomic) IBOutlet UITextView *campaignList;

@end
