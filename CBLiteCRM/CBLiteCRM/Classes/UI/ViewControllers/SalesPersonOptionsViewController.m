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

@property (strong, nonatomic) IBOutlet UILabel *name;

@end

@implementation SalesPersonOptionsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self loadUserData];
}

- (void)loadUserData
{
    self.name.text = self.salesPerson.email;
}

@end
