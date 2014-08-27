//
//  BLESCampaignCell.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.01.10..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import "BLESCampaignCell.h"

@implementation BLESCampaignCell
@synthesize myCampaign;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
