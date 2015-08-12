//
//  ViewController.m
//  PickAPic
//
//  Created by William A. Brown on 6/18/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import "ViewController.h"
#import "constants.h"
#import "gTableViewCell.h"

@interface ViewController ()



@end

@implementation ViewController

@synthesize leaderboardButton, leaderboardItem, backgroundProfileImageView, gameNewButton, profileImageView, tableView, settingsButton, numberOfGamesLabel, numberOfPointsLabel, numberOfWinsLabel, firstNameLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupConstraints];
    
    // tableView.scrollEnabled = NO;
    // tableView.alwaysBounceVertical = NO;
    
    // tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.frame.size.height+(6*60)+40);
    
    // set 'Pick A Pic' logo on navigation bar
    
    UIImage *logo = [UIImage imageNamed:@"icn_logo.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:logo];
    imgView.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.width * 0.75), (self.navigationController.navigationBar.frame.size.height * 0.75));
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imgView;
    
    // navbar color
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:161.0/255.0 blue:203.0/255.0 alpha:1]];
    

    // background profile imageview setup
    
    backgroundProfileImageView.image = [UIImage imageNamed:@"HomePartyImage.png"];
    backgroundProfileImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    // profile imageview
    
    profileImageView.image = [UIImage imageNamed:@"profilePicPH.png"];
    profileImageView.layer.cornerRadius = (profileImageView.frame.size.height)/2;
    profileImageView.layer.masksToBounds = YES;
    profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    profileImageView.layer.borderWidth = 3.0;
    CGRect frame = profileImageView.frame;
    frame.size.width = profileImageView.frame.size.width;
    frame.size.height = profileImageView.frame.size.height;
    profileImageView.frame = frame;
    
    // TODO: create gradient of black (dark at the bottom, clear at top) for the background imageview
    
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
    
    // set text for other labels
    [self setTextForLabels:[UIImage imageNamed:@"icn_profile_star.png"] string:@" 150,000 Points" label:self.numberOfPointsLabel];
    [self setTextForLabels:[UIImage imageNamed:@"icn_profile_trophey.png"] string:@" 10,000 Wins" label:self.numberOfWinsLabel];
    [self setTextForLabels:[UIImage imageNamed:@"icn_profile_game.png"] string:@" 100,000 Games" label:self.numberOfGamesLabel];
    
    self.firstNameLabel.text = @"Jon";
    
}

- (void)setTextForLabels:(UIImage *)image string:(NSString *)string label:(UILabel *)label
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString length])];
    
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
    [leaderboardButton setImage:[UIImage imageNamed:@"icn_leaderboards"] forState:UIControlStateNormal];
    [leaderboardButton setImage:[UIImage imageNamed:@"icn_leaderboards_active"] forState:(UIControlStateSelected | UIControlStateHighlighted)];
    [leaderboardButton setSelected:YES];
    
    [leaderboardButton addTarget:self action:@selector(activateLeaderboardSegue) forControlEvents:UIControlEventTouchUpInside];
    
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
    // this duplication on the left side is to keep everything centered for the titleview
    // but it will likely need to be changed on other pages to the back button and an empty space
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:settingsItem, leaderboardItem, nil];
    

}

#pragma mark tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0)
    {
        return 3;
    }
    else
    {
        return 3;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    gTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"gameCell" forIndexPath:indexPath];
    cell.gCellImageView.image = [UIImage imageNamed:@"profilePicPH.png"];
    
    // [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,200,300,244)];
    if(section == 0)
    {
        
        tempView.backgroundColor=[UIColor clearColor];
        
        UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,15)];
        tempLabel.backgroundColor=[UIColor whiteColor];
        tempLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:161.0/255.0 blue:203.0/255.0 alpha:1];
        tempLabel.font = [UIFont fontWithName:@"Lato-Light.ttf" size:8.0];
        tempLabel.font = [UIFont boldSystemFontOfSize:10.0];
        tempLabel.text=@"CURRENT GAMES";
        
        [tempView addSubview:tempLabel];
    }
    else
    {
        tempView.backgroundColor=[UIColor whiteColor];
        
        UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,15)];
        tempLabel.shadowOffset = CGSizeMake(0,2);
        tempLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:161.0/255.0 blue:203.0/255.0 alpha:1];
        tempLabel.font = [UIFont fontWithName:@"Lato-Light.ttf" size:8.0];
        tempLabel.font = [UIFont boldSystemFontOfSize:10.0];
        tempLabel.text=@"PENDING GAMES";
        
        [tempView addSubview:tempLabel];
    }


    return tempView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma button and segues

- (void)activateSettingsSegue
{
    [self performSegueWithIdentifier:@"toSettings" sender:self];
}

- (void)activateLeaderboardSegue
{
    [self performSegueWithIdentifier:@"toLeaderboard" sender:self];
}


- (void)setupConstraints
{
    // self.view.translatesAutoresizingMaskIntoConstraints = YES;
    /*
    // for background image view
    
    // width
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundProfileImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    
    // height
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundProfileImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.3 constant:0.0]];
    
    */
    
    // mid y for new game button
    
    // [self.view.superview addConstraint:[NSLayoutConstraint constraintWithItem:gameNewButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundProfileImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

@end
