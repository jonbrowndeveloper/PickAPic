//
//  LeaderboardViewController.h
//  PickAPic
//
//  Created by William A. Brown on 6/29/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderboardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton *leaderboardButton;
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, retain) UIBarButtonItem *leaderboardItem;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfWinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfGamesLabel;
@property (weak, nonatomic) IBOutlet UIButton *gameNewButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *leaderboardDict;
@property (strong, nonatomic) NSArray *friendsArray;
@property (strong, nonatomic) NSArray *papLeaderArray;
@property (strong, nonatomic) NSArray *groupNames;
@property (strong, nonatomic) NSDictionary *groupsDicts;

@property (weak, nonatomic) IBOutlet UISegmentedControl *leaderboardSegmentedControl;
- (IBAction)segmentedValueChanged:(id)sender;

@end
