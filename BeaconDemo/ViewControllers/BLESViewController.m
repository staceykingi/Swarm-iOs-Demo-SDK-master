//
//  BLESViewController.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.11..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//
#define mySession [BLESDemoSession sharedManager]
#import "BLESViewController.h"
#import "BLESDemoSession.h"
@interface BLESViewController ()

@end

@implementation BLESViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[mySession swarmSDK]setWhatIsHereServiceEnabled:NO];
    [[mySession swarmSDK]setWhereAmIServiceEnabled:NO];
    [[mySession swarmSDK]setMonitorBeaconsChange:NO];
}

@end
