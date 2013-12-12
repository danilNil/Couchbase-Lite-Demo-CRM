//
//  CustomerDetailsViewController.m
//  CBLiteCRM
//
//  Created by Ruslan on 11/28/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "CustomerDetailsViewController.h"
#import "OpportunitiesViewController.h"
#import "ContactsViewController.h"
#import "DeviceSoftware.h"

//Data
#import "Customer.h"
#import "DataStore.h"
#import "CustomersStore.h"

@interface CustomerDetailsViewController ()

@end

@implementation CustomerDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (isIOS7())
        self.automaticallyAdjustsScrollViewInsets = NO;
    else
        self.baseScrollView.frame = self.view.bounds;
    [self.baseScrollView setContentSize:self.contentView.frame.size];
    [self loadInfoForCustomer:self.currentCustomer];
}

- (void)loadInfoForCustomer:(Customer*)cm{
    self.deleteButton.enabled = cm ? YES : NO;
    if(cm) {
        self.companyNameField.text = cm.companyName;
        self.industryField.text = cm.industry;
        self.phoneField.text = cm.phone;
        self.mailField.text = cm.email;
        self.addressField.text = cm.address;
        self.URLField.text = cm.websiteUrl;
        self.companyNameField.enabled = NO;
    }else{
        self.navigationItem.title = @"Add New Customer";
    }
}

- (IBAction)back:(id)sender {
    self.currentCustomer = nil;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveItem:(id)sender {
    if(self.companyNameField.text && ![self.companyNameField.text isEqualToString:@""]) {
        Customer* newCustomer = self.currentCustomer;
        if(!newCustomer)
            newCustomer = [[DataStore sharedInstance].customersStore createCustomerWithNameOrReturnExist:self.companyNameField.text];
        [self updateInfoForCustomer:newCustomer];
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill company name field" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
}

- (IBAction)deleteItem:(id)sender {
    NSError *error;
    if ([self.currentCustomer deleteDocument:&error]) {
        [self  dismissViewControllerAnimated:YES completion:^{}];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:Nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
    }
}

- (IBAction)opportunities:(id)sender
{
    [self performSegueWithIdentifier:@"presentOpportunitiesForCustomer" sender:self];
}

- (IBAction)showContacts:(id)sender
{
    [self performSegueWithIdentifier:@"presentContactsForCustomer" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[OpportunitiesViewController class]]) {
        OpportunitiesViewController *vc = (OpportunitiesViewController*)segue.destinationViewController;
        vc.filteredCustomer = self.currentCustomer;
    } else if ([segue.destinationViewController isKindOfClass:[ContactsViewController class]]) {
        ContactsViewController *vc = (ContactsViewController*)segue.destinationViewController;
        vc.filteredCustomer = self.currentCustomer;
    }
}

- (void)updateInfoForCustomer:(Customer*)cm{
    cm.industry = self.industryField.text;
    cm.phone = self.phoneField.text;
    cm.address = self.addressField.text;
    cm.websiteUrl = self.URLField.text;
    cm.email = self.mailField.text;
    NSError* error;
    if(![cm save:&error])
        NSLog(@"error in save customer: %@", error);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
