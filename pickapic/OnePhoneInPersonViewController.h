//
//  OnePhoneInPersonViewController.h
//  pickapic
//
//  Created by Steve Brown on 8/12/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnePhonePlayerListTableViewCell.h"

@interface OnePhoneInPersonViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

// players

- (IBAction)addPlayer:(id)sender;

@property (strong, nonatomic) NSMutableArray *playerList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// attempt to make the cell be visible when textfield is active

@property (nonatomic, retain) IBOutlet UITextField *actifText;
// tableview methods

- (IBAction)textFieldDidBeginEditing:(UITextField *)textField;
- (IBAction)textFieldDidEndEditing:(UITextField *)textField;

-(void) keyboardWillHide:(NSNotification *)note;
-(void) keyboardWillShow:(NSNotification *)note;

@property (nonatomic, assign) CGRect origTVFrame;

// begin game

- (IBAction)beginGame:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *beginGameButtonOutlet;

// add topic

- (IBAction)addTopic:(id)sender;

// random topic

@property (weak, nonatomic) IBOutlet UIButton *randomButton;
- (IBAction)randomTopic:(id)sender;

// topic data

@property (strong, nonatomic) NSString *topicChosen;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;

// custom cell

@property (weak, nonatomic) OnePhonePlayerListTableViewCell *cell;
@property (strong, atomic) UIGestureRecognizer *tapper;

@property (nonatomic, retain) UIButton *settingsButton;

// labels and button for hiding when cell is selected
@property (weak, nonatomic) IBOutlet UIButton *addPlayerButton;
@property (weak, nonatomic) IBOutlet UILabel *playersLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeMinLabel;


@end
