//
//  BLESChangeUUIDViewController.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.25..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//
#define mySession [BLESDemoSession sharedManager]

#import "BLESChangeUUIDViewController.h"

@interface BLESChangeUUIDViewController ()
@property (strong,nonatomic) BLESDemoRestApi *demoRestApi;
@property (strong,nonatomic) NSArray *myDataSource;
@property (strong,nonatomic) NSString *selectedUuidString;
@end

@implementation BLESChangeUUIDViewController

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
    
    [self setDemoRestApi:[[BLESDemoRestApi alloc]init]];
    [_demoRestApi setBeaconsListRequestCompletedDelegate:self];
    [self setMyDataSource:[[NSArray alloc]init] ];
    [_demoRestApi sendBeaconsRequest];
    [[self spinner]startAnimating];
    [_uuidChooser setDataSource:self];
    [_uuidChooser setDelegate:self];
    [_acceptBtn setEnabled:NO];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAcceptClicked:(id)sender {
    if (_selectedUuidString ==nil) {
        return;
        //TODO: error msg?
    }
    
    NSUUID *tmpUuid;
    @try {
        tmpUuid = [[NSUUID alloc]initWithUUIDString:_selectedUuidString];
        [[mySession swarmSDK]setSwarmUuid:tmpUuid];
        [self.navigationController popViewControllerAnimated:TRUE];
    }
    @catch (NSException *exception) {
        NSLog(@"Wrong uuid format");
        [_statusLbl setText:@"The selected value could not be converted into UUID."];

        return;
        
    }
    @finally {
        
    }
    
    
}

-(void)onBeaconsListRequestCompleted:(NSArray *)responseData withError:(NSError *)error
{
    [_spinner stopAnimating];
    
    if (responseData==nil || error!=nil) {
        [_statusLbl setText:@"There was an error during the request, please try again."];
        
        [_uuidChooser setHidden:YES];
        return;
    }
    [_statusLbl setText:@""];
    [_uuidChooser setHidden:NO];
    
    NSMutableArray *uuidArray = [[NSMutableArray alloc]init];
    for (BLESBeacon *bc in responseData) {
        if ([uuidArray containsObject:[bc uuid]]) {
            continue;
        }
        [uuidArray addObject:[bc uuid]];
    }
    [self setMyDataSource:uuidArray];
    _selectedUuidString = [[self myDataSource]firstObject];
    [_acceptBtn setEnabled:YES];

    [_uuidChooser reloadAllComponents];
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_myDataSource count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    NSLog(@"%@", [_myDataSource objectAtIndex:row]);
    return [_myDataSource objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    _selectedUuidString = [_myDataSource objectAtIndex:row];
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
 
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
      
        pickerLabel = [[UILabel alloc] init] ;
        [pickerLabel setTextAlignment:UITextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
    
    [pickerLabel setText:[_myDataSource objectAtIndex:row]];
    return pickerLabel;
}
@end
