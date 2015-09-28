//
//  OPIPGameViewController.h
//  pickapic
//
//  Created by Steve Brown on 8/18/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPIPTableViewCell.h"
#import <AudioToolbox/AudioToolbox.h>

@interface OPIPGameViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSString *topicChosen;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (strong, atomic) NSMutableArray *playersArray;
@property (strong, atomic) NSMutableArray *playerScores;
@property (strong, atomic) NSMutableArray *winners;

@property (assign, atomic) int timerValue;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (strong, atomic) IBOutlet UITableView *gameTableView;

@property (strong, atomic) OPIPTableViewCell *cell;
@property (strong, nonatomic) NSString *currentJudge;
@property (nonatomic, assign) NSNumber *roundNumber;
@property (nonatomic, assign) NSNumber *actualRoundNumber;
@property (nonatomic, assign) BOOL hasAddedPoint;
@property (nonatomic, assign) BOOL timerHasReachedZero;
@property (nonatomic, assign) BOOL gameOver;
@property (nonatomic, assign) BOOL pressedBackButton;
@property (nonatomic, assign) BOOL shouldAddToRoundNumber;
@property (nonatomic, assign) BOOL isRounds;



@property (weak, nonatomic) IBOutlet UILabel *roundLabel;

// settings button

@property (nonatomic, retain) UIButton *settingsButton;

// bottom buttons

@property (strong, nonatomic) IBOutlet UIButton *nTopicButton;
- (IBAction)nTopicAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *shareButton;
- (IBAction)shareAction:(id)sender;

// topic buttons
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *pickTopicButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *addTopicButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *randomTopicButton;

- (IBAction)randomTopic:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

// gray popover screen

@property (weak, nonatomic) IBOutlet UIView *grayScreenView;

@property (nonatomic, assign) BOOL photoChosen;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *smallPhotoImageView;
@property (nonatomic, weak) UIImage *image;

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *bigPhotoImageView;

@property (nonatomic, assign) BOOL hostNeedsToPic;
@property (nonatomic, assign) BOOL hosthasPickedAPic;

@end
