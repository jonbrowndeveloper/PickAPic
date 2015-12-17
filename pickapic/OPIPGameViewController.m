//
//  OPIPGameViewController.m
//  pickapic
//
//  Created by Steve Brown on 8/18/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import "OPIPGameViewController.h"
#import "TopicViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PhotoPickViewController.h"
#import "AppDelegate.h"

@interface OPIPGameViewController ()

@end

@implementation OPIPGameViewController

@synthesize topicLabel, playersArray = _playersArray, timer, timerValue = _timerValue, countdownLabel, topicChosen, nTopicButton, shareButton, cell = _cell, playerScores, currentJudge, roundNumber, hasAddedPoint = _hasAddedPoint, addTopicButton, pickTopicButton, randomTopicButton, roundLabel, timerHasReachedZero = _timerHasReachedZero, logoImageView, grayScreenView, photoChosen = _photoChosen, image, smallPhotoImageView, bigPhotoImageView, settingsButton, hostNeedsToPic, hosthasPickedAPic, actualRoundNumber, gameOver, pressedBackButton, shouldAddToRoundNumber, winners, isRounds, backButton, gameHasStarted, prompts;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // the game isn't over
    
    NSLog(@"round: %ld", (long)roundNumber);
    
    // initialize player scores
    if (playerScores == nil)
    {
        playerScores = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < _playersArray.count; i++)
        {
            NSInteger thisInteger = 0;
            
            [playerScores addObject:[NSNumber numberWithInteger:thisInteger]];
        }
    }
    
    // remove horrible white space on top of tableview
    
    self.gameTableView.contentInset = UIEdgeInsetsZero;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (roundNumber == nil)
    {
        roundNumber = [NSNumber numberWithInt:1];
    }
    
    if (actualRoundNumber == nil) {
        actualRoundNumber = [NSNumber numberWithInt:1];
    }
    
    roundLabel.text = [NSString stringWithFormat:@"ROUND %d", actualRoundNumber.intValue];
    
    // set topic label
    
    NSLog(@"topic chosen: %@", topicChosen);
    
    topicLabel.text = topicChosen;
    
    // set pickapic logo
    
    logoImageView.image = [UIImage imageNamed:@"pickAPickLogoLarge"];
    logoImageView.hidden = YES;
    
    // setup gray popover screen for when host needs to choose
    
    grayScreenView.hidden = YES;
    
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
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.height *0.65), (self.navigationController.navigationBar.frame.size.height *0.65));
    [backButton setImage:[UIImage imageNamed:@"icn_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icn_back_active"] forState:(UIControlStateSelected | UIControlStateHighlighted)];
    [backButton setSelected:YES];
    
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backItem;
    
    // set 'Pick A Pic' logo on navigation bar
    
    UIImage *logo = [UIImage imageNamed:@"icn_logo.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:logo];
    imgView.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.width * 0.75), (self.navigationController.navigationBar.frame.size.height * 0.75));
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imgView;
    
    // settings button - added to make sure that the pickapic logo stays centered
    
    settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.height *0.65), (self.navigationController.navigationBar.frame.size.height *0.65));
    [settingsButton setImage:[UIImage imageNamed:@"icn_settings"] forState:UIControlStateNormal];
    [settingsButton setImage:[UIImage imageNamed:@"icn_settings_active"] forState:(UIControlStateSelected | UIControlStateHighlighted)];
    [settingsButton setSelected:YES];
    
    settingsButton.hidden = YES;
    
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    
    self.navigationItem.rightBarButtonItem = settingsItem;
    
    // game prompts bool
    
    prompts = [[NSUserDefaults standardUserDefaults] boolForKey:@"gamePromptsActive"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    countdownLabel.text = @"";
    
    [timer invalidate];
    timer = nil;
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
    
    // start the label update timer
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setTimerLabel) userInfo:nil repeats:YES];
    
    // making sure bools are set correctly when view appears
    
    pressedBackButton = NO;
    gameOver = NO;
    
    NSArray * viewControllers = [self.navigationController viewControllers];
    NSArray * newViewControllers = [NSArray arrayWithObjects:[viewControllers objectAtIndex:0], self,nil];
    [self.navigationController setViewControllers:newViewControllers];
    
    if (![topicChosen isEqualToString:@"placeholder"])
    {
        topicLabel.text = topicChosen;
        
        if (_photoChosen == NO && gameHasStarted == NO)
        {
            // likely coming from topic picker view
            
            [self startGame];
        }
        else if (_photoChosen == NO && gameHasStarted == YES)
        {
            // if the photo picker has been cancelled
            
            NSLog(@"host is playing");
            
            // grayScreenView.hidden = NO;
            
            hostNeedsToPic = YES;

            NSTimer *alertTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(passThePhoneToHost) userInfo:nil repeats:NO];
            

        }
        else
        {
            // host photo has been picked
            
            addTopicButton.hidden = YES;
            pickTopicButton.hidden = YES;
            randomTopicButton.hidden = YES;
            
            countdownLabel.hidden = NO;
            
            nTopicButton.alpha = 0.4;
            nTopicButton.enabled = NO;
            logoImageView.hidden = YES;
            
            // set image
            
            smallPhotoImageView.image = image;
            
            smallPhotoImageView.layer.cornerRadius = 5.0;
            smallPhotoImageView.layer.masksToBounds = YES;
            
            smallPhotoImageView.hidden = NO;
                        // add touch identifier
            
            UITapGestureRecognizer *newTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showLargePic)];
            
            [smallPhotoImageView setUserInteractionEnabled:YES];
            
            [smallPhotoImageView addGestureRecognizer:newTap];
            
            NSTimer *alertTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(passThePhoneToJudge) userInfo:nil repeats:NO];

            
        }
    }
    
    NSLog(@"Topic Chosen: %@", topicChosen);
    
    bigPhotoImageView.hidden = YES;
    
    // roundLabel.text = roundNumber.stringValue;
    
    [self.gameTableView reloadData];
    

}

- (void)showLargePic
{
    UITapGestureRecognizer *newTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideLargePic)];
    
    [bigPhotoImageView setUserInteractionEnabled:YES];
    
    [bigPhotoImageView addGestureRecognizer:newTap];
    
    bigPhotoImageView.image = image;
    bigPhotoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.15;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];
    grayScreenView.hidden = NO;
    bigPhotoImageView.hidden = NO;
    backButton.enabled = NO;
}

- (void)hideLargePic
{
    backButton.enabled = YES;
    grayScreenView.hidden = YES;
    bigPhotoImageView.hidden = YES;
}

- (void)backAction
{
    pressedBackButton = YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to quit?" message:[NSString stringWithFormat:@"\n"] delegate:self cancelButtonTitle:@"Quit Game" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle = UIAlertActionStyleDefault;
    [alert show];
}

- (void)setTimerLabel
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.countdownLabel.text = [NSString stringWithFormat:@"%d", delegate.timerValue];
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
    logoImageView.hidden = NO;

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
    
    logoImageView.hidden = YES;
    
    addTopicButton.hidden = NO;
    pickTopicButton.hidden = NO;
    randomTopicButton.hidden = NO;
    
    countdownLabel.hidden = YES;
    
    nTopicButton.alpha = 0.4;
    nTopicButton.enabled = NO;
    
    smallPhotoImageView.hidden = YES;
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
    _cell.scoreLabel.text = [NSString stringWithFormat:@"%@", playerScores[indexPath.row]];
    
    if (indexPath.row  == ((roundNumber.integerValue -1)%_playersArray.count))
    {
        _cell.playerProfileImageView.image = [UIImage imageNamed:@"icn_profile_game"];
        
        _cell.addPointButton.hidden = YES;
        _cell.subtractPointButton.hidden = YES;
        
        // bool to add 1 to actual round number
        
        if (indexPath.row == _playersArray.count-1)
        {
            shouldAddToRoundNumber = YES;
            NSLog(@"Should add to round number");
        }
        else
        {
            shouldAddToRoundNumber = NO;
            NSLog(@"Should not add to round number");
        }
    }
    else if (indexPath.row == ((roundNumber.integerValue -2)%_playersArray.count))
    {
        _cell.playerProfileImageView.image = nil;
        
        _cell.addPointButton.hidden = NO;
        _cell.subtractPointButton.hidden = NO;
        
        // do not add to round number yet
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
        NSNumber *playerScore = [playerScores objectAtIndex:(sender.tag)];
        
        int value = [playerScore intValue];
        playerScore = [NSNumber numberWithInt:value + 1];
        
        [playerScores replaceObjectAtIndex:(sender.tag) withObject:playerScore];
        
        [self.gameTableView reloadData];
        
        _hasAddedPoint = YES;
        
        [self fadeInNewTopicButton];
        nTopicButton.enabled = YES;
    }
    
    // check to see if the game is over
    
    isRounds = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRounds"];
    
    int numberToCheck;
    
    // get the max numbers in the array
    
    winners = [[NSMutableArray alloc] init];
    
    int maxValue = 0;
    
    // find largest value
    
    for (int i = 0; i < playerScores.count; i++)
    {
        NSNumber *currentPlayerScore = playerScores[i];
        
        if (currentPlayerScore.integerValue > maxValue)
        {
            maxValue = currentPlayerScore.intValue;
        }
    }
    
    // get names in list that have largest value
    
    for (int i = 0; i < playerScores.count; i++)
    {
        NSNumber *currentPlayerScore = playerScores[i];
        
        if (currentPlayerScore.integerValue == maxValue)
        {
            [winners addObject:_playersArray[i]];
        }
    }
    
    if (isRounds == YES)
    {
        numberToCheck = actualRoundNumber.intValue;
    }
    else
    {
        // point checker
        
        NSLog(@"POINT GAME");
        
        numberToCheck = maxValue;
    }
    
    // get number of points or rounds they selected from settings screen
    
    double numberOfRoundsOrPoints = [[NSUserDefaults standardUserDefaults] doubleForKey:@"numberOfRoundsOrPoints"];
    
    NSLog(@"current player: %lu\n out of %lu players", (((roundNumber.integerValue -1)%_playersArray.count)+1), (unsigned long)_playersArray.count);
    
    // NSLog(@"number to check is %d\nnumber of rounds is %d", numberToCheck, (int)numberOfRoundsOrPoints);

    if (!isRounds && numberToCheck == numberOfRoundsOrPoints)
    {
        gameOver = YES;
        
        [nTopicButton setTitle:@"End Game" forState:UIControlStateNormal];
    }
    else if (isRounds && numberToCheck == numberOfRoundsOrPoints && (((roundNumber.integerValue -1)%_playersArray.count) +1)== _playersArray.count)
    {
        gameOver = YES;
        
        [nTopicButton setTitle:@"End Game" forState:UIControlStateNormal];
    }
    
}

- (void)subtractPointFromScore:(UIButton *)sender
{
    
    NSNumber *playerScore = [playerScores objectAtIndex:(sender.tag - 10000)];
    int value = [playerScore intValue];
    
    if (value > 0)
    {
        // decrease score by 1
        
        playerScore = [NSNumber numberWithInt:value - 1];
        
        [playerScores replaceObjectAtIndex:(sender.tag - 10000) withObject:playerScore];
        
        _hasAddedPoint = NO;
        
        [self fadeOutNewTopicButton];
        nTopicButton.enabled = NO;
        /*
        if (_timerHasReachedZero != YES)
        {
            _timerValue++;
            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(advanceTimer:) userInfo:nil repeats:NO];
        }*/
        
    }
    
    if (gameOver == YES)
    {
        [nTopicButton setTitle:@"New Topic" forState:UIControlStateNormal];
    }
    
    gameOver = NO;
    
    [self.gameTableView reloadData];
}


- (IBAction)shareAction:(id)sender
{
    // https://docs.google.com/forms/d/1jKaCVZVzlnPnaUYm8ti8oSP-NbXZkzoBIDV7eDB5FPc/viewform
    
    
    NSString *textToShare = @"Find out when PickAPic is availible on the App Store!\n";
    NSURL *myWebsite = [NSURL URLWithString:@"https://docs.google.com/forms/d/1jKaCVZVzlnPnaUYm8ti8oSP-NbXZkzoBIDV7eDB5FPc/viewform"];
    
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
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] timer] invalidate];
    // [(AppDelegate *)[[UIApplication sharedApplication] delegate] timer] = nil;
    // [timer invalidate];
    // timer = nil;
    
    // set host picking bool to make sure the photo picker doesn't show up yet
    
    hostNeedsToPic = NO;
    
    // increment round number by 1
    
    int value = [roundNumber intValue];
    roundNumber = [NSNumber numberWithInt:value + 1];
    
    if (shouldAddToRoundNumber == YES)
    {
        int roundValue = [actualRoundNumber intValue];
        
        actualRoundNumber = [NSNumber numberWithInteger:roundValue +1];
    }
    
    if (_hasAddedPoint == YES && !gameOver)
    {
        [self fadeInTopicButtons];
        
        // set topic label
        
        topicLabel.text = @"Choose Topic";
        
        _hasAddedPoint = NO;
        
        roundLabel.text = [NSString stringWithFormat:@"ROUND %d", actualRoundNumber.intValue];
        
        _timerValue = (int)[[NSUserDefaults standardUserDefaults] doubleForKey:@"gameTimer"] + 1;
        
        _timerHasReachedZero = NO;
        
        [self.gameTableView reloadData];
        
        logoImageView.hidden = YES;
        
        _photoChosen = NO;
        gameHasStarted = NO;
        
        [timer invalidate];
        timer = nil;
        
        NSLog(@"Give Phone to next player!");
        
        if (prompts == YES)
        {
            NSTimer *alertTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(passThePhoneToPickTopic) userInfo:nil repeats:NO];

        }
        
    }
    else if (_hasAddedPoint == NO)
    {
        NSLog(@"Give someone a point first!");
    }
    else if (gameOver)
    {
        if (winners.count == 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"GAME OVER!\n%@ Wins!", winners[0]] message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.alertViewStyle = UIAlertActionStyleDefault;
            [alert show];
        }
        else
        {
            NSMutableString *winnersString = [NSMutableString stringWithString:@""];
            for (int i = 0; i < winners.count; i++)
            {
                [winnersString appendString:[NSString stringWithFormat:@"\n%@", winners[i]]];
                
                // NSLog(@"current winner %@", winners[i]);
            }
            
            NSLog(@"Winners string: %@\n winners length is: %lu", winnersString, (unsigned long)winners.count);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Complete!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.alertViewStyle = UIAlertActionStyleDefault;
            [alert show];
            
            UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 200)];
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\nWinners:\n%@\n\n", winnersString]];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(11,winnersString.length)];
            [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:26.0] range:NSMakeRange(11, winnersString.length)];
            lbl.attributedText = attributedStr;
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.numberOfLines = 9;
            [alert setValue:lbl forKey:@"accessoryView"];
            [alert show];
        }

        gameOver = YES;
        
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
    else if ([segue.identifier isEqualToString:@"fromOPIPToPicker"])
    {
        PhotoPickViewController *divc = (PhotoPickViewController *)[segue destinationViewController];
        
        divc.timerValue = _timerValue;
        
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
    int upperBound = (int)topicsArray.count - 1;
    int rndValue = lowerBound + arc4random() % upperBound;
    
    NSLog(@"random number is: %d", rndValue);
    
    // set topics label and topic string
    
    topicChosen = topicsArray[rndValue];
    topicLabel.text = [NSString stringWithFormat:@"%@", topicChosen];
    
    [self startGame];
}

- (void)startGame
{
    // bool to keep track of if the game is going or not
    
    gameHasStarted = YES;
    
    if (roundNumber.intValue == 1)
    {
        addTopicButton.hidden = YES;
        pickTopicButton.hidden = YES;
        randomTopicButton.hidden = YES;
        
        countdownLabel.hidden = NO;
        
        nTopicButton.alpha = 0.4;
        nTopicButton.enabled = NO;
        logoImageView.hidden = YES;
        
    }
    else
    {
        countdownLabel.text = [NSString stringWithFormat:@"%d", (int)[[NSUserDefaults standardUserDefaults] doubleForKey:@"gameTimer"]];
        
        [self fadeOutTopicButtons];
    }
    
    NSLog(@"round number: %d", (int)roundNumber%(int)_playersArray.count);
    
    
    if (((roundNumber.integerValue)%_playersArray.count) != 1)
    {
        NSLog(@"host is playing");
        
        // grayScreenView.hidden = NO;

        NSTimer *alertTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(passThePhoneToHost) userInfo:nil repeats:NO];



    }

    
    _hasAddedPoint = NO;
    _timerHasReachedZero = NO;
    
    // begin countdown
    
    _timerValue = (int)[[NSUserDefaults standardUserDefaults] doubleForKey:@"gameTimer"] + 1;
        
    [[[UIApplication sharedApplication] delegate] performSelector:@selector(startTimer)];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        if (pressedBackButton == YES)
        {
            [[(AppDelegate *)[[UIApplication sharedApplication] delegate] timer] invalidate];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (hostNeedsToPic == YES && pressedBackButton == NO && gameOver == NO)
        {
            NSLog(@"host should pick a pic now!");
            
            // open up photo picker
            
            [self getCameraRollPhoto];
        }
        else if (gameOver == YES)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
    else
    {
        NSLog(@"cancel button has been pressed");
        
        pressedBackButton = NO;
        gameOver = NO;
    }
}

// photo picker methods

- (void)getCameraRollPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    image = info[UIImagePickerControllerEditedImage];
    self.bigPhotoImageView.image = image;
    self.bigPhotoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.smallPhotoImageView.image = image;
    self.smallPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    hostNeedsToPic = NO;
    _photoChosen = YES;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)passThePhoneToHost
{
    hostNeedsToPic = YES;
    
    NSString *playerName = _playersArray[0];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"I passed it!", nil];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 200)];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\nPass the phone to\n\n%@\n\nto Pick a Pic!\n", playerName]];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(20,playerName.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:26.0] range:NSMakeRange(20, playerName.length)];
    lbl.attributedText = attributedStr;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.numberOfLines = 9;
    [alert setValue:lbl forKey:@"accessoryView"];
    [alert show];
}

- (void)passThePhoneToPickTopic
{
    NSString *playerName = _playersArray[((roundNumber.integerValue -1)%_playersArray.count)];
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"I passed it!", nil];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 200)];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\nPass the phone to\n\n%@\n\nto choose the next topic!\n", playerName]];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(20,playerName.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:26.0] range:NSMakeRange(20, playerName.length)];
    lbl.attributedText = attributedStr;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.numberOfLines = 9;
    [alert setValue:lbl forKey:@"accessoryView"];
    [alert show];
}

- (void)passThePhoneToJudge
{
    // prompt to send phone back to the current judge
    
    NSString *playerName = _playersArray[((roundNumber.integerValue -1)%_playersArray.count)];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"I passed it!", nil];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 200)];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\nPass the phone to\n\n%@\n\nto choose the best pic!\n", playerName]];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(20,playerName.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:26.0] range:NSMakeRange(20, playerName.length)];
    lbl.attributedText = attributedStr;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.numberOfLines = 9;
    [alert setValue:lbl forKey:@"accessoryView"];
    [alert show];
}

@end