//
//  SalesPersonOptionsViewController.m
//  CBLiteCRM
//
//  Created by Ruslan on 11/26/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "SalesPersonOptionsViewController.h"
#import "SalesPerson.h"

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
    [self.navigationItem setTitle:self.salesPerson.username];
    self.nameField.text = self.salesPerson.username;
    self.phoneField.text = self.salesPerson.phoneNumber;
    self.mailField.text = self.salesPerson.email;
}

- (IBAction)save:(id)sender
{
    self.salesPerson.username = self.nameField.text;
    self.salesPerson.phoneNumber = self.phoneField.text;
    NSError *error;
    if (![self.salesPerson save:&error])
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
