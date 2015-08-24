//
//  OPIPGameViewController.h
//  pickapic
//
//  Created by Steve Brown on 8/18/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPIPGameViewController : UIViewController

@property (strong, nonatomic) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (strong, atomic) NSArray *playersArray;

@property (assign, atomic) int timerValue;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;

@end
