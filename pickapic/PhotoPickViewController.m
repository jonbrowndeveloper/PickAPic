//
//  PhotoPickViewController.m
//  pickapic
//
//  Created by Steve Brown on 9/3/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import "PhotoPickViewController.h"
#import "OPIPGameViewController.h"

@interface PhotoPickViewController ()

@end

@implementation PhotoPickViewController

@synthesize photoImageView, timerValue = _timerValue, timerLabel, roundNumber, playersArray, scoreArray, topicChosen, image, timer;

- (void)viewDidLoad
{
    timerLabel.text = [NSString stringWithFormat:@"%d", _timerValue];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(advanceTimer:) userInfo:nil repeats:NO];

    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)advanceTimer:(NSTimer *)timer
{
    --_timerValue;
    if(self.timerValue != 0)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(advanceTimer:) userInfo:nil repeats:NO];
        timerLabel.text = [NSString stringWithFormat:@"%d", _timerValue];
        /*
        if ( _timerValue % 2)
        {
            AudioServicesPlaySystemSound(1105);
        }
        else
        {
            AudioServicesPlaySystemSound(1306);
        }*/
        
    }
    
    if (self.timerValue == 0)
    {
        
        timerLabel.text = [NSString stringWithFormat:@"0"];
        
        // do something like say the round is over, choose a winner
        
        // possible buzzer
        
        // AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        // AudioServicesPlaySystemSound(1005);
        
        // _timerHasReachedZero = YES;
        
        // [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fadeCountdownOut) userInfo:nil repeats:NO];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.timer invalidate];
    self.timer = nil;
}


#pragma mark - Navigation

 -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     // send category name to bucket collection view
     if([segue.identifier isEqualToString:@"pickerToOPIP"])
     {
         OPIPGameViewController *divc = (OPIPGameViewController *)[segue destinationViewController];
         
         divc.photoChosen = YES;
         
         divc.timerValue = _timerValue;
         
         divc.topicChosen = topicChosen;
         NSLog(@"Topic Chosen from Photo Picker View: %@", topicChosen);
         
         divc.playersArray = playersArray;
         divc.playerScores = scoreArray;
         
         divc.roundNumber = roundNumber;
         divc.image = image;
         
         
     }
 }

- (IBAction)getInstagramPhoto:(id)sender
{
    
}

- (IBAction)getCameraRollPhoto:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    image = info[UIImagePickerControllerEditedImage];
    self.photoImageView.image = image;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeScreen) userInfo:nil repeats:NO];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)changeScreen
{
    [self performSegueWithIdentifier:@"pickerToOPIP" sender:self];
}


- (IBAction)getFacebookPhoto:(id)sender
{
    
}

@end