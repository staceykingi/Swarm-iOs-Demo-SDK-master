//
//  QRViewController.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.16..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//

//#define urlCouponImageOne [NSURL URLWithString: @"http://requinsynergy.azurewebsites.net/Images/Qr-code-ver-10.png"]


#import "BLESQRViewController.h"
#import "SWARMAction.h"
//#import "BLESDemoSession.h"
#import "BLESMock.h"
#import "BLESUrlDefinitions.h"

@interface BLESQRViewController ()

@end

@implementation BLESQRViewController
@synthesize myAction;
- (IBAction)urlClicked:(id)sender {
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadActionFromNet
{
    NSURL *imageURL = urlCouponImageOne;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            //UIImage *image = [UIImage imageWithData:imageData];
            self.imageView.image = [UIImage imageWithData:imageData];
            [self.imageView setHidden:NO];
            [self.spinner stopAnimating];
            NSLog(@"Picture loaded");
        });
    });
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    BLESDemoSession *mySession = [BLESDemoSession sharedManager];

    myAction = [mySession currentAction];
    
    if (myAction == nil) {
        NSLog(@"cp is nil");
        SWARMAction *cp = [[SWARMAction alloc]init];
        [cp setTitle:@"TV-s 10% off"];
        [cp setDesc:@"10% off on any Sony 3D TV-s"];
        [cp setExpiration:0];
        [cp setPictureUrl:@"http://requinsynergy.azurewebsites.net/Images/Qr-code-ver-10.png"];
        [cp setStatus:@"new"];
        [cp setExternalUrl:@"http://requinsynergy.azurewebsites.net/Images/Qr-code-ver-10.png"];
        [mySession setCurrentAction:cp];
    }
    else
    {
        [[self promoTitle] setText:[myAction title]];
        [[self promoDescription] setText:[myAction desc]];
        //NSDate *currDate = [myAction expiration];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd.MM.YY"];
        //NSString *dateString = [dateFormatter stringFromDate:currDate];
        [self.urlButton setTitle:[myAction externalUrl] forState:UIControlStateNormal];
//        NSLog(@"%@",dateString);
        
        [[self promoExpiration] setText:[NSString stringWithFormat:@"%@",[myAction expirationAsString]]];
        
    }
    
    [self loadActionFromNet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)optOutAction:(id)sender {
    NSLog(@"Dismissing coupon");
    NSLog(@"Sending dislike to the server");
    [self performSegueWithIdentifier:@"closeCoupon" sender:self];
}
- (IBAction)saveAction:(id)sender {
    
    NSLog(@"Saving coupon into the collection");
    NSLog(@"Sending like to the server");
  
    [self performSegueWithIdentifier:@"closeCoupon" sender:self];
}
- (IBAction)likeBtnClicked:(id)sender {
#if logCallstack
    NSLog(@">>> likeBtnClicked");
#endif
    //NSLog(@"Saving coupon into the collection");
    
    NSLog(@"Sending like to the server");
    
    [self.reactionSpinner startAnimating];
    [self.likeBtn setHidden:YES];
    [self.dislikeBtn setHidden:YES];
    NSString *myActionId = [myAction actionId];
    BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    [[mySession swarmSDK]setReactToActionCompletedDelegate:self];
    [[mySession swarmSDK]reactToActionForUser:[[mySession currentUser] customerSwarmId ] forAction:myActionId withReaction:YES];

#if logCallstack
    NSLog(@"<<< likeBtnClicked");
#endif
}
- (IBAction)dislikeBtnClicked:(id)sender {
    #if logCallstack
    NSLog(@">>> dislikeBtnClicked");
    #endif
    
    [self.reactionSpinner startAnimating];
    [self.likeBtn setHidden:YES];
    [self.dislikeBtn setHidden:YES];
    NSLog(@"Dismissing coupon");
    NSLog(@"Sending dislike to the server");
    NSString *myActionId = [myAction actionId];
    BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    [[mySession swarmSDK]setReactToActionCompletedDelegate:self];
    [[mySession swarmSDK]reactToActionForUser:[[mySession currentUser] customerSwarmId ] forAction:myActionId withReaction:NO];
 
#if logCallstack
    NSLog(@"<<< dislikeBtnClicked");
#endif
}

-(void)onReactToActionCompleted:(NSData *)responseData withError:(NSError *)error
{
    [self.reactionSpinner stopAnimating];
    [self dismissModalViewControllerAnimated:YES];
}

@end
