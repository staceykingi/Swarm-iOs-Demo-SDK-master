//
//  SWARMWhatIsHereInformation.h
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.31..
//  Copyright (c) 2014 Swarm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWARMWhatIsHereInformation : NSObject

//Array of SWARMLocationInformaion
@property (strong,nonatomic) NSMutableArray *locations;
//Array of SWARMAction
-(NSArray*)getActions;
//Array of BLESCampaign
-(NSArray*)getCampaigns;
@end
