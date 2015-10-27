//
//  TutorialPageViewController.m
//  pickapic
//
//  Created by Jon on 10/12/15.
//  Copyright © 2015 D&GVentures. All rights reserved.
//

#import "TutorialPageViewController.h"
#import "constants.h"

@interface TutorialPageViewController ()

@end

@implementation TutorialPageViewController

@synthesize textArray, colors;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // create attributed string for finger image first
    
    // create some text for the button with the finger image
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Judge (indicated by ) picks the topic and doesn't submit a photo that round"];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"icn_profile_game.png"];
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString replaceCharactersInRange:NSMakeRange(20, 0) withAttributedString:attrStringWithImage];
    
    // text array
    
    self.textArray = [[NSArray alloc] initWithObjects:@"Pick a Topic,\nAdd Players,\nBegin Game!",@"Players find a photo on their own phone according to the topic", attributedString,@"Judge views photo that each player submitted and chooses the best photo and gives that player a point",@"Next player in list becomes judge and it's their turn to pick the topic", nil];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    // set 'Pick A Pic' logo on navigation bar
    
    UIImage *logo = [UIImage imageNamed:@"icn_logo.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:logo];
    imgView.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.width * 0.75), (self.navigationController.navigationBar.frame.size.height * 0.75));
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imgView;
    
    // navbar color
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:201.0/255.0 alpha:1]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // hide navigation bar if the tutorial has not been seen
    BOOL tutorialHasBeenSeen = [[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialHasBeenSeen"];

    if (!tutorialHasBeenSeen)
    {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    
    // back button
    
     UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
     backButton.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.height *0.65), (self.navigationController.navigationBar.frame.size.height *0.65));
     [backButton setImage:[UIImage imageNamed:@"icn_back"] forState:UIControlStateNormal];
     [backButton setImage:[UIImage imageNamed:@"icn_back_active"] forState:(UIControlStateSelected | UIControlStateHighlighted)];
     [backButton setSelected:YES];
     
     [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
     
     UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
     
     self.navigationItem.leftBarButtonItem = backItem;
    
    // settings button - added to make sure that the pickapic logo stays centered
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingsButton.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.height *0.65), (self.navigationController.navigationBar.frame.size.height *0.65));
    [settingsButton setImage:[UIImage imageNamed:@"icn_settings"] forState:UIControlStateNormal];
    [settingsButton setImage:[UIImage imageNamed:@"icn_settings_active"] forState:(UIControlStateSelected | UIControlStateHighlighted)];
    [settingsButton setSelected:YES];
    
    settingsButton.hidden = YES;
    
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:settingsItem, nil];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound)
    {
        return nil;
    }
    
    index++;
    if (index == [self.textArray count])
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.textArray count] == 0) || (index >= [self.textArray count]))
    {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    
    // make sure on page 3 the finger image shows correctly
    if (index == 2)
    {
        pageContentViewController.attributedLabelText = self.textArray[index];
    }
    else
    {
        pageContentViewController.labelText = self.textArray[index];
    }
    
    
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.textArray count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
