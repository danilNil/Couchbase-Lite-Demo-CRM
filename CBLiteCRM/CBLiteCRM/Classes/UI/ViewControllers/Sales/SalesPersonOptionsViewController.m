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
    self.nameField.enabled = NO;
    self.phoneField.enabled = NO;
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

@end
