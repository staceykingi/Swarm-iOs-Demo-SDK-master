//
//  SWSDKWhatIsHereDemoViewController.m
//  SwarmSDKSample
//
//  Created by Ákos Radványi on 2014.02.10..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//
#define mySession [SWSDKDemoSession sharedManager]
#import "SWSDKWhatIsHereDemoViewController.h"


@interface SWSDKWhatIsHereDemoViewController ()

@end

@implementation SWSDKWhatIsHereDemoViewController
@synthesize swarmSDK;
long wihNotifCount = 0;

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
    
    //Get a reference to the SDK, which we store now in the SWSDKDemoSession singleton object. Obviously you do not have to do the same way, for example you can create an instance and pass it to the next viewcontroller  during navigation.
    [self setSwarmSDK:[[SWSDKDemoSession sharedManager] swarmSDK]];
    
    //Set the delegate for the service. Do not forget to subscribe for the protocol, which is done in the header file of this class.
    [[self swarmSDK] setWhatIsHereNotificationDelegate:self];

    [self.statusLbl setText:@"Delegate set"];
    
    //Start the service to receive notifications. You will get those in the callback below.
    [[self swarmSDK] startWhatIsHereService];
    [self.statusLbl setText:@"Service started. Waiting for notifications."];
    
    //This helps to align the text to the top inside the textbox.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    /*old, remove:
    [self setSwarmSDK:[[SWSDKDemoSession sharedManager] swarmSDK]];

    
    [[self swarmSDK] setBeaconsChangeFoundDelegate:self];
//  [[self swarmSDK] startMonitorBeaconsChange ];
    
    [[self swarmSDK] setRequestMyWalletCompletedDelegate:self];
//  [[self swarmSDK] requestMyWallet:@"tyler"];
*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onWhatIsHereNotificationReceived:(SWARMWhatIsHereInformation *)whatIsHereInfo withError:(NSError *)error
{
    wihNotifCount++;
    NSLog(@"WhatIsHereNotification received");
    [self.statusLbl setText:[NSString stringWithFormat:@"Service running, received notification %ldx.",wihNotifCount]];
    
    /**
     * The received SWARMWhatIsHereInformation object contains the following data members:
     **/
    //First check, if we really received data or there was an error:
    if (whatIsHereInfo==nil || error!=nil) {
        //If this block is entered, there were some problems... The error object can tell you more.
        [self.statusLbl setText:@"There was an error during the last request."];
        return;
    }
    
    
    NSArray *locations = [whatIsHereInfo locations];
    //These array contains the locations for the visible beacons. They are represented as SWARMLocationInformation objects, containing the data of the associated department, and the beacon's parameters. Try to setup a breakpoint for the next line, and examine the contents of the array.
    
    //The coupons array will contain the coupons, the user can redeem at the current location. They are represented as BLESCoupon instances.
    NSArray *coupons = [NSArray arrayWithArray:[whatIsHereInfo getActions]];
    
    //The campaigns array contains the list of active/available campaigns based on the users position or movement. They are represented as BLESCampaign objects.
    NSArray *campaigns = [NSArray arrayWithArray:[whatIsHereInfo getCampaigns]];
    
    NSLog(@"Number of received locations: %lu, coupons: %lu, campaigns: %lu", (unsigned long)[locations count],  (unsigned long)[coupons count], (unsigned long)[campaigns count]);

}

-(void)onBeaconsChangeFound:(id)beaconContainer
{
    NSLog(@"onBeaconsChangeFound called");
}



-(void)onRequestForMeCompleted:(NSArray *)myWallet withError:(NSError *)error
{
    NSLog(@"wallet received");
}

@end
