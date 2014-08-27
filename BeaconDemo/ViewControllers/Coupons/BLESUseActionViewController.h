//
//  BLESUseCouponViewController.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.19..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWARMAction.h"

@interface BLESUseActionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UILabel *expirationDate;
@property (weak, nonatomic) IBOutlet UIImageView *actionImage;
@property (weak, nonatomic) IBOutlet UILabel *promoTitle;
@property (weak, nonatomic) IBOutlet UILabel *promoDesc;
@property (weak, nonatomic) SWARMAction *myAction;
@property (weak, nonatomic) IBOutlet UIButton *urlButton;

@end
