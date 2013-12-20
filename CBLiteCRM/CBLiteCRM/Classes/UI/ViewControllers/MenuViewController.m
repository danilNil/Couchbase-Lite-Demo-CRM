//
//  MenuViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "DataStore.h"
#import "SalePersonsStore.h"
#import "SalesPerson.h"
@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize needLogout;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateStateForUser:[DataStore sharedInstance].salePersonsStore.user];
    if(self.needLogout)
        [self logout:self];
}

- (IBAction)logout:(id)sender {
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    [app logout];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)updateStateForUser:(SalesPerson*)user{
    BOOL needToShow =user.isAdmin || user.approved;
    NSLog(@"admin: %i approved: %i", user.isAdmin, user.approved);
    self.contactsButton.enabled = needToShow;
    self.customersButton.enabled = needToShow;
    self.oppButton.enabled = needToShow;
}

@end
