//
//  OPIPTableViewCell.h
//  pickapic
//
//  Created by Steve Brown on 8/26/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPIPTableViewCell : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *addPointButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *subtractPointButton;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *playerProfileImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *scoreLabel;

@end
