//
//  TutorialViewController.h
//  pickapic
//
//  Created by Jon on 10/2/15.
//  Copyright © 2015 D&GVentures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *tutScrollView;
@property (weak, nonatomic) IBOutlet UIButton *enterGameButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
