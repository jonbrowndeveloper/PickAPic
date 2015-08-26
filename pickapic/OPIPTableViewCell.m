//
//  OPIPTableViewCell.m
//  pickapic
//
//  Created by Steve Brown on 8/26/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import "OPIPTableViewCell.h"

@implementation OPIPTableViewCell

@synthesize playerNameLabel, playerProfileImageView, addPointButton, subtractPointButton, scoreLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
