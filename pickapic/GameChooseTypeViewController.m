//
//  GameChooseTypeViewController.m
//  PickAPic
//
//  Created by William A. Brown on 8/5/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import "GameChooseTypeViewController.h"

@interface GameChooseTypeViewController ()

@end

@implementation GameChooseTypeViewController

@synthesize onePhoneButton, manyPhoneInPersonButton, manyPhoneRemoteButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self.view.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0];
    
    // [onePhoneButton setImage:[UIImage imageNamed:@"one-phone-in-person.png"] forState:UIControlStateNormal];
    // [manyPhoneInPersonButton setImage:[UIImage imageNamed:@"multiple-phones-in-person.png"] forState:UIControlStateNormal];
    // [manyPhoneRemoteButton setImage:[UIImage imageNamed:@"multiple-phones-remote.png"] forState:UIControlStateNormal];
    
    // back button - TODO IMPLEMENT IN FULL VERSION
    /*
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, (self.navigationController.navigationBar.frame.size.height *0.65), (self.navigationController.navigationBar.frame.size.height *0.65));
    [backButton setImage:[UIImage imageNamed:@"icn_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"icn_back_active"] forState:(UIControlStateSelected | UIControlStateHighlighted)];
    [backButton setSelected:YES];
    
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = backItem;
    */
    
    // TODO: REMOVE IN FINAL VERSION?
    
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

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

