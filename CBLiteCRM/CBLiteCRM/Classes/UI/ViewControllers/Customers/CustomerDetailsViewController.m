//
//  CustomerDetailsViewController.m
//  CBLiteCRM
//
//  Created by Ruslan on 11/28/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "CustomerDetailsViewController.h"
#import "OpportunitiesViewController.h"
#import "ContactsByCustomerViewController.h"
#import "OpportunitiesByCustomerViewController.h"

//Data
#import "Customer.h"
#import "DataStore.h"
#import "CustomersStore.h"
#import "CustomerDeleteHelper.h"

@interface CustomerDetailsViewController ()
{
    CustomerDeleteHelper* deleteHelper;
}
@end

@implementation CustomerDetailsViewController
@synthesize deleteButton, textFields, buttons;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMode];
    deleteHelper = [CustomerDeleteHelper new];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadInfoForCustomer:self.currentCustomer];
}

- (void)setupMode
{
    BOOL editMode;
    if(self.currentCustomer)
        editMode = NO;
    else
        editMode = YES;
    [self setEditMode:editMode];
}

- (void)loadInfoForCustomer:(Customer*)cm{
    self.buttonsView.hidden = (cm == nil);
    if(cm) {
        self.companyNameField.text = cm.companyName.length > 0 ? cm.companyName : @"";
        self.industryField.text = cm.industry;
        self.phoneField.text = cm.phone;
        self.mailField.text = cm.email;
        self.addressField.text = cm.address;
        self.URLField.text = cm.websiteUrl;
    }else{
        self.navigationItem.title = @"Add New Customer";
    }
}

#pragma mark - Actions

- (IBAction)back:(id)sender {
    self.currentCustomer = nil;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveItem:(id)sender {
    if([self isEditMode]){
        if(self.companyNameField.text && ![self.companyNameField.text isEqualToString:@""]) {
            Customer* newCustomer = self.currentCustomer;
            if(!newCustomer)
                newCustomer = [[DataStore sharedInstance].customersStore createCustomerWithNameOrReturnExist:self.companyNameField.text];
            [self updateInfoForCustomer:newCustomer];
            [self setEditMode:NO];
        } else
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill Company field" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
    }else if(![self isEditMode])
        [self setEditMode:YES];
}

-(DeleteBlock)createOnDeleteBlock
{
    __weak typeof(self) weakSelf = self;
    return ^(BOOL shouldDelete){
        if (shouldDelete)
            [weakSelf dismissViewControllerAnimated:YES completion:^{}];
    };
}

- (IBAction)deleteItem:(id)sender {
    deleteHelper.item = self.currentCustomer;
    deleteHelper.deleteAlertBlock = [self createOnDeleteBlock];
    [deleteHelper showDeletionAlert];
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
    if ([segue.destinationViewController isKindOfClass:[OpportunitiesByCustomerViewController class]]) {
        OpportunitiesByCustomerViewController *vc = (OpportunitiesByCustomerViewController*)segue.destinationViewController;
        vc.customer = self.currentCustomer;
        vc.enabledForEditing = [self isEditMode];
    } else if ([segue.destinationViewController isKindOfClass:[ContactsViewController class]]) {
        ContactsByCustomerViewController *vc = (ContactsByCustomerViewController*)segue.destinationViewController;
        vc.customer = self.currentCustomer;
        vc.enabledForEditing = [self isEditMode] & self.enabledForEditing;
    }
}

- (void)editModeChanged:(BOOL)editMode
{
    self.buttonsView.hidden = !self.currentCustomer;
    self.opportunitiesButton.hidden = !self.currentCustomer;
    if (editMode)
        [self.opportunitiesButton setTitle:@"Edit Opportunities" forState:UIControlStateNormal];
    else
        [self.opportunitiesButton setTitle:@"Show Opportunities" forState:UIControlStateNormal];
}

#pragma mark -

- (void)updateInfoForCustomer:(Customer*)cm
{
    cm.companyName  = self.companyNameField.text;
    cm.industry = self.industryField.text;
    cm.phone = self.phoneField.text;
    cm.address = self.addressField.text;
    cm.websiteUrl = self.URLField.text;
    cm.email = self.mailField.text;
    NSError* error;
    if(![cm save:&error])
        NSLog(@"error in save customer: %@", error);
    else
        self.currentCustomer = cm;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
