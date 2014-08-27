//
//  TrackViewController.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.16..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "BLESDemoRestApi.h"
#import "SwarmSDK.h"

@interface BLESTrackViewController : UIViewController < UsersRequestCompleteDelegate, BeaconsChangeFoundDelegate, WhatIsHereNotificationDelegate, WhereAmINotificationDelegate>

@property (weak, nonatomic) IBOutlet UIButton *changeUUID;
@property (weak, nonatomic) IBOutlet UITextField *uuidEdit;
@property (weak, nonatomic) IBOutlet UIButton *findActionsBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *refreshSpinner;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshProfiles;
@property (weak, nonatomic) IBOutlet UILabel *beaconsCount;
@property (weak, nonatomic) IBOutlet UILabel *targetDescription;
@property (weak, nonatomic) IBOutlet UILabel *beaconFoundLabel;
@property (weak, nonatomic) IBOutlet UILabel *proximityUUIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *targetSelector;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
//@property (weak, nonatomic) IBOutlet UIButton *sendReqBtn;
@property (weak,nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *dbgAction;
@property (weak, nonatomic) IBOutlet UIButton *selectUuidBtn;



@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end