//
//  PageContentViewController.m
//  pickapic
//
//  Created by Jon on 10/12/15.
//  Copyright © 2015 D&GVentures. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

@synthesize textLabel, beginPlayingButton, pageIndex, backgroundColor, labelText, attributedLabelText;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // colors array
    
    NSArray *colors = [NSArray arrayWithObjects:pinkColorTut, blueColorTut, greenColorTut, orangeColorTut, pinkColorTut, nil];
    
    self.view.backgroundColor = colors[pageIndex];
    self.textLabel.text = self.labelText;
    if (attributedLabelText != nil)
    {
        self.textLabel.attributedText = self.attributedLabelText;
    }

    // enter game button
    
    CALayer *btnLayer = [beginPlayingButton layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setBorderWidth:2.0f];
    [btnLayer setBorderColor:[UIColor colorWithRed:57.0/255.0 green:181.0/255.0 blue:74.0/255.0 alpha:1].CGColor];
    [btnLayer setBackgroundColor:[UIColor colorWithRed:75.0/255.0 green:142.0/255.0 blue:16.0/255.0 alpha:1].CGColor];
    [btnLayer setCornerRadius:8.0f];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"  Start Playing"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString length])];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"icn_button_newgame_small.png"];
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:attrStringWithImage];
    
    [beginPlayingButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    BOOL tutorialHasBeenSeen = [[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialHasBeenSeen"];
    
    if (pageIndex == 4 && !tutorialHasBeenSeen)
    {
        beginPlayingButton.hidden = NO;
    }
    else
    {
        beginPlayingButton.hidden = YES;
    }
    
    textLabel.numberOfLines = 8;
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont fontWithName:@"Lato-Light.ttf" size:8.0];
    textLabel.font = [UIFont boldSystemFontOfSize:36.0];
    textLabel.minimumScaleFactor = 0.3;
    textLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (IBAction)beginGameAction:(id)sender
{
    NSLog(@"tutorial has been seen");
    BOOL tutorialHasBeenSeen = YES;
    [[NSUserDefaults standardUserDefaults] setBool:tutorialHasBeenSeen forKey:@"tutorialHasBeenSeen"];
    
}

@end
