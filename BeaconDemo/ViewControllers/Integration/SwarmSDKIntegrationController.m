//
//  SwarmSDKIntegrationController.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.31..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//
#define mySession [BLESDemoSession sharedManager]
#import "SwarmSDKIntegrationController.h"
#import "BLESDemoSession.h"
#import "SWARMBeacon.h"
@interface SwarmSDKIntegrationController ()
@property (strong,nonatomic) SwarmSDK *swarmSDK;
@end


@implementation SwarmSDKIntegrationController

@synthesize swarmSDK;

-(BOOL)checkLoginState
{
    if ([mySession currentUser]==nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No profile selected"
                                                        message:@"To use this screen you need to select a profile first. You can do this on the «Beacon receiver demo» screen."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //Get reference to the SDK: already done in the mySession singleton object
    
    
    if (![self checkLoginState]) {
        return;
    }
    
    //Set delegate for BeaconChangeFound event - and don't forget to implement onBeaconsChangeFound
    [[mySession swarmSDK] setBeaconsChangeFoundDelegate:self];
    
    //Set delegate for WhereAmI and WhatIsHere - and implement their delegates as well
    [[mySession swarmSDK] setWhereAmINotificationDelegate:self];
    [[mySession swarmSDK] setWhatIsHereNotificationDelegate:self];
    
    //Start the monitoring of these changes:
    [[mySession swarmSDK] startMonitorBeaconsChange];
  
    
    [[mySession swarmSDK] startWhereAmIService];
    
    [[mySession swarmSDK] startWhatIsHereService];
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Handle beacon changes.
-(void)onBeaconsChangeFound:(BLESBeaconContainer *)beaconContainerP
{
    if (beaconContainerP!=nil) {
        NSInteger allCount = [[beaconContainerP getBeacons] count];
        NSInteger freshCount = [[beaconContainerP getNewBeacons]count];
        
        if (allCount>0)
        {
            SWARMBeacon *swb = [[beaconContainerP getBeacons]firstObject];
            [self.label1 setText:[NSString stringWithFormat:@"# of beacons: %lu - Changed now: %lu - Nearest beacon's proximity: %@»%@",(unsigned long)allCount,(unsigned long)freshCount,[swb proximityOld],[swb proximityLetter] ]];
        }
          else
          {
              [self.label1 setText:[NSString stringWithFormat:@"onNewBeaconsFound: %lu/%lu",(unsigned long)freshCount,(unsigned long)allCount]];

          }
        
        NSMutableString *txt = [[NSMutableString alloc]init];
       
        for (SWARMBeacon *bc in [beaconContainerP getNewBeacons]) {
            [txt appendString:[NSString stringWithFormat:@"%@>%@ %ld\n",[bc proximityOld],[bc proximityLetter],(long)[bc rssi]]];
            
        }
        [txt appendString:[self.transitons text]];
        [self.transitons setText:txt];
    }
}

-(void)onWhereAmINotificationReceived:(SWARMWhatIsHereInformation *)locationInfo withError:(NSError *)error
{
    if (error!=nil) {
        [self.whereAmINotifBox setText:@"There was an error somewhere"];
    }
    NSMutableString *txt = [[NSMutableString alloc]init ];
    [txt appendString: @"WhereAmIHere notification\nLocations:\n"];
    for (SWARMLocationInformaion *sli in [locationInfo locations]) {
        [txt appendString:[sli toString]];
    }
    // [whatIsHereInfo locations];
    
    [self.whereAmINotifBox setText:txt];
}

-(void)onWhatIsHereNotificationReceived:(SWARMWhatIsHereInformation *)whatIsHereInfo withError:(NSError *)error
{
#if logCallstack
    NSLog(@">>> onWhatIsHereNotificationReceived");
#endif
    if (whatIsHereInfo== nil) {
        [self.whatIsHereNotifBox setText:@"nil received"];
        return;
    }
    NSMutableString *txt = [[NSMutableString alloc]init ];
    [txt appendString: @"WhatIsHere notification\nLocations:\n"];
    for (SWARMLocationInformaion *sli in [whatIsHereInfo locations]) {
        [txt appendString:[sli toString]];
   
    }
    [txt appendString:@"Coupons:\n"];
    for (SWARMAction *cp in [whatIsHereInfo getActions]) {
        @try {
            [txt appendString:[cp toJson]];
        }
        @catch (NSException *exception) {
            NSLog(@"Could not serialize coupon");
        }
        @finally {
            
        }
    }
    
    NSMutableString *campTxt = [[NSMutableString alloc]init];
    [txt appendString:@"Campaigns:\n"];
    for (BLESCampaign *cp in [whatIsHereInfo getCampaigns]) {
        [txt appendString:[NSString stringWithFormat:@"Campaign: %@\n",[cp title]]];
        [campTxt appendString:[NSString stringWithFormat:@"%@\n",[cp title]]];

    }
   
    [self.campaignList setText:campTxt];
    [self.whatIsHereNotifBox setText:txt];
#if logCallstack
    NSLog(@"<<< onWhatIsHereNotificationReceived");
#endif
}

@end
