//
//  TutorialPageViewController.h
//  pickapic
//
//  Created by Jon on 10/12/15.
//  Copyright © 2015 D&GVentures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface TutorialPageViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, strong) NSArray *colors;

@end
