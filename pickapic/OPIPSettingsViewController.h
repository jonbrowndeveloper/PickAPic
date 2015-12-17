//
//  OPIPSettingsViewController.h
//  pickapic
//
//  Created by Steve Brown on 8/30/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPIPSettingsViewController : UIViewController

- (IBAction)timerControl:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *timerControlOutlet;

- (IBAction)gameTypeControl:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeControlOutlet;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gamePromptsSegmentedControl;
- (IBAction)gamePromptsControl:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
- (IBAction)numberStepper:(id)sender;
@property (weak, nonatomic) IBOutlet UIStepper *numberStepperOutlet;

@property (nonatomic, assign) int gameTypeNumber;


@end
