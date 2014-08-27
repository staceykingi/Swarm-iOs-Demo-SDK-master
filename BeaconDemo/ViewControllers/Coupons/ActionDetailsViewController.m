//
//  ActionDetailsViewController.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.16..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//

#import "ActionDetailsViewController.h"

@interface ActionDetailsViewController ()

@end

@implementation ActionDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the
    [self loadActionFromNet];
}

-(void)loadActionFromNet
{
    NSURL *imageURL = [NSURL URLWithString:@"http://192.168.10.100/coupon.png"];
   // NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    //UIImage *image = [UIImage imageWithData:imageData];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            UIImage *image = [UIImage imageWithData:imageData];
            
            //self.imageView.image = [UIImage imageWithData:imageData];
            NSLog(@"Picture loaded");
        });
    });
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
