//
//  CustomerDetailsViewController.m
//  CBLiteCRM
//
//  Created by Ruslan on 11/28/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "CustomerDetailsViewController.h"
#import "Customer.h"
#import "DataStore.h"

@interface CustomerDetailsViewController ()

@end

@implementation CustomerDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.baseScrollView setContentSize:self.contentView.frame.size];
    [self loadInfoForCustomer:self.currentCustomer];
}

- (void)loadInfoForCustomer:(Customer*)cm{
    if(cm){
        self.companyNameField.text = cm.companyName;
        self.industryField.text = cm.industry;
        self.phoneField.text = cm.phone;
        self.mailField.text = cm.email;
        self.addressField.text = cm.address;
        self.URLField.text = cm.websiteUrl;
    }
}

- (IBAction)back:(id)sender {
    self.currentCustomer = nil;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveItem:(id)sender {
    if(self.mailField.text && ![self.mailField.text isEqualToString:@""]){
        Customer* newCustomer = self.currentCustomer;
        if(!newCustomer)
            newCustomer = [[DataStore sharedInstance] createCustomerWithMailOrReturnExist:self.mailField.text];
        [self updateInfoForCustomer:newCustomer];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)deleteItem:(id)sender {}

- (void)updateInfoForCustomer:(Customer*)cm{
    cm.companyName = self.companyNameField.text;
    cm.industry = self.industryField.text;
    cm.phone = self.phoneField.text;
    cm.address = self.addressField.text;
    cm.websiteUrl = self.URLField.text;
    NSError* error;
    [cm save:&error];
    if(error)
        NSLog(@"error in save customer: %@", error);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
