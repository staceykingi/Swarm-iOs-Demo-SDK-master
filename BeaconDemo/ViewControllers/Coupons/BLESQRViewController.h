//
//  QRViewController.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.16..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWARMAction.h"
#import "BLESDemoSession.h"

@interface BLESQRViewController : UIViewController <ReactToActionCompletedDelegate >
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *reactionSpinner;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak,nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveAction;
@property (weak, nonatomic) IBOutlet UIButton *dislikeBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *dislikeAction;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) SWARMAction *myAction;
@property (weak, nonatomic) IBOutlet UILabel *promoTitle;
@property (weak, nonatomic) IBOutlet UILabel *promoPercent;
@property (weak, nonatomic) IBOutlet UILabel *promoDescription;
@property (weak, nonatomic) IBOutlet UILabel *promoExpiration;
@property (weak, nonatomic) IBOutlet UIButton *urlButton;

@end
