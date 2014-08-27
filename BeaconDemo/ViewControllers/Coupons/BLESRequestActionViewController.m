//
//  BLESRequestCouponViewController.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.10..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//
#define mySession [BLESDemoSession sharedManager]
#import "BLESRequestActionViewController.h"
#import "SWARMAction.h"
//#import "SwarmSDK.h"

@interface BLESRequestActionViewController () 
//@property (strong,nonatomic) BLESRestApi *restApi;
@end

@implementation BLESRequestActionViewController
@synthesize myCampaign;
@synthesize myAction;

- (IBAction)simulateSuccess:(id)sender {
    [[self loadingSpinner]stopAnimating];
   // [[self foundMessage]setHidden:NO];
    [[self actionTitle]setHidden:NO];
    [[self actionDesc]setHidden:NO];
    [[self actionExpiration]setHidden:NO];
    [[self simulateSuccessBtn]setHidden:YES];
    [[self waitText]setText:@"We have found a coupon for you. See the details below."];
    
    [[self acceptButton]setHidden:NO];
    [[self rejectButton]setHidden:NO];
    
}

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
    if ([self myCampaign]!=nil) {

        [[self campaignTitle]setText:[NSString stringWithFormat:@"%@ (@%@)", [myCampaign title],[myCampaign locationId]]];
        [[self campaignDesc]setText:[myCampaign desc]];

        [[mySession swarmSDK] setRequestActionCompletedDelegate:self];
        [[mySession swarmSDK]setReactToActionCompletedDelegate:self];
        [[mySession swarmSDK]requestActionForUser:[[mySession currentUser] customerSwarmId] forCampaign:[myCampaign campaignId]];
    }
}
- (IBAction)rejectClicked:(id)sender {
   [self.reactionSpinner startAnimating];

    [[mySession swarmSDK]reactToActionForUser:[[mySession currentUser]customerSwarmId] forAction:[myAction actionId] withReaction:YES];
    [self.acceptButton setHidden:YES];
    [self.rejectButton setHidden:YES];
    [self.foundMessage setText:@"Coupon rejected. Thank you for your feedback."];
}

- (IBAction)acceptClicked:(id)sender {
    [self.reactionSpinner startAnimating];

    [[mySession swarmSDK]reactToActionForUser:[[mySession currentUser] customerSwarmId] forAction:[myAction actionId] withReaction:YES];
    [self.acceptButton setHidden:YES];
    [self.rejectButton setHidden:YES];

    [self.foundMessage setText:@"The coupon was saved into your wallet, now you can go back to the previous screen."];
}

-(void)onReactToActionCompleted:(NSData *)responseData withError:(NSError *)error
{

    [self.reactionSpinner stopAnimating];
    //TODO: this runs when the user accepted/rejected the coupon
    //Tell that its in the wallet or if it was rejected
    //Reject goes back as well

    [self.foundMessage setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onActionGenerationRequestComplete:(SWARMAction*)responseData withError:(NSError*)error
{
    if (responseData == nil)
    {
        //no coupon found
        [self.foundMessage setText:@"There is no more coupon available for this campaign." ];
        [self.loadingSpinner stopAnimating];
        [self.waitText setText:@"No coupon available."];
    }
    else
    {
        [self setMyAction:responseData];
        [self showAction];
    }
    
}

-(void)onRequestActionCompleted:(NSArray *)actions withError:(NSError *)error
{
    [self.loadingSpinner stopAnimating];
    if (actions==nil) {
        [self.waitText setText:@"There was an error while communicating with the server."];
        [self.foundMessage setText:@"Please, try again later."];
        [self.foundMessage setHidden:NO];
        return;
    }
    
    if ([actions count]==0) {
        [self.foundMessage setText:@"There are no more coupons available for this campaign."];
        [self.waitText setText:@""];
        [self.foundMessage setHidden:NO];
        return;
    }
    
    [self setMyAction:[actions firstObject]];
    [self showAction];
       
    
}



-(void)showAction
{
    [[self loadingSpinner]stopAnimating];
    // [[self foundMessage]setHidden:NO];
    [[self actionTitle]setHidden:NO];
    [[self actionDesc]setHidden:NO];
    [[self actionExpiration]setHidden:NO];
    [[self simulateSuccessBtn]setHidden:YES];
    [[self waitText]setText:@"We have found a coupon for you. See the details below."];
    
    [[self acceptButton]setHidden:NO];
    [[self rejectButton]setHidden:NO];
    //[[self imageView]setHidden:NO];
    [[self imageSpinner]startAnimating];
    [self.actionTitle setText:[myAction title]];
    [self.actionDesc setText:[myAction desc]];
    
    
    [self.actionExpiration setText:[myAction expirationAsString]];
    [self.actionExpiration setHidden:NO];
    [self loadActionFromNet];
}

-(void)loadActionFromNet
{
    NSURL *imageURL = [NSURL URLWithString:[myAction pictureUrl]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            //UIImage *image = [UIImage imageWithData:imageData];
            self.imageView.image = [UIImage imageWithData:imageData];
            [self.imageView setHidden:NO];
            [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
           
            [[self imageView]setHidden:NO];
            [[self imageSpinner]stopAnimating];
            NSLog(@"Picture loaded");
        });
    });
    
}

@end
