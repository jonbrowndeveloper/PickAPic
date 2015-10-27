//
//  TutorialViewController.m
//  pickapic
//
//  Created by Jon on 10/2/15.
//  Copyright © 2015 D&GVentures. All rights reserved.
//

#import "TutorialViewController.h"
#import "constants.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

@synthesize tutScrollView, enterGameButton, pageControl;

- (void)viewDidLoad
{
    [super viewDidLoad];

    int numberOfPages = 5;
    
    // scroll view properties
    tutScrollView.pagingEnabled = YES;
    tutScrollView.scrollEnabled = YES;
    tutScrollView.showsHorizontalScrollIndicator = NO;
    tutScrollView.showsVerticalScrollIndicator = NO;
    tutScrollView.scrollsToTop = NO;
    tutScrollView.delegate = self;
    
    [tutScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    tutScrollView.contentSize = CGSizeMake(numberOfPages * self.tutScrollView.frame.size.width, self.tutScrollView.frame.size.height);
    
    NSLog(@"page width: %f, window is: %f", tutScrollView.frame.size.width, self.view.frame.size.width);
    
    // colors array
    
    NSArray *colors = [NSArray arrayWithObjects:pinkColorTut, blueColorTut, greenColorTut, orangeColorTut, pinkColorTut, nil];
    
    // text array
    
    // create some text for the button with the finger image
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Judge (indicated by ) picks the topic and doesn't submit a photo that round"];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"icn_profile_game.png"];
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString replaceCharactersInRange:NSMakeRange(20, 0) withAttributedString:attrStringWithImage];
    
    NSArray *textArray = [[NSArray alloc] initWithObjects:@"Pick a Topic,\nAdd Players,\nBegin Game!",@"Players find a photo on their own phone according to the topic", attributedString,@"Judge views photo that each player submitted and chooses the best photo and gives that player a point",@"Next player in list becomes judge and it's their turn to pick the topic", nil];
    
    // doing some screen size testing TODO: Remove before release
    
    UIScreen *screen = [UIScreen mainScreen];
    NSLog(@"Screen width %.0f px, height %.0f px, scale %.1fx",
          (double) screen.bounds.size.width,
          (double) screen.bounds.size.height,
          (double) screen.scale);
    
    for (int i = 0; i < numberOfPages; i++)
    {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        NSLog(@"backgroun: %d x location: %f",i , i * self.view.frame.size.width);
        
        backgroundView.backgroundColor = colors[i];
        backgroundView.alpha = 1;
        
        // button for last page
        
        if (i == 4)
        {
            CGRect btFrame = enterGameButton.frame;
            btFrame.origin.x = 90;
            btFrame.origin.y = 150;
            enterGameButton.frame = btFrame;
            
            CALayer *btnLayer = [enterGameButton layer];
            [btnLayer setMasksToBounds:YES];
            [btnLayer setBorderWidth:2.0f];
            [btnLayer setBorderColor:[UIColor colorWithRed:57.0/255.0 green:181.0/255.0 blue:74.0/255.0 alpha:1].CGColor];
            [btnLayer setBackgroundColor:[UIColor colorWithRed:75.0/255.0 green:142.0/255.0 blue:16.0/255.0 alpha:1].CGColor];
            [btnLayer setCornerRadius:8.0f];
            
            // create some text for the button with the finger image
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"  Start Playing"];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString length])];
            
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"icn_button_newgame_small.png"];
            
            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
            
            [attributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:attrStringWithImage];
            
            [enterGameButton setAttributedTitle:attributedString forState:UIControlStateNormal];
            enterGameButton.enabled = YES;
            
            
            [backgroundView addSubview:enterGameButton];
            
            
        }
        
        [tutScrollView addSubview:backgroundView];
        
        UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * self.view.frame.size.width + 20, 20, self.view.frame.size.width -40, self.view.frame.size.height - 150)];
        
        if ([textArray[i] isKindOfClass:[NSAttributedString class]])
        {
            tmpLabel.attributedText = textArray[i];
        }
        else
        {
            tmpLabel.text = textArray[i];
        }
        
        tmpLabel.numberOfLines = 8;
        tmpLabel.textColor = [UIColor whiteColor];
        tmpLabel.font = [UIFont fontWithName:@"Lato-Light.ttf" size:8.0];
        tmpLabel.font = [UIFont boldSystemFontOfSize:48.0];
        tmpLabel.minimumScaleFactor = 0.3;
        tmpLabel.textAlignment = NSTextAlignmentCenter;
        
        [tutScrollView addSubview:tmpLabel];
        

    }
    
    // [self.view addSubview:tutScrollView];
}

@end
