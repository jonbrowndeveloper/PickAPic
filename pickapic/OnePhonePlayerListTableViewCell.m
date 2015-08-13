//
//  OnePhonePlayerListTableViewCell.m
//  pickapic
//
//  Created by Steve Brown on 8/12/15.
//  Copyright (c) 2015 D&GVentures. All rights reserved.
//

#import "OnePhonePlayerListTableViewCell.h"

@implementation OnePhonePlayerListTableViewCell

@synthesize textField;

- (void)awakeFromNib
{
    // [self.textField setDelegate:self];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/*
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // [self.textField resignFirstResponder];
    
    return YES;
}
*/
- (IBAction)addButton:(id)sender
{
    
}
@end
