//
//  BLESUseCouponViewController.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.19..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//

#import "BLESUseActionViewController.h"
#import "BLESDemoSession.h"

@interface BLESUseActionViewController ()

@end

@implementation BLESUseActionViewController
@synthesize myAction;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)refreshLabels
{
    if (myAction == nil) {
        //Not happy...
        //TODO: handle error
        return;
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.YYYY"];
    //NSString *dateString = [dateFormatter stringFromDate:[myAction expiration]];
    
    //TODO: date format
    [self.expirationDate setText:[NSString stringWithFormat:@"%@", [myAction expirationAsString]]];
    [self.promoTitle setText:[myAction title]];
    [self.promoDesc setText:[myAction desc]];
    [self.urlButton setTitle:[myAction externalUrl] forState:UIControlStateNormal];
    [self loadActionImage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    self.myAction = [mySession currentAction];
	// Do any additional setup after loading the view.
    [self refreshLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadActionImage
{
    NSURL *imageURL = [NSURL URLWithString:[self.myAction pictureUrl]];
    // NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    //UIImage *image = [UIImage imageWithData:imageData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            //UIImage *image = [UIImage imageWithData:imageData];
            self.actionImage.image = [UIImage imageWithData:imageData];
           self.actionImage.contentMode = UIViewContentModeScaleAspectFit;
            [self.spinner stopAnimating];
            [self.actionImage setHidden:NO];
            NSLog(@"Picture loaded");
        });
    });
    
}

@end
