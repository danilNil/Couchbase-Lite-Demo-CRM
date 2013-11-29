//
//  OpportunityDetailesViewController.m
//  CBLiteCRM
//
//  Created by Danil on 29/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "OpportunityDetailesViewController.h"

@interface OpportunityDetailesViewController ()

@end

@implementation OpportunityDetailesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.baseScrollView setContentSize:self.contentView.frame.size];
}

- (IBAction)back:(id)sender {
    self.currentOpport = nil;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveItem:(id)sender {
}

- (IBAction)showContacts:(id)sender {
}

- (IBAction)deleteItem:(id)sender {
}

- (IBAction)changeCustomer:(id)sender {
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
