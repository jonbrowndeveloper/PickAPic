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

@synthesize playerList, tableView, beginGameButtonOutlet, topicLabel, topicChosen, cell, tapper;

- (void)viewDidLoad
{
    [super viewDidLoad];

    playerList = [[NSMutableArray alloc] initWithObjects:(@""),(@""),(@""), nil];
    
    
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
}

- (void)viewWillAppear:(BOOL)animated
{
    // to make sure the 'TopicViewConroller' is not in the view controller hierarchy
    
    NSArray * viewControllers = [self.navigationController viewControllers];
    NSArray * newViewControllers = [NSArray arrayWithObjects:[viewControllers objectAtIndex:0], [viewControllers objectAtIndex:1], self,nil];
    [self.navigationController setViewControllers:newViewControllers];
    
    // set the Topic Label
    
    if(!([topicChosen length] == 0))
    {
        topicLabel.text = [NSString stringWithFormat:@"%@", topicChosen];
    }
    
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

- (UITableView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     cell = [self.tableView dequeueReusableCellWithIdentifier:@"playerCell" forIndexPath:indexPath];

    // cell.textField = [[tableView cellForRowAtIndexPath:indexPath] viewWithTag:(indexPath.row)];
    
    // cell.textField.text = @"test";
    cell.textField.delegate = self;
    cell.textField.tag  = indexPath.row;
    
    cell.textField.text = playerList[indexPath.row];
    
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
    NSLog(@"Begin Game Button Pressed");
    
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
    }
    else if (stringIsEmpty == YES)
    {
        NSLog(@"there is an empty string in the players array");
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // send category name to bucket collection view
    if([segue.identifier isEqualToString:@"addingTopic"])
    {
        TopicViewController *divc = (TopicViewController *)[segue destinationViewController];

        divc.isAddingTopic = @"YES";
    }
    else if ([segue.identifier isEqualToString:@"pickingTopic"])
    {
        TopicViewController *divc = (TopicViewController *)[segue destinationViewController];
        
        divc.isAddingTopic = @"NO";
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
