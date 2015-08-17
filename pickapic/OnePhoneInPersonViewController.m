//
//  OnePhoneInPersonViewController.m
//  pickapic
//
//  Created by Steve Brown on 8/12/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import "OnePhoneInPersonViewController.h"
#import "OnePhonePlayerListTableViewCell.h"

@interface OnePhoneInPersonViewController ()

@end

@implementation OnePhoneInPersonViewController

@synthesize playerList, tableView, beginGameButtonOutlet, topicLabel, topicChosen, alertTextField;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // topicChosen = @" ";
    
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
    topicLabel.text = [NSString stringWithFormat:@"Topic Chosen: %@", topicChosen];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OnePhonePlayerListTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"playerCell" forIndexPath:indexPath];

    // cell.textField = [[tableView cellForRowAtIndexPath:indexPath] viewWithTag:(indexPath.row)];
    
    // cell.textField.text = @"test";
    cell.textField.delegate = self;
    cell.textField.tag  = indexPath.row;
    
    [self.playerList addObject:@"Placeholder"];
    
    // [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
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
    
}
- (IBAction)addTopic:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create a new topic" message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    NSLog(@"cancel button index: %ld", (long)[alert cancelButtonIndex]);
    [alert show];
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
            topicLabel.text = [NSString stringWithFormat:@"Topic Chosen: %@", alertTextField.text];
            
            // add to master list
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TopicsList" ofType:@"plist"];
            NSArray *topicsArray = [[NSArray alloc] initWithContentsOfFile:filePath];
            
            NSMutableArray *topicsArrayMut = [NSMutableArray arrayWithArray:topicsArray];
            
            [topicsArrayMut addObject:alertTextField.text];
            NSLog(@"topics array: %@", topicsArrayMut);
            
            [topicsArrayMut writeToFile:filePath atomically:YES];
        }
    }
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
    topicLabel.text = [NSString stringWithFormat:@"Topic Chosen: RANDOM :D"];
}
@end
