//
//  BLESCouponListViewController.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.19..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define mySession [BLESDemoSession sharedManager]

#import "SWARMActionListViewController.h"
#import "SWARMAction.h"
#import "SWARMActionCell.h"
#import "BLESDemoSession.h"


@interface SWARMActionListViewController ()

@end

@implementation SWARMActionListViewController
@synthesize maTheData;


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
    
    
   
      //self.isOnline = false;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray *coupons = [[NSArray alloc]init];
    
    if (!maTheData) {
        //check if not null
        maTheData = coupons;
        //[[NSMutableArray alloc] initWithObjects:@"Comets", @"Asteroids", @"Moons", nil];
    }
    
    
    // Inside a Table View Controller's viewDidLoad method
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
                  action:@selector(refreshView:)
                  forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    [[mySession swarmSDK] setRequestForMeCompletedDelegate:self];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![self checkLoginState]) {
        return;
    }
    
    [[mySession swarmSDK]requestForMe:[[mySession currentUser] customerSwarmId]];
    
}

- (void)dealloc
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}
#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [maTheData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SWARMActionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tvcItems"];
    UILabel *lblName = (UILabel *)[cell viewWithTag:100];
    SWARMAction *cp = [maTheData objectAtIndex:[indexPath row]];
    [lblName setText:[NSString stringWithFormat:@"%@ (@%@)",[cp title], [cp campaignId]]];
    [cell.detailTextLabel setText:[cp desc]];
    [cell setActionRef:cp];
    if ([[cp status] isEqualToString:@"new"]) {
        [cell setAccessoryType:UITableViewCellAccessoryDetailButton];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    int index = indexPath.row;
    
    SWARMAction *tmpCp = (SWARMAction*)[maTheData objectAtIndex:index];
    NSLog(@"%@",[tmpCp title]);
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


-(void)refreshView:(UIRefreshControl *)refresh {
         refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [self cleanActions];

    if (![self checkLoginState]) {
        return;
    }
    
    [[mySession swarmSDK]requestForMe:[[mySession currentUser]customerSwarmId]];
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                                                    [formatter stringFromDate:[NSDate date]]];
         refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
}

#pragma mark Load coupons from server

-(void)onRequestForMeCompleted:(NSArray *)forMe withError:(NSError *)error
{
    //Todo: check error!
    [[self refreshControl] endRefreshing];
    [self setMaTheData:forMe];
    [self.tableView reloadData];
}

- (NSMutableArray *)cleanActions {
    NSMutableArray *emptyArray =[[NSMutableArray alloc]init];
    //TODO: elegansabban, pl meg egy esemenykezelo atadasaval?
 //   BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    [mySession setCurrentActions:emptyArray];
    maTheData = emptyArray;
    [self.tableView reloadData];
    
    return emptyArray;
}

#pragma mark -



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

@end
