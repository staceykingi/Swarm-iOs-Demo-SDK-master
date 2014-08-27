//
//  SWSDKWhereAmIDemoViewController.m
//  SwarmSDKSample
//
//  Created by Ákos Radványi on 2014.02.20..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//
#define mySession [SWSDKDemoSession sharedManager]
#import "SWSDKWhereAmIDemoViewController.h"

@interface SWSDKWhereAmIDemoViewController ()

@end

@implementation SWSDKWhereAmIDemoViewController
long notifCount = 0;

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
    [[self swarmSDK] setWhereAmINotificationDelegate:self];
    [self.statusLbl setText:@"Delegate set"];
    
    //Start the service to receive notifications. You will get those in the callback below.
    [[self swarmSDK] startWhereAmIService];
    [self.statusLbl setText:@"Service started. Waiting for notifications."];

    //This helps to align the text to the top inside the textbox.
    self.automaticallyAdjustsScrollViewInsets = NO;

}

-(void)onWhereAmINotificationReceived:(SWARMWhatIsHereInformation *)locationInfo withError:(NSError *)error
{
    notifCount++;
    NSLog(@"WhereAmINotification received");
    [self.statusLbl setText:[NSString stringWithFormat:@"Service running, received notification %ldx.",notifCount]];
    
    /**
     * The received SWARMWhatIsHereInformation object contains the following data members:
     **/
    //First check, if we really received data or there was an error:
    if (locationInfo==nil || error!=nil) {
        //If this block is entered, there were some problems... The error object can tell you more.
        [self.statusLbl setText:@"There was an error during the last request."];
        return;
    }
    
    
    NSArray *locations = [locationInfo locations];
    //These array contains the locations for the visible beacons. They are represented as SWARMLocationInformation objects, containing the data of the associated department, and the beacon's parameters. Try to setup a breakpoint for the next line, and examine the contents of the array.
    
    //The coupons array will be nil, as this service does not provide user specific data. For that, use WhatIsHere service.
    NSArray *coupons = [NSArray arrayWithArray:[locationInfo getActions]];
    
    //Similarily the campaigns field is nil here, use WhatIsHere to receive it.
    NSArray *campaigns = [NSArray arrayWithArray:[locationInfo getCampaigns]];
    if ([campaigns count]>0) {
        NSLog(@"Campaign title: %@ - locationId: %@",[[campaigns firstObject]title], [[campaigns firstObject] locationId]);
    }
    
    NSLog(@"Number of received locations: %lu", (unsigned long)[locations count]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
