//
//  TopicViewController.h
//  pickapic
//
//  Created by Steve Brown on 8/16/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, atomic) NSArray *topicsArray;
@property (weak, nonatomic) NSString *topicChosen;

@end
