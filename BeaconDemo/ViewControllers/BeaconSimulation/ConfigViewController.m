//
//  ConfigViewController.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2013.12.17..
//  Copyright (c) 2013 Sonrisa. All rights reserved.
//

//Get list of locations (beacons)
//#define urlGetLocations @"http://webservices.swarm-mobile.com/swarm-demo/services/location"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#import "ConfigViewController.h"
#import "SWARMBeaconSimulation.h"
#import "BLESUrlDefinitions.h"

#import "BLESDemoSession.h"
#import "BLESBeacon.h"
//#import "BLESUrlDefinitions.h"

@interface ConfigViewController ()
@property (retain,nonatomic) BLESBeacon *myBeacon;
@property (strong,nonatomic) SWARMBeaconSimulation *beaconSimulator;
@end


@implementation ConfigViewController
@synthesize beaconSimulator;

- (IBAction)refreshBeaconsClicked:(id)sender {
    [self setBeaconSimulator:[[SWARMBeaconSimulation alloc]init]];
    [self sendBeaconsRequest];
    
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBeaconSimulator:[[SWARMBeaconSimulation alloc]init]];
    [self sendBeaconsRequest];
}

- (void)setLabels {
    if ([self myBeacon]==nil) {
        return;
    }
    
    self.uuidLabel.text = [[self myBeacon]uuid];
    //self.beaconRegion.proximityUUID.UUIDString;
    self.majorLabel.text = [NSString stringWithFormat:@"%@ : %@", [[self myBeacon]major],[[self myBeacon]minor]];
   //self.minorLabel.text = [NSString stringWithFormat:@"%@", self.beaconRegion.minor];
    NSString *myRegionId =[NSString stringWithFormat:@"%@",[[self myBeacon]regionId] ];
    [self.identityLabel setText:myRegionId];

    [self.departmentDesc setText:[[self myBeacon]desc]];
    //self.beaconRegion.identifier;
}

-(void)initBeaconWithName:(NSString *)departmentName
{
    BLESBeacon *tmpBeacon;
    BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    for (BLESBeacon *bc in [mySession currentBeacons] ) {
        if ([[bc title]isEqualToString:departmentName]) {
            tmpBeacon = bc;
            break;
        }
    }
    
    if (tmpBeacon==nil) {
        NSLog(@"Beacon not found, using default.");

        //The TI beacon's uuid:
        //NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"F000AA11-0451-4000-B000-000000000000"];
        //NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"87C6317B-0C99-2F4C-DE12-57E9E64F679A"];
        //My macbooks uuid:
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];

        [[self beaconSimulator]initBeaconWithProximityUUID:uuid withMajor:40 withMinor:2210 withIdentifier:@"com.Sonrisa.myRegion"];
        
        
      /*  self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                    major:40
                                                                    minor:2210
                                                               identifier:@"com.Sonrisa.myRegion"];*/
        [self.departmentDesc setText:@"Beacon not found, using default."];
    }
    else
    {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[tmpBeacon uuid]];
        [[self beaconSimulator]initBeaconWithProximityUUID:uuid withMajor:[[tmpBeacon major]unsignedShortValue] withMinor: [[tmpBeacon minor]unsignedShortValue] withIdentifier:@"com.Sonrisa.myRegion"];
      /*  self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                    major:[[tmpBeacon major]unsignedShortValue]
                                                                    minor:[[tmpBeacon minor]unsignedShortValue]
                                                               identifier:@"com.Sonrisa.myRegion"];*/
        
        [self.departmentDesc setText:[tmpBeacon desc]];
        [self setMyBeacon:tmpBeacon];

    }
    
}

- (IBAction)setDepartment:(UISegmentedControl *)sender {
    [self initBeaconWithName:[[self departmentSelector] titleForSegmentAtIndex:sender.selectedSegmentIndex]];

    
    [self transmitBeacon:nil];
    [self setLabels];
    
}

- (IBAction)transmitBeacon:(UIButton *)sender {
    [[self beaconSimulator]startBeacon];
   
  /*  self.beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
*/
   }

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Powered On");
        [self.peripheralManager startAdvertising:self.beaconPeripheralData];
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"Powered Off");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bluetooth is turned off"
                                                        message:@"Please turn on Bluetooth to use this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self.peripheralManager stopAdvertising];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//TODO: move into restapi, implement delegate
#pragma mark Get beacons from server for demo
- (void)sendBeaconsRequest {
#if useMockUrls
    NSString *fullUrlString = mockBeaconsUrl;
#else
    NSString *fullUrlString = urlGetLocations;
#endif
    NSURL *fullUrl = [NSURL URLWithString:fullUrlString];
    NSLog(@"Sending Request to %@ ...",fullUrlString);
    [[self spinner]startAnimating];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:fullUrl];
        [self performSelectorOnMainThread:@selector(fetchedBeaconsData:) withObject:data waitUntilDone:YES];
        
        /* // once the code above returns you schedule a block on the main queue:
         dispatch_async(dispatch_get_main_queue(), ^{
         //      [self.delegate myDealderReturnedSomeData:[_myDealer someData] anotherArg:...];
         });*/
    });
}

- (NSMutableArray *)fetchedBeaconsData:(NSData *)responseData {
    if (responseData==nil) {
        NSLog(@"ConfigViewController - No beacon data received.");
        NSMutableArray *emptyArray =[[NSMutableArray alloc]init];
        return emptyArray;
    }
    
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    NSArray* beaconsArray = [json objectForKey:@"locations"];
    
    NSLog(@"received data: %@", beaconsArray);
    
    NSMutableArray *beacons = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *tmpBeacon in beaconsArray) {
        BLESBeacon *beacon = [BLESBeacon fromDictionary:tmpBeacon];
        [beacons addObject:beacon];
    }
    
    //TODO: elegansabban, pl meg egy esemenykezelo atadasaval?
    BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    [mySession setCurrentBeacons:beacons];
    
    if ([mySession currentBeacons]!=nil) {
        if ([[mySession currentBeacons]count]!=0) {
            //UISegmentedControlSegment *sgm = [[UISegmentedControlSegmentAny alloc]init];
            NSMutableArray *titles = [[NSMutableArray alloc]init];
            for (BLESBeacon *bc in [mySession currentBeacons]) {
                [titles addObject:[bc title]];
            }
            
            UISegmentedControl *tmpSc= [[UISegmentedControl alloc]initWithItems:titles];
            [tmpSc setSelectedSegmentIndex:0];
            NSUInteger cnt = [[self departmentSelector]numberOfSegments];
            
            for (NSUInteger ix = 0; ix < cnt; ix++) {
                [[self departmentSelector]removeSegmentAtIndex:0 animated:NO];
            }
            
            for (BLESBeacon *bc in [mySession currentBeacons]) {
                [[self departmentSelector]insertSegmentWithTitle:[bc title] atIndex:0 animated:NO];
            }
            [[self departmentSelector]setSelectedSegmentIndex:0];
            [self setMyBeacon:[beacons objectAtIndex:0]];
            [self setDepartment:[self departmentSelector]];
            //[self setDepartmentSelector:tmpSc];
        }
    }
    
    [self setLabels];
    [[self spinner]stopAnimating];
    return beacons;
}





@end
