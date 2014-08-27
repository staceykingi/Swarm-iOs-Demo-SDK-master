//
//  SWSDKRequestMyWalletDemoViewController.m
//  SwarmSDKSample
//
//  Created by Ákos Radványi on 2014.02.20..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import "SWSDKRequestMyWalletDemoViewController.h"

#define mySession [SWSDKDemoSession sharedManager]

@interface SWSDKRequestMyWalletDemoViewController ()

@end

@implementation SWSDKRequestMyWalletDemoViewController
@synthesize swarmSDK;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //Update the displayed username
    [self.statusLbl setText:[NSString stringWithFormat: @"Ready to request coupons for %@",[[mySession swarmSDK]swarmId]]];
    //Get a reference to the sdk:
    [self setSwarmSDK:[mySession swarmSDK]];
    //Set this class as the implementor of the relevant protocol:
    [[self swarmSDK]setRequestForMeCompletedDelegate:self];
    
    //Call the service - by pressing the button
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)inBtnPressed:(id)sender {
    //Send the request, when the button is pressed
    [self.spinner startAnimating];
    [self.reqBtn setEnabled:NO];
    [self.statusLbl setText:@"Waiting for the server's response..."];
    [[self swarmSDK]requestForMe:[[self swarmSDK]swarmId]];
 
}

-(void)onRequestForMeCompleted:(NSArray *)myWallet withError:(NSError *)error
{
    [self.spinner stopAnimating];
    //Check, if there was no error during completing your request:
    if (myWallet==nil || error!=nil) {
        //If this block is entered, there were some problems... The error object can tell you more.
        [self.statusLbl setText:@"There was an error during the last request. Try again..."];
        [self.reqBtn setEnabled:YES];
        return;
    }
    
    //If we are OK, the provided array contains BLESCoupon instances.
    NSLog(@"Number of coupons in the users wallet: %lu",(unsigned long)[myWallet count]);
    [self.statusLbl setText:@"Coupons received."];
    [self.reqBtn setEnabled:YES];
    //You can display the coupons in a table view controller, or do whatever you like with them.
}

@end
