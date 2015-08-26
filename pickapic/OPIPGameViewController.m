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

@synthesize topicLabel, playersArray = _playersArray, timer, timerValue = _timerValue, countdownLabel, topicChosen, nTopicButton, shareButton, cell = _cell, playerScores, currentJudge, roundNumber, hasAddedPoint = _hasAddedPoint;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _hasAddedPoint = NO;
    
    NSLog(@"round: %ld", (long)roundNumber);
    
    // initialize player scores
    
    playerScores = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _playersArray.count; i++)
    {
        [playerScores addObject:[NSString stringWithFormat:@"0"]];
    }
    
    if (roundNumber == NULL) {
        roundNumber = [NSNumber numberWithInt:1];
    }
    
    // set topic label
    
    NSLog(@"topic chosen: %@", topicChosen);
    
    topicLabel.text = topicChosen;
    
    // begin countdown
    
    [self startCountdown:self];
    
    // set button colors and frames
    
    CALayer *btnLayer = [nTopicButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setBorderWidth:2.0f];
    [btnLayer setBorderColor:[UIColor colorWithRed:57.0/255.0 green:181.0/255.0 blue:74.0/255.0 alpha:1].CGColor];
    [btnLayer setBackgroundColor:[UIColor colorWithRed:75.0/255.0 green:142.0/255.0 blue:16.0/255.0 alpha:1].CGColor];
    [btnLayer setCornerRadius:8.0f];
    
    CALayer *btnLayer2 = [shareButton layer];
    [btnLayer2 setMasksToBounds:YES];
    [btnLayer2 setBorderWidth:2.0f];
    [btnLayer2 setBorderColor:[UIColor colorWithRed:57.0/255.0 green:181.0/255.0 blue:74.0/255.0 alpha:1].CGColor];
    [btnLayer2 setBackgroundColor:[UIColor colorWithRed:75.0/255.0 green:142.0/255.0 blue:16.0/255.0 alpha:1].CGColor];
    [btnLayer2 setCornerRadius:8.0f];
}

- (void)startCountdown:(id)sender
{
    _timerValue = 11;
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
        countdownLabel.text = [NSString stringWithFormat:@"0"];
        
        // do something like say the round is over, choose a winner
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
}

#pragma tableview methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _playersArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (_playersArray.count == 3)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_playersArray removeObjectAtIndex:indexPath.row];
    
    [self.gameTableView reloadData];
}

- (UITableView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = [self.gameTableView dequeueReusableCellWithIdentifier:@"opipCell" forIndexPath:indexPath];
    
    _cell.playerNameLabel.text  = _playersArray[indexPath.row];
    _cell.addPointButton.tag = indexPath.row;
    _cell.subtractPointButton.tag = 10000 + indexPath.row;
    _cell.scoreLabel.text = playerScores[indexPath.row];
    
    if (indexPath.row  == (roundNumber.integerValue -1))
    {
        _cell.playerProfileImageView.image = [UIImage imageNamed:@"icn_profile_game"];
        
        _cell.addPointButton.hidden = YES;
        _cell.subtractPointButton.hidden = YES;
    }
    
    // NSLog(@"player score at index %ld is %@", (long)indexPath.row, playerScores[indexPath.row]);
    
    [_cell.addPointButton addTarget:self action:@selector(addPointToScore:) forControlEvents:UIControlEventTouchUpInside];
    [_cell.subtractPointButton addTarget:self action:@selector(subtractPointFromScore:) forControlEvents:UIControlEventTouchUpInside];
    
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.gameTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)addPointToScore:(UIButton *)sender
{
    // increase score by 1
    if (_hasAddedPoint == NO)
    {
        NSString *maximumNumberOfBuckets = [playerScores objectAtIndex:(sender.tag)];
        long i = maximumNumberOfBuckets.integerValue + 1;
        NSString *newPlayerScore = [NSString stringWithFormat:@"%ld", i];
        
        [playerScores replaceObjectAtIndex:(sender.tag) withObject:newPlayerScore];
        
        [self.gameTableView reloadData];
        
        _hasAddedPoint = YES;
    }

}

- (void)subtractPointFromScore:(UIButton *)sender
{
    
    NSString *maximumNumberOfBuckets = [playerScores objectAtIndex:(sender.tag - 10000)];
    long i = maximumNumberOfBuckets.integerValue - 1;
    
    if (i >= 0)
    {
        // decrease score by 1

        NSString *newPlayerScore = [NSString stringWithFormat:@"%ld", i];
        
        [playerScores replaceObjectAtIndex:(sender.tag - 10000) withObject:newPlayerScore];
        
        _hasAddedPoint = NO;
    }
    
    
    
    [self.gameTableView reloadData];
}


- (IBAction)shareAction:(id)sender
{
    NSString *textToShare = @"Lets play PickAPic!";
    NSURL *myWebsite = [NSURL URLWithString:@"AppStoreLink"];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];


}
- (IBAction)nTopicAction:(id)sender {
}
@end