//
//  OPIPGameViewController.m
//  pickapic
//
//  Created by Steve Brown on 8/18/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import "OPIPGameViewController.h"

@interface OPIPGameViewController ()

@end

@implementation OPIPGameViewController

@synthesize topicLabel, playersArray, timer, timerValue = _timerValue, countdownLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startCountdown:self];
}

- (void)startCountdown:(id)sender
{
    _timerValue = 60;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(advanceTimer:) userInfo:nil repeats:NO];
}

- (void)advanceTimer:(NSTimer *)timer
{
    --_timerValue;
    if(self.timerValue != 0)
    {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(advanceTimer:) userInfo:nil repeats:NO];
        countdownLabel.text = [NSString stringWithFormat:@"%d", _timerValue];
    }
    
    if (self.timerValue == 0)
    {
        countdownLabel.text = [NSString stringWithFormat:@"%d", _timerValue];
        
        // do something like say the round is over, choose a winner
    }
    
}


@end
