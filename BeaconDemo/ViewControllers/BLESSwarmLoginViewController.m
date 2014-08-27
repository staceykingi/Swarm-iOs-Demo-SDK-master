//
//  BLESSwarmLoginViewController.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.27..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//
#define mySession [BLESDemoSession sharedManager]
#import "BLESSwarmLoginViewController.h"

@interface BLESSwarmLoginViewController ()
@property (strong,nonatomic) SWARMUserProfile *demoProfile;
@property (strong,nonatomic) NSArray *demoProfiles;
@property (strong,nonatomic) BLESDemoRestApi *demoRestApi;
@end

@implementation BLESSwarmLoginViewController
@synthesize demoProfile, demoProfiles, demoRestApi;


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
    
    //This helps to align the text to the top inside the textbox.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[mySession swarmSDK] setSwarmLoginCompletedDelegate:self];
    
   
    /*
     [[SWARMUserProfile alloc]init];
    [up setUserName:@"tyler"];
    [up setDesc:@"Login demo user, who likes hiking"];
    [up setPartnerId:@"sonrisa"];
    [up setRemoteId:@"tyler"];
    [up setVendorId:@"1"];
    [up setAdvertiserId:@"1"];
    
    SWARMSourceSegmentVector *tmpSSV = [[SWARMSourceSegmentVector alloc]init];
    [tmpSSV addTagToCategory:@"hiking" forCategory:@"interests"];
    [tmpSSV addTagToCategory:@"male" forCategory:@"gender"];
    [tmpSSV addTagToCategory:@"cooking" forCategory:@"interests"];
    [up setSourceSegmentVector:tmpSSV];*/

    
    
    [self setDemoProfiles:[[NSArray alloc]initWithObjects:[self getTylerProfile:YES], [self getAnneProfile:YES], [self getDavidProfile:YES], [self getJasonProfile:YES], [self getKateProfile:YES], [self getLisaProfile:YES], nil]];
    
    //  [self setDemoProfiles:[[NSArray alloc]initWithObjects:[self getTylerProfile:YES], [self getAnneProfile], [self getDavidProfile], [self getJasonProfile], [self getKateProfile], [self getLisaProfile], nil]];
    SWARMUserProfile *up =[[self demoProfiles]firstObject];
    [self setDemoProfile:[self removeCategoriesFromUserProfile:up]];
    [_requestText setText: [[self removeCategoriesFromUserProfile:up] toJson]];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendRequest:(id)sender {
    
        [_sendBtn setEnabled:NO];
    [_spinner startAnimating];
    [[mySession swarmSDK]doSwarmLogin:[self demoProfile]];
    
    
}

-(void)onSwarmLoginCompleted:(SWARMUserProfile*)userProfile withError:(NSError *)error
{
    [_spinner stopAnimating];
    [_sendBtn setEnabled:YES];
    [_responseText setText:[userProfile toJson]];
}
- (IBAction)userSelected:(id)sender {
    [self setDemoProfile:[self removeCategoriesFromUserProfile:[[self demoProfiles]objectAtIndex:[sender selectedSegmentIndex]]]];
    [_requestText setText:[[self removeCategoriesFromUserProfile:[self demoProfile]]toJson ]];
}
- (IBAction)userChanged:(id)sender {

}
- (IBAction)refreshClicked:(id)sender {
}

#pragma mark Load user profiles
- (void)refreshSegments
{
    //BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    [[self refreshSpinner]startAnimating];
    if (![[mySession reachabilityChecker] isOnline]) {
        NSLog(@"No connection.");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to use this app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [[self refreshSpinner]stopAnimating];
        return;
    }
    
    
    [self.demoRestApi sendUsersRequest];
    
}

-(void)onUsersRequestComplete:(NSMutableArray*)users
{
    NSLog(@"Delegate called hurray!");
    
    
    //  BLESDemoSession *mySession = [BLESDemoSession sharedManager];
    [mySession setDemoProfiles:users];
    
    if (users==nil) {
        [[self refreshSpinner]stopAnimating];
        //TODO: error msg?
    }
    
    //TODO: if 0, handle
    [self recreateSegments:users];
    [self.targetSelector setSelectedSegmentIndex:0 ];
    [mySession setCurrentUser:[users firstObject]];
    [[mySession swarmSDK]setSwarmId:[[users firstObject]customerSwarmId]];
    [[mySession swarmSDK]initRemoteId:[[users firstObject]remoteId]];
    
    [[self refreshSpinner]stopAnimating];
    
}


-(void)recreateSegments:(NSMutableArray*)users
{
    //Recreate the segments from the new users list
    

    NSUInteger cnt = [[self targetSelector]numberOfSegments];
    for (NSUInteger ix = 0; ix < cnt; ix++) {
        [[self targetSelector]removeSegmentAtIndex:0 animated:NO];
    }
    
    
    //Insert the user names as segments, the indexes will be the same as in the array
    for (SWARMUserProfile *bup in users) {
        [[self targetSelector]insertSegmentWithTitle:[bup userName] atIndex:[_targetSelector numberOfSegments] animated:NO];
        //NSLog(@"Inserting segment with name %@, the index of the user is %u",[bup userName], [_targetSelector numberOfSegments]-1);
    }
}

#pragma mark -

-(SWARMUserProfile*)removeCategoriesFromUserProfile:(SWARMUserProfile*)profile
{
    SWARMUserProfile *up = [SWARMUserProfile copyProfile:profile filterForCategories:[NSArray arrayWithObjects:@"age", @"gender",@"interest",@"interests", nil]];
    
    return up;
                            
}


#pragma mark Hardcoded profiles
-(SWARMUserProfile*)getTylerProfile:(BOOL)withBrands
{
    SWARMUserProfile *up = [[SWARMUserProfile alloc]init];
    [up setUserName:@"Tyler"];
    [up setDesc:@"Login demo user, who likes hiking"];
    [up setPartnerId:@"sonrisa"];
    [up setRemoteId:@"tyler"];
    [up setVendorId:@"599F9C00-92DC-4B5C-9464-7971F01F8370"];
    [up setAdvertiserId:@"1E2DFA89-496A-47FD-9941-DF1FC4E6484A"];
    [up setCustomerSwarmId:@"0"];
    
    SWARMSourceSegmentVector *tmpSSV = [[SWARMSourceSegmentVector alloc]init];

    
    [tmpSSV addTagToCategory:@"5941" forCategory: @"topConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"451110" forCategory: @"topConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Sports" forCategory:@"topConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Bicycling" forCategory:@"topConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"5661" forCategory:@"secondConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"448210" forCategory: @"secondConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Sports" forCategory:@"secondConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Running/Jogging" forCategory:@"secondConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"5091" forCategory:@"thirdConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"451110" forCategory:@"thirdConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Sports" forCategory:@"thirdConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Canoeing & Kayaking" forCategory:@"thirdConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"Nike" forCategory:@"topBrand"];
    [tmpSSV addTagToCategory:@"Mizuno" forCategory:@"secondBrand"];
    [tmpSSV addTagToCategory:@"Asics" forCategory:@"thirdBrand"];
    [tmpSSV addTagToCategory:@"hiking" forCategory:@"interests"];
    [tmpSSV addTagToCategory:@"male" forCategory:@"gender"];
    [tmpSSV addTagToCategory:@"cooking" forCategory:@"interests"];
    [tmpSSV addTagToCategory:@"hiking" forCategory:@"interest"];
    [tmpSSV addTagToCategory:@"35" forCategory:@"age"];

    [up setSourceSegmentVector:tmpSSV];
    return up;
}


-(SWARMUserProfile*)getAnneProfile:(BOOL)withBrands
{
    SWARMUserProfile *up = [[SWARMUserProfile alloc]init];
    [up setUserName:@"Anne"];
    [up setCustomerSwarmId:@"1"];
    [up setDesc:@"Anne is 69 years old, and loves to read books sitting next to the fireplace."];
    [up setPartnerId:@"sonrisa"];
    [up setRemoteId:@"anne1234"];
    [up setVendorId:@"599F9C00-92DC-4B5C-9464-7971F01F8370"];
    [up setAdvertiserId:@"2E2DFB89-496A-21FD-8245-ZF1FC1E2434Y"];

    
    SWARMSourceSegmentVector *tmpSSV = [[SWARMSourceSegmentVector alloc]init];
    
    
    [tmpSSV addTagToCategory:@"5192" forCategory: @"topConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"451211" forCategory: @"topConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Arts & Entertainment" forCategory:@"topConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Books & Literature" forCategory:@"topConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"5149" forCategory:@"secondConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"453910" forCategory: @"secondConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Pets" forCategory:@"secondConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Dogs" forCategory:@"secondConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"5946" forCategory:@"thirdConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"443142" forCategory:@"thirdConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Technology & Computing" forCategory:@"thirdConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Cameras & Camcorders" forCategory:@"thirdConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"Dorling Kindersley UK" forCategory:@"topBrand"];
    [tmpSSV addTagToCategory:@"Go Travel" forCategory:@"secondBrand"];
    [tmpSSV addTagToCategory:@"Leica" forCategory:@"thirdBrand"];
    [tmpSSV addTagToCategory:@"reading" forCategory:@"interests"];
    [tmpSSV addTagToCategory:@"female" forCategory:@"gender"];
    [tmpSSV addTagToCategory:@"knitting" forCategory:@"interests"];
    [tmpSSV addTagToCategory:@"reading" forCategory:@"interest"];
    [tmpSSV addTagToCategory:@"69" forCategory:@"age"];

    
    [up setSourceSegmentVector:tmpSSV];
    return up;
}


-(SWARMUserProfile*)getKateProfile:(BOOL)withBrands
{
    SWARMUserProfile *up = [[SWARMUserProfile alloc]init];
    [up setUserName:@"Kate"];
    [up setCustomerSwarmId:@"2"];
    [up setDesc:@"Kate is 21, and she loves fashion. She spends most of her money on clothes and shoes."];
    [up setPartnerId:@"sonrisa"];
    [up setRemoteId:@"kate"];
    [up setVendorId:@"599F9C00-92DC-4B5C-9464-7971F01F8370"];
    [up setAdvertiserId:@"7E2OLD12-333A-12AE-2843-AE1RZ4P4731Z"];
    
    
    SWARMSourceSegmentVector *tmpSSV = [[SWARMSourceSegmentVector alloc]init];
    
    
    [tmpSSV addTagToCategory:@"5651" forCategory: @"topConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"448140" forCategory: @"topConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Style & Fashion" forCategory:@"topConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Clothing" forCategory:@"topConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"5661" forCategory:@"secondConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"448210" forCategory: @"secondConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Style & Fashion" forCategory:@"secondConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Clothing" forCategory:@"secondConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"5461" forCategory:@"thirdConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"311811" forCategory:@"thirdConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Food & Drink" forCategory:@"thirdConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Desserts & Baking" forCategory:@"thirdConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"Anyi Lu" forCategory:@"topBrand"];
    [tmpSSV addTagToCategory:@"Praire Underground" forCategory:@"secondBrand"];
    [tmpSSV addTagToCategory:@"Nine West" forCategory:@"thirdBrand"];
    [tmpSSV addTagToCategory:@"fashion" forCategory:@"interests"];
    [tmpSSV addTagToCategory:@"female" forCategory:@"gender"];
    [tmpSSV addTagToCategory:@"cooking" forCategory:@"interests"];
    [tmpSSV addTagToCategory:@"shoues" forCategory:@"interests"];
    [tmpSSV addTagToCategory:@"21" forCategory:@"age"];
    
    [up setSourceSegmentVector:tmpSSV];
    return up;
}

-(SWARMUserProfile*)getDavidProfile:(BOOL)withBrands
{
    SWARMUserProfile *up = [[SWARMUserProfile alloc]init];
    [up setUserName:@"David"];
    [up setCustomerSwarmId:@"3"];
    [up setDesc:@"28 year old male into the outdoors."];
    [up setPartnerId:@"sonrisa"];
    [up setRemoteId:@"david"];
    [up setVendorId:@"599F9C00-92DC-4B5C-9464-7971F01F8370"];
    [up setAdvertiserId:@"3G5ZDD18-234L-23LE-9298-ZK1RZ4P4731Z"];
    
    
    SWARMSourceSegmentVector *tmpSSV = [[SWARMSourceSegmentVector alloc]init];
    
    
    [tmpSSV addTagToCategory:@"5091" forCategory: @"topConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"451110" forCategory: @"topConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Style & Fashion" forCategory:@"topConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Clothing" forCategory:@"topConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"5091" forCategory:@"secondConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"451110" forCategory: @"secondConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Sports" forCategory:@"secondConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Surfing/Bodyboarding" forCategory:@"secondConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"5812" forCategory:@"thirdConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"722513" forCategory:@"thirdConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Food & Drink" forCategory:@"thirdConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Mexican Cuisine" forCategory:@"thirdConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"The North Face" forCategory:@"topBrand"];
    [tmpSSV addTagToCategory:@"O'Neill" forCategory:@"secondBrand"];
    [tmpSSV addTagToCategory:@"Corona" forCategory:@"thirdBrand"];
    [tmpSSV addTagToCategory:@"mountain climbing" forCategory:@"interests"];
    [tmpSSV addTagToCategory:@"surfing" forCategory:@"interests"];
    [tmpSSV addTagToCategory:@"mountain climbing" forCategory:@"interest"];
    [tmpSSV addTagToCategory:@"28" forCategory:@"age"];
    [tmpSSV addTagToCategory:@"male" forCategory:@"gender"];
    
    [up setSourceSegmentVector:tmpSSV];
    return up;
}


-(SWARMUserProfile*)getJasonProfile:(BOOL)withBrands
{
    SWARMUserProfile *up = [[SWARMUserProfile alloc]init];
    [up setUserName:@"Jason"];
    [up setCustomerSwarmId:@"4"];
    [up setDesc:@"23 year old male into clubbing"];
    [up setPartnerId:@"swarm"];
    [up setRemoteId:@"jason"];
    [up setVendorId:@" 599F9C00-92DC-4B5C-9464-7971F01F8370"];
    [up setAdvertiserId:@"7E9ZED34-384S-28LZ-2399-OK1RZ4P8472B"];
    
    
    SWARMSourceSegmentVector *tmpSSV = [[SWARMSourceSegmentVector alloc]init];
    
    
    [tmpSSV addTagToCategory:@"5813" forCategory: @"topConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"722410" forCategory: @"topConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Food & Drink" forCategory:@"topConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Cocktails/Beer" forCategory:@"topConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"5182" forCategory:@"secondConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"445310" forCategory: @"secondConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Food & Drink" forCategory:@"secondConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Wine" forCategory:@"secondConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"5611" forCategory:@"thirdConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"448110" forCategory:@"thirdConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Style & Fashion" forCategory:@"thirdConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Clothing" forCategory:@"thirdConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"Stella Artois" forCategory:@"topBrand"];
    [tmpSSV addTagToCategory:@"Pappy Van Winkle" forCategory:@"secondBrand"];
    [tmpSSV addTagToCategory:@"Common Projects" forCategory:@"thirdBrand"];
    [tmpSSV addTagToCategory:@"clubbing" forCategory:@"interests"];
    [tmpSSV addTagToCategory:@"whiskey" forCategory:@"interests"];
//    [tmpSSV addTagToCategory:@"whiskey" forCategory:@"interest"];
    [tmpSSV addTagToCategory:@"23" forCategory:@"age"];
    [tmpSSV addTagToCategory:@"male" forCategory:@"gender"];
    
    [up setSourceSegmentVector:tmpSSV];
    return up;
}

-(SWARMUserProfile*)getLisaProfile:(BOOL)withBrands
{
    SWARMUserProfile *up = [[SWARMUserProfile alloc]init];
    [up setUserName:@"Lisa"];
    [up setCustomerSwarmId:@"5"];
    [up setDesc:@"35 year old female bicyclist just had a child"];
    [up setPartnerId:@"sonrisa"];
    [up setRemoteId:@"lisa"];
    [up setVendorId:@"599F9C00-92DC-4B5C-9464-7971F01F8370"];
    [up setAdvertiserId:@"8O3DUZ53-923E-01EF-0823-SD3RF5D4399E"];
    
    
    SWARMSourceSegmentVector *tmpSSV = [[SWARMSourceSegmentVector alloc]init];
    
    
    [tmpSSV addTagToCategory:@"5941" forCategory: @"topConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"451110" forCategory: @"topConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Sports" forCategory:@"topConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Bicycling" forCategory:@"topConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"5948" forCategory:@"secondConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"448320" forCategory: @"secondConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Style & Fashion" forCategory:@"secondConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Accessories" forCategory:@"secondConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"5641" forCategory:@"thirdConsumerInterestBySIC"];
    [tmpSSV addTagToCategory:@"448130" forCategory:@"thirdConsumerInterestByNAICS"];
    [tmpSSV addTagToCategory:@"Family & Parenting" forCategory:@"thirdConsumerInterestByIABTier1"];
    [tmpSSV addTagToCategory:@"Babies & Toddlers" forCategory:@"thirdConsumerInterestByIABTier2"];
    [tmpSSV addTagToCategory:@"Kona Bicycles" forCategory:@"topBrand"];
    [tmpSSV addTagToCategory:@"Caribee Backpacks" forCategory:@"secondBrand"];
    [tmpSSV addTagToCategory:@"MamaRoo" forCategory:@"thirdBrand"];
    [tmpSSV addTagToCategory:@"bicycling" forCategory:@"interests"];
    [tmpSSV addTagToCategory:@"travel" forCategory:@"interests"];
    [tmpSSV addTagToCategory:@"bicycling" forCategory:@"interest"];
    [tmpSSV addTagToCategory:@"35" forCategory:@"age"];
    [tmpSSV addTagToCategory:@"female" forCategory:@"gender"];
    
    [up setSourceSegmentVector:tmpSSV];
    return up;
}
#pragma mark -
@end
