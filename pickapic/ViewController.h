//
//  ViewController.h
//  PickAPic
//
//  Created by William A. Brown on 6/18/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UIButton *leaderboardButton;
@property (nonatomic, retain) UIButton *settingsButton;
@property (nonatomic, retain) UIBarButtonItem *leaderboardItem;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundProfileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *gameNewButton;

// labels

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfWinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfGamesLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

