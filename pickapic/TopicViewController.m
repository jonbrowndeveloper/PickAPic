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

@interface TopicViewController ()

@end

@implementation TopicViewController

@synthesize tableView, topicsArray, topicChosen;

- (void)viewDidLoad
{
    
    
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
    topicsArray = [[NSArray alloc] initWithContentsOfFile:filePath];
    // topicsArray = [NSArray arrayWithArray:[dict objectForKey:@"Root"]];
    
    // NSLog(@"topics array: %@\nFilePath: %@", topicsArray, filePath);
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    topicChosen = selectedCell.textLabel.text;
    
    NSLog(@"topic Chosen2: %@", topicChosen);
    
    // deselect cell on editing
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // send back to game controller
    
    [self performSegueWithIdentifier:@"fromTopics" sender:self];
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

- (UITableView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    OnePhoneInPersonViewController *divc = (OnePhoneInPersonViewController *)[segue destinationViewController];
    /*
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"Selected Index Path: %ld", (long)selectedIndexPath.row);
    NSLog(@"Topic Chosen From topicview: %@", [topicsArray objectAtIndex:selectedIndexPath.row]);
    */
    divc.topicChosen = topicChosen;
    NSLog(@"Topic Chosen3: %@", topicChosen);
    // divc.topicLabel.text = [NSString stringWithFormat:@"Topic Chosen: %@", [topicsArray objectAtIndex:selectedIndexPath.row]];
}


@end
