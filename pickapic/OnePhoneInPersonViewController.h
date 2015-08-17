//
//  OnePhoneInPersonViewController.h
//  pickapic
//
//  Created by Steve Brown on 8/12/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnePhoneInPersonViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (atomic, retain) NSMutableArray *playerList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// begin game

- (IBAction)beginGame:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *beginGameButtonOutlet;

// add topic

- (IBAction)addTopic:(id)sender;
@property (nonatomic, retain) UITextField *alertTextField;

// random topic

@property (weak, nonatomic) IBOutlet UIButton *randomButton;
- (IBAction)randomTopic:(id)sender;

// topic data

@property (strong, atomic) NSString *topicChosen;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;

@end
