//
//  OnePhoneInPersonViewController.h
//  pickapic
//
//  Created by Steve Brown on 8/12/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnePhoneInPersonViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (atomic, retain) NSMutableArray *playerList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)beginGame:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *beginGameButtonOutlet;


@end
