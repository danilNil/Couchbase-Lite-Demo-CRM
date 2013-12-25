//
//  CustomerDetailsViewController.m
//  CBLiteCRM
//
//  Created by Ruslan on 11/28/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "CustomerDetailsViewController.h"
#import "OpportunitiesViewController.h"
#import "ContactsViewController.h"

//Data
#import "Customer.h"
#import "DataStore.h"
#import "CustomersStore.h"
#import "CBLModelDeleteHelper.h"

@interface CustomerDetailsViewController ()
{
    CBLModelDeleteHelper* deleteHelper;
}
@end

@implementation CustomerDetailsViewController
@synthesize deleteButton, textFields;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupScrollView];
    [self loadInfoForCustomer:self.currentCustomer];
    [self setupMode];
    deleteHelper = [CBLModelDeleteHelper new];
}

- (void)setupScrollView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.baseScrollView setContentSize:self.contentView.frame.size];
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
    if([self.navigationItem.rightBarButtonItem.title isEqualToString:kSaveTitle]){
        if(self.companyNameField.text && ![self.companyNameField.text isEqualToString:@""]) {
            Customer* newCustomer = self.currentCustomer;
            if(!newCustomer)
                newCustomer = [[DataStore sharedInstance].customersStore createCustomerWithNameOrReturnExist:self.companyNameField.text];
            [self updateInfoForCustomer:newCustomer];
            [self dismissViewControllerAnimated:YES completion:NULL];
        } else
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill Company field" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
    }else if([self.navigationItem.rightBarButtonItem.title isEqualToString:kEditTitle])
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
    if ([segue.destinationViewController isKindOfClass:[OpportunitiesViewController class]]) {
        OpportunitiesViewController *vc = (OpportunitiesViewController*)segue.destinationViewController;
        vc.filteredCustomer = self.currentCustomer;
    } else if ([segue.destinationViewController isKindOfClass:[ContactsViewController class]]) {
        ContactsViewController *vc = (ContactsViewController*)segue.destinationViewController;
        vc.filteredCustomer = self.currentCustomer;
        vc.navigationItem.rightBarButtonItem = nil;
    }
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
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
