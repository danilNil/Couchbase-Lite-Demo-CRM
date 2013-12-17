//
//  SalesPersonOptionsViewController.m
//  CBLiteCRM
//
//  Created by Ruslan on 11/26/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "SalesPersonOptionsViewController.h"
#import "SalesPerson.h"
#import "DeviceSoftware.h"

#import "DataStore.h"
#import "SalePersonsStore.h"

@interface SalesPersonOptionsViewController ()

@end

@implementation SalesPersonOptionsViewController
@synthesize needLogout;

- (void)viewDidLoad
{
    self.mailField.enabled = NO;
    if (!isIOS7())
        self.contentView.frame = self.view.bounds;
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
        self.deleteButton.hidden =![self isMe:self.salesPerson];
    }
}

- (IBAction)save:(id)sender
{
    [self updateInfoForSalesPerson:self.salesPerson];
}

- (BOOL)isMe:(SalesPerson*)sp{
    BOOL isMe = [[DataStore sharedInstance].salePersonsStore.user.user_id isEqualToString:sp.user_id];
    return isMe;
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
        [self logout];

}

- (void)logout{
    for (id<LogoutProtocol> vc in self.navigationController.viewControllers) {
        if([vc respondsToSelector:@selector(setNeedLogout:)]){
            vc.needLogout = YES;
        }
    }
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
