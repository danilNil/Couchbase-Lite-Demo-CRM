//
//  ContactDetailsViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "ContactDetailsViewController.h"

static float const kContactDetailsContentHeight = 700.0;

@interface ContactDetailsViewController ()

@end

@implementation ContactDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.baseScrollView setContentSize:self.contentView.frame.size];
    NSLog(@"content size: %@", NSStringFromCGSize(self.baseScrollView.contentSize));
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveItem:(id)sender {
}

- (IBAction)deleteItem:(id)sender {
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
