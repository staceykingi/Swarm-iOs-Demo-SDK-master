//
//  BLESActionsNearTVC.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.08..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "BLESActionsNearTVC.h"
#import "BLESDemoRestApi.h"
#import "BLESAction.h"
#import "BLESCampaignCell.h"
#import "BLESDemoSession.h"
//#import "BLESUrlDefinitions.h"
#import "BLESCampaign.h"
#import "BLESRequestActionViewController.h"

@interface BLESActionsNearTVC () <CampaignsRequestCompleteDelegate>

@property (nonatomic) BLESDemoSession *mySession;
@property (nonatomic,retain) BLESDemoRestApi *demoRestApi;

@end

@implementation BLESActionsNearTVC
@synthesize maTheData;
@synthesize major;
@synthesize minor;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)onRefreshClicked:(id)sender {
//    [self restApi]sendCa;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mySession = [BLESDemoSession sharedManager];
    [self setDemoRestApi:[[BLESDemoRestApi alloc]init]];
    [[self demoRestApi]setCampaignsRqCompleteDelegate:self];
    
    //self.isOnline = false;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSMutableArray *actions = [[NSMutableArray alloc]init];// [restApi getMyActions];
    
    if (!maTheData) {
        //check if not null
        maTheData = actions;
        //[[NSMutableArray alloc] initWithObjects:@"Comets", @"Asteroids", @"Moons", nil];
    }
    
    
    // Inside a Table View Controller's viewDidLoad method
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
                action:@selector(refreshView:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    [[self demoRestApi]sendCampaignsRequest:[self major] withMinor:[self minor]];
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [maTheData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BLESCampaignCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tvcItems"];
    UILabel *lblName = (UILabel *)[cell viewWithTag:100];
    BLESCampaign *cp = [maTheData objectAtIndex:[indexPath row]];
    [lblName setText:[cp title]];
    [cell.detailTextLabel setText:[cp desc]];
    [cell setMyCampaign:cp];
    
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    int index = indexPath.row;
    
    BLESCampaign *tmpCp = (BLESCampaign*)[maTheData objectAtIndex:index];
    NSLog([tmpCp title]);
    BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    [mySession setCurrentCampaign:tmpCp];
    
    [self performSegueWithIdentifier:@"requestActionSegue" sender:self];
}

-(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    //TODO: use [self minor] and [self major] when sending the request
    [[self demoRestApi]sendCampaignsRequest:[self major] withMinor:[self minor]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                             [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
//    [refresh endRefreshing];
}

#pragma mark Load campaigns from server
-(void)onCampaignsRequestComplete:(NSMutableArray*)campaigns
{
    NSLog(@"Campaign request delegate called:)");
    [self setMaTheData:campaigns];
    [self.tableView reloadData];

    [[self refreshControl]endRefreshing];
    
}
#pragma mark -

- (NSMutableArray *)cleanActions {
    NSMutableArray *emptyArray =[[NSMutableArray alloc]init];
    //TODO: elegansabban, pl meg egy esemenykezelo atadasaval?
    BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    [mySession setCurrentActions:emptyArray];
    maTheData = emptyArray;
    [self.tableView reloadData];
    
    return emptyArray;
}

-(void)onCampaignsRequestComplete:(NSMutableArray *)campaigns withError:(NSError *)error
{
    [[self refreshControl]endRefreshing];
    if (campaigns== nil || error!=nil ) {
        
        return;
    }
    
    [self setMaTheData:campaigns];
    [self.tableView reloadData];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"requestActionSegue"]){
        BLESRequestActionViewController *controller = (BLESRequestActionViewController*)segue.destinationViewController;
         BLESDemoSession *mySession = [BLESDemoSession sharedManager];
        [controller setMyCampaign:[mySession currentCampaign]];
    }
}

@end
