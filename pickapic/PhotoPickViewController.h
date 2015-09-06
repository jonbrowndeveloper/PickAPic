//
//  PhotoPickViewController.h
//  pickapic
//
//  Created by Steve Brown on 9/3/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPickViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *facebookLabel;
@property (weak, nonatomic) IBOutlet UIButton *cameraLabel;
@property (weak, nonatomic) IBOutlet UIButton *instagramButton;

- (IBAction)getInstagramPhoto:(id)sender;
- (IBAction)getCameraRollPhoto:(id)sender;
- (IBAction)getFacebookPhoto:(id)sender;

@property (assign, atomic) int timerValue;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (strong, nonatomic) NSMutableArray *playersArray;
@property (strong, nonatomic) NSMutableArray *scoreArray;

@property (nonatomic, assign) NSNumber *roundNumber;
@property (strong, atomic) NSString *topicChosen;
@property (nonatomic, weak) UIImage *image;

@property (nonatomic, weak) NSTimer *timer; 



@end
