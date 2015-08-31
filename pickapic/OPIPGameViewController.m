//
//  OPIPGameViewController.m
//  pickapic
//
//  Created by Steve Brown on 8/18/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import "OPIPGameViewController.h"
#import "TopicViewController.h"

@interface OPIPGameViewController ()

@end

@implementation OPIPGameViewController

@synthesize topicLabel, playersArray = _playersArray, timer, timerValue = _timerValue, countdownLabel, topicChosen, nTopicButton, shareButton, cell = _cell, playerScores, currentJudge, roundNumber, hasAddedPoint = _hasAddedPoint, addTopicButton, pickTopicButton, randomTopicButton, roundLabel, timerHasReachedZero = _timerHasReachedZero;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"round: %ld", (long)roundNumber);
    
    // initialize player scores
    if (playerScores == nil)
    {
        playerScores = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < _playersArray.count; i++)
        {
            [playerScores addObject:[NSString stringWithFormat:@"0"]];
        }
    }
    
    if (roundNumber == nil) {
        roundNumber = [NSNumber numberWithInt:1];
    }
    
    roundLabel.text = [NSString stringWithFormat:@"ROUND %d", roundNumber.intValue];
    
    // set topic label
    
    NSLog(@"topic chosen: %@", topicChosen);
    
    topicLabel.text = topicChosen;
    
    [self startGame];
    
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
    
    // back button
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.height *0.65), (self.navigationController.navigationBar.frame.size.height *0.65));
    [backButton setImage:[UIImage imageNamed:@"icn_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icn_back_active"] forState:(UIControlStateSelected | UIControlStateHighlighted)];
    [backButton setSelected:YES];
    
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    /* TODO: USE IN FINAL VERSION
     // to make sure the 'TopicViewConroller' is not in the view controller hierarchy
     
     NSArray * viewControllers = [self.navigationController viewControllers];
     NSArray * newViewControllers = [NSArray arrayWithObjects:[viewControllers objectAtIndex:0],[viewControllers objectAtIndex:0],[viewControllers objectAtIndex:1], [viewControllers objectAtIndex:2], self,nil];
     [self.navigationController setViewControllers:newViewControllers];
     */
    // to make sure the 'TopicViewConroller' is not in the view controller hierarchy
    
    NSArray * viewControllers = [self.navigationController viewControllers];
    NSArray * newViewControllers = [NSArray arrayWithObjects:[viewControllers objectAtIndex:0], self,nil];
    [self.navigationController setViewControllers:newViewControllers];
    
    if (![topicChosen isEqualToString:@"placeholder"])
    {
        topicLabel.text = topicChosen;
    }
    
    // roundLabel.text = roundNumber.stringValue;
    
    [self.gameTableView reloadData];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startCountdown:(id)sender
{
    countdownLabel.text = @"";
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(advanceTimer:) userInfo:nil repeats:NO];
}

- (void)advanceTimer:(NSTimer *)timer
{
    --_timerValue;
    if(self.timerValue != 0 && _hasAddedPoint == NO)
    {
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(advanceTimer:) userInfo:nil repeats:NO];
        countdownLabel.text = [NSString stringWithFormat:@"%d", _timerValue];
    }
    
    if (self.timerValue == 0)
    {
        
        countdownLabel.text = [NSString stringWithFormat:@"0"];
        
        // do something like say the round is over, choose a winner
        
        // possible buzzer
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        _timerHasReachedZero = YES;
        
        // [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fadeCountdownOut) userInfo:nil repeats:NO];
    }
    
}

- (void)fadeCountdownOut
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.15;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];
    countdownLabel.hidden = YES;
    // randomTopicButton.hidden = NO;
}

- (void)fadeOutNewTopicButton
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.15;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];
    nTopicButton.alpha = 0.4;
}

- (void)fadeInNewTopicButton
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.15;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];
    nTopicButton.alpha = 1.0;

}

- (void)fadeInTopicButtons
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.15;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];
    
    // hide and unhide buttons
    
    addTopicButton.hidden = NO;
    pickTopicButton.hidden = NO;
    randomTopicButton.hidden = NO;
    
    countdownLabel.hidden = YES;
    
    nTopicButton.alpha = 0.4;
    nTopicButton.enabled = NO;
}

- (void)fadeOutTopicButtons
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.15;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];
    
    addTopicButton.hidden = YES;
    pickTopicButton.hidden = YES;
    randomTopicButton.hidden = YES;
    
    countdownLabel.hidden = NO;
    
    nTopicButton.alpha = 0.4;
    nTopicButton.enabled = NO;
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

- (OPIPTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cell = [self.gameTableView dequeueReusableCellWithIdentifier:@"opipCell" forIndexPath:indexPath];
    
    _cell.playerNameLabel.text  = _playersArray[indexPath.row];
    _cell.addPointButton.tag = indexPath.row;
    _cell.subtractPointButton.tag = 10000 + indexPath.row;
    _cell.scoreLabel.text = playerScores[indexPath.row];
    
    if (indexPath.row  == ((roundNumber.integerValue -1)%_playersArray.count))
    {
        _cell.playerProfileImageView.image = [UIImage imageNamed:@"icn_profile_game"];
        
        _cell.addPointButton.hidden = YES;
        _cell.subtractPointButton.hidden = YES;
    }
    else if (indexPath.row == ((roundNumber.integerValue -2)%_playersArray.count))
    {
        _cell.playerProfileImageView.image = nil;
        
        _cell.addPointButton.hidden = NO;
        _cell.subtractPointButton.hidden = NO;
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
        NSString *playerScore = [playerScores objectAtIndex:(sender.tag)];
        long i = playerScore.integerValue + 1;
        NSString *newPlayerScore = [NSString stringWithFormat:@"%ld", i];
        
        [playerScores replaceObjectAtIndex:(sender.tag) withObject:newPlayerScore];
        
        [self.gameTableView reloadData];
        
        _hasAddedPoint = YES;
        
        [self fadeInNewTopicButton];
        nTopicButton.enabled = YES;
    }

}

- (void)subtractPointFromScore:(UIButton *)sender
{
    
    NSString *playerScore = [playerScores objectAtIndex:(sender.tag - 10000)];
    long i = playerScore.integerValue - 1;
    
    if (i >= 0)
    {
        // decrease score by 1

        NSString *newPlayerScore = [NSString stringWithFormat:@"%ld", i];
        
        [playerScores replaceObjectAtIndex:(sender.tag - 10000) withObject:newPlayerScore];
        
        _hasAddedPoint = NO;
        
        [self fadeOutNewTopicButton];
        nTopicButton.enabled = NO;
        
        if (_timerHasReachedZero != YES)
        {
            _timerValue++;
            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(advanceTimer:) userInfo:nil repeats:NO];
        }
        
    }
    
    
    
    [self.gameTableView reloadData];
}


- (IBAction)shareAction:(id)sender
{
    NSString *textToShare = @"Lets play PickAPic!";
    NSURL *myWebsite = [NSURL URLWithString:@"\n\nAppStoreLink"];
    
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


- (IBAction)nTopicAction:(id)sender
{
    if (_hasAddedPoint == YES)
    {
        [self fadeInTopicButtons];
        
        // set topic label
        
        topicLabel.text = @"Choose Topic";
        
        _hasAddedPoint = NO;
        
        // increment round number by 1
        
        int value = [roundNumber intValue];
        roundNumber = [NSNumber numberWithInt:value + 1];
        
        roundLabel.text = [NSString stringWithFormat:@"ROUND %d", roundNumber.intValue];
        
        _timerValue = (int)[[NSUserDefaults standardUserDefaults] doubleForKey:@"gameTimer"] + 1;
        
        _timerHasReachedZero = NO;
        
        [self.gameTableView reloadData];
        
    }
    else
    {
        NSLog(@"Give someone a point first!");
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    topicChosen = @"placeholder";
    
    // send category name to bucket collection view
    if([segue.identifier isEqualToString:@"addingTopic"])
    {
        TopicViewController *divc = (TopicViewController *)[segue destinationViewController];
        
        divc.isAddingTopic = @"YES";
        divc.fromController = @"Game";
        
        divc.playersArray = _playersArray;
        divc.scoreArray = playerScores;
        
        divc.roundNumber = roundNumber;
    }
    else if ([segue.identifier isEqualToString:@"pickingTopic"])
    {
        TopicViewController *divc = (TopicViewController *)[segue destinationViewController];
        
        divc.isAddingTopic = @"NO";
        divc.fromController = @"Game";
        
        divc.playersArray = _playersArray;
        divc.scoreArray = playerScores;
        
        divc.roundNumber = roundNumber;

    }
}

- (IBAction)randomTopic:(id)sender
{
    // get current topic list from file system
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TopicsList" ofType:@"plist"];
    NSArray *topicsArray = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    // generate random value from 0 to size of topics list
    
    int lowerBound = 0;
    int upperBound = (int)topicsArray.count;
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    
    NSLog(@"random number is: %d", rndValue);
    
    // set topics label and topic string
    
    topicChosen = topicsArray[rndValue];
    topicLabel.text = [NSString stringWithFormat:@"%@", topicChosen];
    
    [self startGame];
}

- (void)startGame
{
    if (roundNumber.intValue == 1)
    {
        addTopicButton.hidden = YES;
        pickTopicButton.hidden = YES;
        randomTopicButton.hidden = YES;
        
        countdownLabel.hidden = NO;
        
        nTopicButton.alpha = 0.4;
        nTopicButton.enabled = NO;
    }
    else
    {
        [self fadeOutTopicButtons];
    }

    
    _hasAddedPoint = NO;
    _timerHasReachedZero = NO;
    
    // begin countdown
    
    _timerValue = (int)[[NSUserDefaults standardUserDefaults] doubleForKey:@"gameTimer"] + 1;
    
    [self startCountdown:self];
}

@end