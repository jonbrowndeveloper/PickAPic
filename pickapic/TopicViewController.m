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

@synthesize tableView, topicsArray, topicChosen, isAddingTopic, alertTextField, fromController, playersArray, scoreArray, roundNumber;

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
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TopicsList" ofType:@"plist"];
    NSArray *topicsArrayNM = [[NSArray alloc] initWithContentsOfFile:filePath];
    topicsArray = [NSMutableArray arrayWithArray:topicsArrayNM];
    
    // topicsArray = [NSArray arrayWithArray:[dict objectForKey:@"Root"]];
    
    // NSLog(@"topics array: %@\nFilePath: %@", topicsArray, filePath);
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return topicsArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"topicCell" forIndexPath:indexPath];
    
    // cell.textField = [[tableView cellForRowAtIndexPath:indexPath] viewWithTag:(indexPath.row)];
    
    cell.textLabel.font = [UIFont fontWithName:@"Lato-Regular" size:22.0];
    cell.textLabel.text = topicsArray[indexPath.row];
    
    
    // cell.topicLabel.tag  = indexPath.row;
    
    // [self.playerList addObject:@"Placeholder"];
    
    // [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
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
        if (alertTextField.text.length > 25 || alertTextField.text.length == 0)
        {
            // if mis-formatted string, display new alert view with instructions
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter a topic that is between 1 to 25 characters" message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
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
            
            // add to master list
            
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
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TopicsList" ofType:@"plist"];

            [topicsArray insertObject:alertTextField.text atIndex:0];
            // NSLog(@"topics array: %@", topicsArray);
            
            [topicsArray writeToFile:filePath atomically:YES];
            
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
