//
//  OnePhoneInPersonViewController.m
//  pickapic
//
//  Created by Steve Brown on 8/12/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import "OnePhoneInPersonViewController.h"
#import "OnePhonePlayerListTableViewCell.h"
#import "TopicViewController.h"
#import "OPIPGameViewController.h"

@interface OnePhoneInPersonViewController ()

@end

@implementation OnePhoneInPersonViewController

@synthesize playerList, tableView, beginGameButtonOutlet, topicLabel, topicChosen, cell, tapper, settingsButton;

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (playerList == nil)
    {
        playerList = [[NSMutableArray alloc] initWithObjects:(@""),(@""),(@""), nil];
    }
    
    topicLabel.textColor = [UIColor grayColor];
    topicLabel.text = @"select an option from below";
    
    // New Game button
    
    CALayer *btnLayer = [beginGameButtonOutlet layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setBorderWidth:2.0f];
    [btnLayer setBorderColor:[UIColor colorWithRed:57.0/255.0 green:181.0/255.0 blue:74.0/255.0 alpha:1].CGColor];
    [btnLayer setBackgroundColor:[UIColor colorWithRed:75.0/255.0 green:142.0/255.0 blue:16.0/255.0 alpha:1].CGColor];
    [btnLayer setCornerRadius:8.0f];
    
    // create some text for the button with the finger image
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"  Begin Game"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString length])];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"icn_button_newgame_small.png"];
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:attrStringWithImage];
    
    [self.beginGameButtonOutlet setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    // back button
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.height *0.65), (self.navigationController.navigationBar.frame.size.height *0.65));
    backButton.hidden = YES;
    [backButton setImage:[UIImage imageNamed:@"icn_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icn_back_active"] forState:(UIControlStateSelected | UIControlStateHighlighted)];
    [backButton setSelected:YES];
    
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backItem;
    
    // gesure recognizer for dismissing keybaord if another part of the screen is touched
    
    tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
    // set 'Pick A Pic' logo on navigation bar
    
    UIImage *logo = [UIImage imageNamed:@"icn_logo.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:logo];
    imgView.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.width * 0.75), (self.navigationController.navigationBar.frame.size.height * 0.75));
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imgView;
    
    // navbar color
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:201.0/255.0 alpha:1]];
    
    // settings button
    
    settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.height *0.65), (self.navigationController.navigationBar.frame.size.height *0.65));
    [settingsButton setImage:[UIImage imageNamed:@"icn_settings"] forState:UIControlStateNormal];
    [settingsButton setImage:[UIImage imageNamed:@"icn_settings_active"] forState:(UIControlStateSelected | UIControlStateHighlighted)];
    [settingsButton setSelected:YES];
    
    [settingsButton addTarget:self action:@selector(activateSettingsSegue) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settingsItem, nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    /* TODO: USE IN FINAL VERSION
    // to make sure the 'TopicViewConroller' is not in the view controller hierarchy
    
    NSArray * viewControllers = [self.navigationController viewControllers];
    NSArray * newViewControllers = [NSArray arrayWithObjects:[viewControllers objectAtIndex:0], [viewControllers objectAtIndex:1], self,nil];
    [self.navigationController setViewControllers:newViewControllers];
    */
    // to make sure the 'TopicViewConroller' is not in the view controller hierarchy
    
    NSArray * newViewControllers = [NSArray arrayWithObjects:self,nil];
    [self.navigationController setViewControllers:newViewControllers];
    
    // set the Topic Label
    
    if(!([topicChosen length] == 0))
    {
        topicLabel.text = [NSString stringWithFormat:@"%@", topicChosen];
        
        topicLabel.textColor = [UIColor blackColor];
    }
    
    NSLog(@"players list: %@", playerList);
}

- (void)activateSettingsSegue
{
    [self performSegueWithIdentifier:@"segueToSettings" sender:self];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma tablview methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return playerList.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (playerList.count == 3)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [playerList removeObjectAtIndex:indexPath.row];
    
    [self.tableView reloadData];
}

- (OnePhonePlayerListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     cell = [self.tableView dequeueReusableCellWithIdentifier:@"playerCell" forIndexPath:indexPath];

    // cell.textField = [[tableView cellForRowAtIndexPath:indexPath] viewWithTag:(indexPath.row)];
    
    // cell.textField.text = @"test";
    cell.textField.delegate = self;
    cell.textField.tag  = indexPath.row;
    
    cell.textField.text = playerList[indexPath.row];
    
    if (indexPath.row == 0)
    {
        cell.textField.placeholder = @"tap to enter host's name";
    }
    
    // [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // returning current index path
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(OnePhonePlayerListTableViewCell *)[[textField superview] superview]];
    
    playerList[indexPath.row] = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    // resigning first responder does not work. THIS WORKS!
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)beginGame:(id)sender
{
    NSLog(@"Begin Game Button Pressed. Topic is: %@", topicChosen);
    
    // check the strings in the array to make sure they aren't blank
    
    BOOL stringIsEmpty = NO;
    
    for (NSString *string in playerList)
    {
        if ([string length] == 0)
        {
            // trip the bool that there is a string that is empty
            stringIsEmpty = YES;
        }

    }
    
    if (!(playerList.count == 0) && !([topicChosen length] == 0) && stringIsEmpty == NO)
    {
        [self performSegueWithIdentifier:@"toGame" sender:self];
        
        NSLog(@"the game is starting");
    }
    else if (playerList.count == 0)
    {
        NSLog(@"NO PLAYERS IN LIST");
        
    }
    else if (([topicChosen length] == 0))
    {
        NSLog(@"NO TOPIC CHOSEN");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please choose a topic" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
        alert.alertViewStyle = UIAlertActionStyleDefault;
        [alert show];
    }
    else if (stringIsEmpty == YES)
    {
        NSLog(@"there is an empty string in the players array");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Minimum of 3 players needed to begin game" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
        alert.alertViewStyle = UIAlertActionStyleDefault;
        [alert show];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // send category name to bucket collection view
    if([segue.identifier isEqualToString:@"addingTopic"])
    {
        TopicViewController *divc = (TopicViewController *)[segue destinationViewController];

        divc.isAddingTopic = @"YES";
        divc.fromController = @"Setup";
        
        divc.playersArray = playerList;
    }
    else if ([segue.identifier isEqualToString:@"pickingTopic"])
    {
        TopicViewController *divc = (TopicViewController *)[segue destinationViewController];
        
        divc.isAddingTopic = @"NO";
        divc.fromController = @"Setup";
        
        divc.playersArray = playerList;
    }
    else if ([segue.identifier isEqualToString:@"toGame"])
    {
        OPIPGameViewController *divc = (OPIPGameViewController *)[segue destinationViewController];
        
        NSLog(@"going to game. Topic Chosen: %@", topicChosen);
        
        divc.topicChosen = topicChosen;
        divc.playersArray = playerList;
    }
}

- (IBAction)addPlayer:(id)sender
{
    [playerList addObject:[NSString stringWithFormat:@""]];
    
    [self.tableView reloadData];
}

- (IBAction)addTopic:(id)sender
{
    // [self performSegueWithIdentifier:@"toTopicsFromOPIP" sender:self];
    
}

- (IBAction)randomTopic:(id)sender
{
    topicLabel.textColor = [UIColor blackColor];
    
    // get current topic list from file system
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TopicsList" ofType:@"plist"];
    NSArray *topicsArray = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    // generate random value from 0 to size of topics list
    
    int lowerBound = 0;
    int upperBound = (int)topicsArray.count;
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    
    NSLog(@"random number is: %d", rndValue);
    
    // set topics label and topic string
    
    topicChosen = topicsArray[rndValue];
    topicLabel.text = [NSString stringWithFormat:@"%@", topicChosen];
    
    
}

@end
