//
//  gTableViewCell.h
//  PickAPic
//
//  Created by William A. Brown on 6/25/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *gCellImageView;
@property (weak, nonatomic) IBOutlet UILabel *gCellGroupName;
@property (weak, nonatomic) IBOutlet UILabel *gCellFreindsList;
@property (weak, nonatomic) IBOutlet UILabel *gTimeRemaining;

@end
