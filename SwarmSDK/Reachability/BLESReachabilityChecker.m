//
//  BLESReachabilityChecker.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.10..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import "BLESReachabilityChecker.h"
#import "BLESUrlDefinitions.h"


@implementation BLESReachabilityChecker
@synthesize hostReachability;
@synthesize internetReachability;
@synthesize wifiReachability;
@synthesize isOnline;

-(id)init
{
    if (self = [super init]) {
        //Change the host name here to change the server you want to monitor.
#if useMockUrls
        NSString *remoteHostName = baseUrlMockForReachability;
#else
        NSString *remoteHostName = baseUrlForReachability;
#endif
        
        /*
         Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
         */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kSWARMReachabilityChangedNotification object:nil];
        
        self.hostReachability = [SWARMReachability reachabilityWithHostName:remoteHostName];
        [self.hostReachability startNotifier];
        [self updateInterfaceWithReachability:self.hostReachability];
        
        self.internetReachability = [SWARMReachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
        [self updateInterfaceWithReachability:self.internetReachability];
        
        self.wifiReachability = [SWARMReachability reachabilityForLocalWiFi];
        [self.wifiReachability startNotifier];
        [self updateInterfaceWithReachability:self.wifiReachability];

    }
    
    return self;
}

#pragma mark Reachability
/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
	SWARMReachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[SWARMReachability class]]);
	[self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(SWARMReachability *)reachability
{
    
    if (reachability == self.hostReachability)
	{
		//[self configureTextField:self.remoteHostStatusField imageView:self.remoteHostImageView reachability:reachability];
      //  NetworkStatus netStatus = [reachability currentReachabilityStatus];
        BOOL connectionRequired = [reachability connectionRequired];
        
        //self.summaryLabel.hidden = (netStatus != ReachableViaWWAN);
        NSString* baseLabelText = @"";
        
        if (connectionRequired)
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
        }
        else
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
        }
        //self.summaryLabel.text = baseLabelText;
    }
    
	if (reachability == self.internetReachability)
	{
		[self configureOnlineStatus:  reachability];
	}
    
	if (reachability == self.wifiReachability)
	{
		[self configureOnlineStatus: reachability];
    }
    
}

- (void)configureOnlineStatus: (SWARMReachability *)reachability
{
    SWARMNetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            // imageView.image = [UIImage imageNamed:@"stop-32.png"] ;
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
            self.isOnline = NO;
            break;
        }
            
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            // imageView.image = [UIImage imageNamed:@"WWAN5.png"];
            self.isOnline =YES;
            break;
        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            // imageView.image = [UIImage imageNamed:@"Airport.png"];
            self.isOnline=YES;
            break;
        }
    }
    
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
    //textField.text= statusString;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSWARMReachabilityChangedNotification object:nil];
}
#pragma mark -


@end
