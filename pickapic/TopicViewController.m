//
//  TopicViewController.m
//  pickapic
//
//  Created by Steve Brown on 8/16/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicTableViewCell.h"
#import "OnePhoneInPersonViewController.h"
#import "OPIPGameViewController.h"
#import <Parse/Parse.h>

@interface TopicViewController ()

@end

@implementation TopicViewController

@synthesize tableView, topicsArray, topicChosen, isAddingTopic, alertTextField, fromController, playersArray, scoreArray, roundNumber, categoryKeysUnlocked, topicsDictionaryNM, userTopics;

- (void)viewDidLoad
{
    topicChosen = [[NSString alloc] init];
    
    // back button
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.height *0.65), (self.navigationController.navigationBar.frame.size.height *0.65));
    [backButton setImage:[UIImage imageNamed:@"icn_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icn_back_active"] forState:(UIControlStateSelected | UIControlStateHighlighted)];
    [backButton setSelected:YES];
    
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backItem;
    
    [super viewDidLoad];
    
    // Load topics
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"TopicsList.plist"];
    
    topicsDictionaryNM = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    // initiate topics array with free and custom
    
    NSArray *customArray = [NSArray arrayWithArray:[topicsDictionaryNM objectForKey:@"UserGenerated"]];
    
    
    userTopics = [[NSMutableArray alloc] initWithArray:customArray];
    
    // NSLog(@"custom array: %@\nuser topics array: %@", customArray, userTopics);

    
    if (customArray.count != 0)
    {
        topicsArray = [[NSMutableArray alloc] initWithObjects:[NSArray arrayWithArray:[topicsDictionaryNM objectForKey:@"UserGenerated"]],[NSArray arrayWithArray:[topicsDictionaryNM objectForKey:@"FREE"]], nil];
        
        categoryKeysUnlocked = [[NSMutableArray alloc] initWithObjects:@"Your Topics",@"PickAPic Originals", nil];
    }
    else
    {
        topicsArray = [[NSMutableArray alloc] initWithObjects:[NSArray arrayWithArray:[topicsDictionaryNM objectForKey:@"FREE"]], nil];
        
        categoryKeysUnlocked = [[NSMutableArray alloc] initWithObjects:@"PickAPic Originals", nil];
    }
    
    // NSLog(@"current array: %@", topicsArray);
    
    // add purchased topics to list
    
    
    [self unlockTopicPack:@"Dingleberry"];
    [self unlockTopicPack:@"Goofus"];
    [self unlockTopicPack:@"Greenhorn"];
    [self unlockTopicPack:@"Jabroni"];
    [self unlockTopicPack:@"Knucklehead"];
    [self unlockTopicPack:@"Nitwit"];
    [self unlockTopicPack:@"Screwball"];
    [self unlockTopicPack:@"Sillypants"];
    
    // topicsArray = [NSArray arrayWithArray:[dict objectForKey:@"Root"]];
    
    // NSLog(@"topics array: %@\nFilePath: %@", topicsArray, filePath);
}

- (void)unlockTopicPack:(NSString *)topicPackName
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@Unlocked", topicPackName]])
    {
        [topicsArray addObject:[NSMutableArray arrayWithArray:[topicsDictionaryNM objectForKey:topicPackName]]];
        
        [categoryKeysUnlocked addObject:topicPackName];
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([isAddingTopic isEqual: @"YES"])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create a new topic" message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
         alert.alertViewStyle = UIAlertViewStylePlainTextInput;
         alertTextField = [alert textFieldAtIndex:0];
         alertTextField.keyboardType = UIKeyboardTypeDefault;
         NSLog(@"cancel button index: %ld", (long)[alert cancelButtonIndex]);
         [alert show];
         
    }
    
    self.tableView.allowsSelection = YES;
    
    // remove horrible white space on top of tableview
    
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.automaticallyAdjustsScrollViewInsets = NO;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([fromController isEqualToString:@"Setup"])
    {
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
        topicChosen = selectedCell.textLabel.text;
        
        NSLog(@"topic Chosen2: %@", topicChosen);
        
        // deselect cell on editing
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        // send back to game controller
        
        [self performSegueWithIdentifier:@"fromTopicsToSetup" sender:self];
    }
    else if ([fromController isEqualToString:@"Game"])
    {
        UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
        topicChosen = selectedCell.textLabel.text;
        
        NSLog(@"topic Chosen2: %@", topicChosen);
        
        // deselect cell on editing
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        // send back to game controller
        
        [self performSegueWithIdentifier:@"fromTopicsToGame" sender:self];
    }

}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return categoryKeysUnlocked.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSArray *currentArray = [topicsArray objectAtIndex:section];
    return currentArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,200,300,400)];
    
    // custom view for section title
    tempView.backgroundColor=[UIColor whiteColor];
    
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,300,40)];
    tempLabel.backgroundColor = [UIColor whiteColor];
    tempLabel.shadowOffset = CGSizeMake(0,2);
    tempLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:161.0/255.0 blue:203.0/255.0 alpha:1];
    tempLabel.font = [UIFont fontWithName:@"Lato-Light.ttf" size:18.0];
    tempLabel.font = [UIFont boldSystemFontOfSize:18.0];
    tempLabel.text = categoryKeysUnlocked[section];
    
    [tempView addSubview:tempLabel];
    
    return tempView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"topicCell" forIndexPath:indexPath];
    
    // cell.textField = [[tableView cellForRowAtIndexPath:indexPath] viewWithTag:(indexPath.row)];
    
    cell.textLabel.font = [UIFont fontWithName:@"Lato-Regular" size:18.0];
    cell.textLabel.text = topicsArray[indexPath.section][indexPath.row];
    
    
    // cell.topicLabel.tag  = indexPath.row;
    
    // [self.playerList addObject:@"Placeholder"];
    
    // [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSLog(@"usertopics count: %lu index row: %ld", userTopics.count, (long)indexPath.row);
    
    NSInteger section = [indexPath section];
    
    // Return NO if you do not want the specified item to be editable.
    if (section == 0 && indexPath.row < (userTopics.count))
    {
        // NSLog(@"row %ld is able to be edited\nuser topics count: %ld", (long)indexPath.row, userTopics.count);
        
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"removing %@ at index %ld\n topicsarray count: %lu", userTopics[indexPath.row], indexPath.row, (unsigned long)topicsArray.count);
    
    [userTopics removeObjectAtIndex:indexPath.row];
    
    topicsArray[0] = userTopics;
    
    // file path of dict
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"TopicsList.plist"];
    
    // add new topic within array to dictionary
    
    NSMutableDictionary *mutableDictionary = [topicsDictionaryNM mutableCopy];
    
    [mutableDictionary setObject:userTopics forKey:@"UserGenerated"];
    
    [mutableDictionary writeToFile:filePath atomically:YES];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if (alertTextField.text.length > 32 || alertTextField.text.length == 0)
        {
            // if mis-formatted string, display new alert view with instructions
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter a topic that is between 1 to 32 characters" message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            alertTextField = [alert textFieldAtIndex:0];
            alertTextField.keyboardType = UIKeyboardTypeDefault;
            NSLog(@"cancel button index: %ld", (long)[alert cancelButtonIndex]);
            [alert show];
        }
        else
        {
            // set topic string and topic label
            
            topicChosen = alertTextField.text;
            // topicLabel.text = [NSString stringWithFormat:@"Topic Chosen: %@", alertTextField.text];
            
            // add to master list on parse
            
            PFObject *newTopic = [PFObject objectWithClassName:@"NewTopic"];
            newTopic[@"topicString"] = topicChosen;
            newTopic[@"deviceName"] = [[UIDevice currentDevice] name];
            newTopic[@"userName"] = @"defaultUser";
            [newTopic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"%@\n\nsaved successfully!!",newTopic);
                } else {
                    NSLog(@"%@\n\nnot save successfully!!\n%@", newTopic,error.description);
                }
            }];
            
            // file path of dict
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = paths[0];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"TopicsList.plist"];
            
            // array to add new topic
            
            NSMutableArray *quickCustomArray = [[NSMutableArray alloc] initWithArray:[topicsDictionaryNM objectForKey:@"UserGenerated"]];
            

            [quickCustomArray insertObject:topicChosen atIndex:0];
            
            
            // NSLog(@"quick array: %@", quickCustomArray);
            
            // add new topic within array to dictionary
            
            NSMutableDictionary *mutableDictionary = [topicsDictionaryNM mutableCopy];
            
            [mutableDictionary setObject:quickCustomArray forKey:@"UserGenerated"];
            
            [mutableDictionary writeToFile:filePath atomically:YES];
            
            // add topic to temporary topicsarray for use in tableview
            
            NSLog(@"topics array before: %@", topicsArray[0]);
            
            [topicsArray replaceObjectAtIndex:0 withObject:quickCustomArray];
            
            NSLog(@"inserting %@ into topics array %@", topicChosen, topicsArray);
            
            [self.tableView reloadData];
            
            self.tableView.allowsSelection = NO;
            
            [NSTimer scheduledTimerWithTimeInterval:0.75
                                             target:self
                                           selector:@selector(changeView)
                                           userInfo:nil
                                            repeats:NO];
        }
    }
}

- (void)changeView
{
    NSLog(@"Topic chosen before segue: %@", topicChosen);
    
    if ([fromController isEqualToString:@"Setup"])
    {
        [self performSegueWithIdentifier:@"fromTopicsToSetup" sender:self];
    }
    else if ([fromController isEqualToString:@"Game"])
    {
        [self performSegueWithIdentifier:@"fromTopicsToGame" sender:self];
    }
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"fromTopicsToSetup"])
    {
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        OnePhoneInPersonViewController *opipController = [navController topViewController];
        
        opipController.topicChosen = self.topicChosen;
        
        opipController.playerList = self.playersArray;
        
        /* TODO: put this in final version
        OnePhoneInPersonViewController *divc = (OnePhoneInPersonViewController *)[segue destinationViewController];
        
        divc.topicChosen = self.topicChosen;
        NSLog(@"Topic Chosen from Topics Window: %@", topicChosen);
        
        divc.playerList = self.playersArray;
         */
    }
    else if([segue.identifier isEqualToString:@"fromTopicsToGame"])
    {
        OPIPGameViewController *divc = (OPIPGameViewController *)[segue destinationViewController];
        
        divc.topicChosen = topicChosen;
        NSLog(@"Topic Chosen from Topics Window: %@", topicChosen);
        
        divc.playersArray = playersArray;
        divc.playerScores = scoreArray;
        
        divc.roundNumber = roundNumber;
        
        divc.photoChosen = NO;
    }

}

@end
