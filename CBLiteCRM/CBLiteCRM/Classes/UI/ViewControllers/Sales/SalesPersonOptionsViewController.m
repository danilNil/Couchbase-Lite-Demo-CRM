//
//  SalesPersonOptionsViewController.m
//  CBLiteCRM
//
//  Created by Ruslan on 11/26/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "SalesPersonOptionsViewController.h"
#import "SalesPerson.h"

#import "DataStore.h"
@interface SalesPersonOptionsViewController ()

@end

@implementation SalesPersonOptionsViewController

- (void)viewDidLoad
{
    self.mailField.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadUserData];
}

- (void)loadUserData
{
    self.mailField.enabled = !self.salesPerson;
    if (self.salesPerson) {
        [self.navigationItem setTitle:self.salesPerson.username];
        self.nameField.text = self.salesPerson.username;
        self.phoneField.text = self.salesPerson.phoneNumber;
        self.mailField.text = self.salesPerson.email;
    } else {
        [self.navigationItem setTitle:@"New Sales Person"];
    }
}

- (IBAction)save:(id)sender
{
    if(![self.mailField.text isEqualToString:@""]){
        SalesPerson* newSalesPerson = self.salesPerson;
        if(!newSalesPerson)
            newSalesPerson = [[DataStore sharedInstance] createSalesPersonWithMailOrReturnExist:self.mailField.text];
        [self updateInfoForSalesPerson:newSalesPerson];
    }
}

- (void)updateInfoForSalesPerson:(SalesPerson*)sp
{
    sp.username = self.nameField.text;
    sp.phoneNumber = self.phoneField.text;
    NSError *error;
    if (![sp save:&error])
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)delete:(id)sender
{
    NSError *error;
    if (![self.salesPerson deleteDocument:&error])
        [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
    else
        [self.navigationController popViewControllerAnimated:YES];

}

@end
