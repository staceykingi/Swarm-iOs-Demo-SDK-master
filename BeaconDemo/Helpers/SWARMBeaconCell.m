//
//  SWARMBeaconCell.m
//  BeaconDemo
//
//  Created by Ákos Radványi on 2014.02.25..
//  Copyright (c) 2014 Sonrisa. All rights reserved.
//

#import "SWARMBeaconCell.h"

@implementation SWARMBeaconCell

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

-(void)updateLabels
{
    [_accuracyLabel setText:[NSString stringWithFormat:@"%f",[_myBeacon accuracy] ]];
    [_snrLabel setText:[NSString stringWithFormat:@"%ld (dB)",(long)[_myBeacon rssi]]];
    [_mamiLabel setText:[NSString stringWithFormat:@"%@ : %@",[_myBeacon major],[_myBeacon minor]]];
    
    NSString *prox = @"(null)";
    
    switch ([_myBeacon proximity]) {
        case CLProximityFar:
            prox = @"Far";
            break;
        case CLProximityImmediate:
            prox = @"Immediate";
            break;
        case CLProximityNear:
            prox = @"Near";
            break;
        case CLProximityUnknown:
            prox = @"Unknown";
            break;
            
        default:
            prox = @"Error";
            break;
    }
    [_proximityLabel setText:prox];
    [_uuidLabel setText:[NSString stringWithFormat:@"%@",[[_myBeacon proximityUUID]UUIDString]]];
    
    
}

@end
