//
//  BLESWhatIsHereViewController.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.03.05..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//
#define mySession [BLESDemoSession sharedManager]
#import "BLESWhatIsHereViewController.h"
#import "SWARMAction.h"
#import "BLESCampaign.h"
#import "SWARMActionCell.h"
#import "BLESCampaignCell.h"
#import "BLESDemoSession.h"
#import "BLESRequestActionViewController.h"

@interface BLESWhatIsHereViewController ()
@property (strong,nonatomic) BLESCampaign *tmpCampaign;
@end

@implementation BLESWhatIsHereViewController
@synthesize myCampaigns,myActions, tmpCampaign;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if ([self myActions ]==nil) {
    /*
    BLESCoupon *coupon = [[BLESCoupon alloc]init];
    [coupon setTitle:@"Dexter mania coupon"];
    [coupon setDesc:@"Cheap chainsaws for a week"];
   */
    [self setMyActions:[[NSArray alloc]init]];
    }
    
    if ([self myCampaigns]==nil) {
        
 /*   BLESCampaign *camp = [[BLESCampaign alloc]init];
    [camp setTitle:@"Demo campaign"];
    [camp setDesc:@"Try the swarmSdk"];
    
    BLESCampaign *camp2 = [[BLESCampaign alloc]init];
    [camp2 setTitle:@"campaign2"];
    [camp2 setDesc:@"desc"];
    */
    [self setMyCampaigns:[[NSArray alloc]init] ];
     }
    
    [[mySession swarmSDK]setWhatIsHereNotificationDelegate:self];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if(section==0)
    {
        if (myCampaigns == nil)
        {
            return 0;
        }
        else
        {
            return [myCampaigns count];
        }
    }
    if (section==1)
    {
        if (myActions == nil)
        {
            return 0;
        }
        else
        {
            return [myActions count];
        }
    }
        
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    SWARMActionCell *couponCell;
    BLESCampaignCell *campCell;
    NSString *CellIdentifier;
    
    if(indexPath.section == 0)
    {
        CellIdentifier = @"CampaignCell";
        
        campCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell = campCell;
    }
    else
    {
        CellIdentifier = @"CouponCell";
        couponCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell = couponCell;
    }
    
  
   
    
    // Configure the cell...
    NSString *labelTxt;
    NSString *descTxt;
    
    if(indexPath.section ==0)
    {
        labelTxt = [(BLESCampaign*)[myCampaigns objectAtIndex:indexPath.row]title];
        descTxt  = [(BLESCampaign*)[myCampaigns objectAtIndex:indexPath.row]desc];
        [campCell setMyCampaign:[myCampaigns objectAtIndex:indexPath.row]];
    }
    else
    {
        labelTxt = [(SWARMAction*)[myActions objectAtIndex:indexPath.row]title];
        descTxt  = [(SWARMAction*)[myActions objectAtIndex:indexPath.row]desc];
        [couponCell setActionRef:[myActions objectAtIndex:indexPath.row]];
    }
    
    UILabel *lblTitle = (UILabel*)[cell viewWithTag:100];
    UILabel *lblDesc = (UILabel*)[cell viewWithTag:200];
    [lblDesc setText:descTxt];
    [lblTitle setText:labelTxt];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Campaigns nearby";
            break;
        case 1:
            sectionName = @"Redeemable coupons";
            break;
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}


- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    
    if (indexPath.section==0) {
        int index = indexPath.row;
        
        BLESCampaign *tmpCp = (BLESCampaign*)[myCampaigns objectAtIndex:index];
     
        //[mySession setCurrentCampaign:tmpCp];
        [self setTmpCampaign:tmpCp];
        [self performSegueWithIdentifier:@"requestCouponSegue" sender:self];
        
    }
    else
    {
    int index = indexPath.row;
    
    SWARMAction *tmpCp = (SWARMAction*)[myActions objectAtIndex:index];
   
    //   BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    [mySession setCurrentAction:tmpCp];
    //[self setMaTheData:[[NSMutableArray alloc]init] ];
    if ([[tmpCp status]isEqualToString:@"new"]) {
        [self performSegueWithIdentifier:@"recommendedCouponSegue" sender:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"acceptedCouponSegue" sender:nil];
    }
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"requestCouponSegue"]){
        BLESRequestActionViewController *controller = (BLESRequestActionViewController *)segue.destinationViewController;
        [controller setMyCampaign: tmpCampaign];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

-(void)onWhatIsHereNotificationReceived:(SWARMWhatIsHereInformation *)whatIsHereInfo withError:(NSError *)error
{
    if (error!=nil) {
        return;
    }
    if (whatIsHereInfo==nil) {
        return;
    }
    
    myActions = [NSArray arrayWithArray:[whatIsHereInfo getActions]];
    myCampaigns = [NSArray arrayWithArray:[whatIsHereInfo getCampaigns]];
    
    [self.tableView reloadData];
}

@end
