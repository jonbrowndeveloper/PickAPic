//
//  LeaderboardViewController.m
//  PickAPic
//
//  Created by William A. Brown on 6/29/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "LeaderboardTableViewCell.h"

@interface LeaderboardViewController ()

@end

@implementation LeaderboardViewController

@synthesize leaderboardButton, settingsButton, leaderboardItem, profileImageView, firstNameLabel, numOfGamesLabel, numOfPointsLabel, numOfWinsLabel, gameNewButton, tableView, leaderboardDict, leaderboardSegmentedControl, friendsArray, groupsDicts, papLeaderArray, groupNames;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set 'Pick A Pic' logo on navigation bar
    
    UIImage *logo = [UIImage imageNamed:@"icn_logo.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:logo];
    imgView.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.width * 0.75), (self.navigationController.navigationBar.frame.size.height * 0.75));
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imgView;
    
    // profile imageview
    
    profileImageView.image = [UIImage imageNamed:@"profilePicPH.png"];
    profileImageView.layer.cornerRadius = (profileImageView.frame.size.height)/2;
    profileImageView.layer.masksToBounds = YES;
    profileImageView.layer.borderColor = [UIColor grayColor].CGColor;
    profileImageView.layer.borderWidth = 3.0;
    CGRect frame = profileImageView.frame;
    frame.size.width = profileImageView.frame.size.width;
    frame.size.height = profileImageView.frame.size.height;
    profileImageView.frame = frame;
    
    // navbar color
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:161.0/255.0 blue:203.0/255.0 alpha:1]];
    
    // New Game button
    
    CALayer *btnLayer = [gameNewButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setBorderWidth:2.0f];
    [btnLayer setBorderColor:[UIColor colorWithRed:57.0/255.0 green:181.0/255.0 blue:74.0/255.0 alpha:1].CGColor];
    [btnLayer setBackgroundColor:[UIColor colorWithRed:75.0/255.0 green:142.0/255.0 blue:16.0/255.0 alpha:1].CGColor];
    [btnLayer setCornerRadius:8.0f];
    
    // create some text for the button with the finger image
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"  New Game"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString length])];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"icn_button_newgame_small.png"];
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    
    [attributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:attrStringWithImage];
    
    [self.gameNewButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    // set labels for user
    
    // set text for other labels
    [self setTextForLabels:[UIImage imageNamed:@"icn_profile_star.png"] string:@" 150,000 Points" label:self.numOfPointsLabel];
    [self setTextForLabels:[UIImage imageNamed:@"icn_profile_trophey.png"] string:@" 10,000 Wins" label:self.numOfWinsLabel];
    [self setTextForLabels:[UIImage imageNamed:@"icn_profile_game.png"] string:@" 100,000 Games" label:self.numOfGamesLabel];
    
    self.firstNameLabel.text = @"Jon";
    
    // load in placeholder leaderboard from plist
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"placeholderLeaderboard" ofType:@"plist"];
    leaderboardDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    // NSLog(@"dictionary: %@", leaderboardDict);
    
    groupsDicts = [[NSDictionary alloc] initWithDictionary:[leaderboardDict objectForKey:@"Groups"]];
    friendsArray = [[NSArray alloc] initWithArray:[leaderboardDict objectForKey:@"Friends"]];
    papLeaderArray = [[NSArray alloc] initWithArray:[leaderboardDict objectForKey:@"PickAPick"]];
    
    groupNames = [groupsDicts allKeys];

}

- (void)setTextForLabels:(UIImage *)image string:(NSString *)string label:(UILabel *)label
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [attributedString length])];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:attrStringWithImage];
    
    label.attributedText = attributedString;
    label.adjustsFontSizeToFitWidth = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    // leaderboard button
    
    leaderboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leaderboardButton.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.height *0.65), (self.navigationController.navigationBar.frame.size.height *0.65));
    [leaderboardButton setImage:[UIImage imageNamed:@"icn_leaderboards_active"] forState:UIControlStateNormal];
    // [leaderboardButton setImage:[UIImage imageNamed:@"icn_leaderboards_active"] forState:(UIControlStateSelected | UIControlStateHighlighted)];
    [leaderboardButton setSelected:YES];
    
    leaderboardItem = [[UIBarButtonItem alloc] initWithCustomView:leaderboardButton];
    
    // settings button
    
    settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.height *0.65), (self.navigationController.navigationBar.frame.size.height *0.65));
    [settingsButton setImage:[UIImage imageNamed:@"icn_settings"] forState:UIControlStateNormal];
    [settingsButton setImage:[UIImage imageNamed:@"icn_settings_active"] forState:(UIControlStateSelected | UIControlStateHighlighted)];
    [settingsButton setSelected:YES];
    
    [settingsButton addTarget:self action:@selector(activateSettingsSegue) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settingsItem, leaderboardItem, nil];
    
    // back button
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.height *0.65), (self.navigationController.navigationBar.frame.size.height *0.65));
    [backButton setImage:[UIImage imageNamed:@"icn_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icn_back_active"] forState:(UIControlStateSelected | UIControlStateHighlighted)];
    [backButton setSelected:YES];
    
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (leaderboardSegmentedControl.selectedSegmentIndex == 0)
    {
        // GROUPS
        return [groupsDicts count];
        
    }
    else if (leaderboardSegmentedControl.selectedSegmentIndex == 1)
    {
        // FRIENDS
        return 1;
        
    }
    else
    {
        // PICK A PICK LEADERBOARD
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of sections.
    if (leaderboardSegmentedControl.selectedSegmentIndex == 0)
    {
        // GROUPS
        NSArray *keys = [groupsDicts allKeys];
        return [[groupsDicts objectForKey:[keys objectAtIndex:section]] count];
        
    }
    else if (leaderboardSegmentedControl.selectedSegmentIndex == 1)
    {
        // FRIENDS
        return [friendsArray count];
        
    }
    else
    {
        // PICK A PICK LEADERBOARD
        return [papLeaderArray count];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaderboardTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"leaderboardCell" forIndexPath:indexPath];
    
    if (leaderboardSegmentedControl.selectedSegmentIndex == 0)
    {
        // GROUPS
        NSArray *quickArray = [[NSArray alloc] initWithArray:[groupsDicts objectForKey:groupNames[indexPath.section]]];
        cell.nameLabel.text = quickArray[indexPath.row][0];
        cell.pointsLabel.text = [NSString stringWithFormat:@"%@ Points", quickArray[indexPath.row][1]];
        cell.winsLabel.text = [NSString stringWithFormat:@"%@ Wins", quickArray[indexPath.row][2]];
        
        NSLog(@"we are configuring a groups cell at %ld\nThe name is: %@", (long)indexPath.row, quickArray[indexPath.row][0]);
    }
    else if (leaderboardSegmentedControl.selectedSegmentIndex == 1)
    {
        // FRIENDS
        cell.nameLabel.text = friendsArray[indexPath.row][0];
        cell.pointsLabel.text = [NSString stringWithFormat:@"%@ Points", friendsArray[indexPath.row][1]];
        cell.winsLabel.text = [NSString stringWithFormat:@"%@ Wins", friendsArray[indexPath.row][2]];
        
    }
    else if (leaderboardSegmentedControl.selectedSegmentIndex == 2)
    {
        // PICK A PICK LEADERBOARD
        cell.nameLabel.text = papLeaderArray[indexPath.row][0];
        cell.pointsLabel.text = [NSString stringWithFormat:@"%@ Points", papLeaderArray[indexPath.row][1]];
        cell.winsLabel.text = [NSString stringWithFormat:@"%@ Wins", papLeaderArray[indexPath.row][2]];
    }
    
    // [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,200,300,244)];
    
    if (leaderboardSegmentedControl.selectedSegmentIndex == 0)
    {
        // GROUPS
        tempView.backgroundColor=[UIColor whiteColor];
        
        UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,15)];
        tempLabel.shadowOffset = CGSizeMake(0,2);
        tempLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:161.0/255.0 blue:203.0/255.0 alpha:1];
        tempLabel.font = [UIFont fontWithName:@"Lato-Light.ttf" size:8.0];
        tempLabel.font = [UIFont boldSystemFontOfSize:10.0];
        tempLabel.text = groupNames[section];
        
        [tempView addSubview:tempLabel];
        
    }
    else if (leaderboardSegmentedControl.selectedSegmentIndex == 1)
    {
        // FRIENDS
        tempView.backgroundColor=[UIColor whiteColor];
        
        UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,15)];
        tempLabel.shadowOffset = CGSizeMake(0,2);
        tempLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:161.0/255.0 blue:203.0/255.0 alpha:1];
        tempLabel.font = [UIFont fontWithName:@"Lato-Light.ttf" size:8.0];
        tempLabel.font = [UIFont boldSystemFontOfSize:10.0];
        tempLabel.text = @"Your Friends";
        
        [tempView addSubview:tempLabel];
        
    }
    else
    {
        // PICK A PICK LEADERBOARD
        tempView.backgroundColor=[UIColor whiteColor];
        
        UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,15)];
        tempLabel.shadowOffset = CGSizeMake(0,2);
        tempLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:161.0/255.0 blue:203.0/255.0 alpha:1];
        tempLabel.font = [UIFont fontWithName:@"Lato-Light.ttf" size:8.0];
        tempLabel.font = [UIFont boldSystemFontOfSize:10.0];
        tempLabel.text = @"Pick A Pic Network";
        
        [tempView addSubview:tempLabel];
    }
    
    return tempView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)activateSettingsSegue
{
    [self performSegueWithIdentifier:@"leaderboardToSettings" sender:self];
}

- (IBAction)segmentedValueChanged:(id)sender
{
    [self.tableView reloadData];
}
@end
