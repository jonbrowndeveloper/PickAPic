//
//  PageContentViewController.h
//  pickapic
//
//  Created by Jon on 10/12/15.
//  Copyright © 2015 D&GVentures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.h"

@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (nonatomic, weak) NSString *labelText;
@property (nonatomic, weak) NSAttributedString *attributedLabelText;
@property (nonatomic, weak) UIColor *backgroundColor;

@property (weak, nonatomic) IBOutlet UIButton *beginPlayingButton;
- (IBAction)beginGameAction:(id)sender;

@property (assign, nonatomic) NSUInteger pageIndex;


@end
