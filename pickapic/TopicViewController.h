//
//  TopicViewController.h
//  pickapic
//
//  Created by Steve Brown on 8/16/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, atomic) NSMutableArray *topicsArray;
@property (strong, atomic) NSString *topicChosen;
@property (strong, nonatomic) NSString *fromController;

@property (strong, nonatomic) NSMutableArray *playersArray;
@property (strong, nonatomic) NSMutableArray *scoreArray;

// Adding Topic

@property (strong, nonatomic) NSString *isAddingTopic;
@property (nonatomic, retain) UITextField *alertTextField;

@property (nonatomic, assign) NSNumber *roundNumber;

@end
