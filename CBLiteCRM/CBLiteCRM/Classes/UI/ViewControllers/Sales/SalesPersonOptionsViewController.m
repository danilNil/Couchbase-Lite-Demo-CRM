//
//  SalesPersonOptionsViewController.m
//  CBLiteCRM
//
//  Created by Ruslan on 11/26/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "SalesPersonOptionsViewController.h"
#import "SalesPerson.h"

#import "DataStore.h"
#import "SalePersonsStore.h"

static NSString* const kEditTitle = @"Edit";
static NSString* const kSaveTitle = @"Save";

@interface SalesPersonOptionsViewController ()

@end

@implementation SalesPersonOptionsViewController
@synthesize needLogout;

- (void)viewDidLoad
{
    self.mailField.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadUserData];
    [self blockItemForEditing:[self isMe:self.salesPerson]];
    BOOL editMode;
    if(self.salesPerson)
        editMode = NO;
    else
        editMode = YES;
    [self setEditMode:editMode];
}

- (void)loadUserData
{
    if (self.salesPerson) {
        [self.navigationItem setTitle:self.salesPerson.username];
        self.nameField.text = self.salesPerson.username;
        self.phoneField.text = self.salesPerson.phoneNumber;
        self.mailField.text = self.salesPerson.email;
    }
}

- (void)blockItemForEditing:(BOOL)canEdit{
    self.deleteButton.hidden =!canEdit;
    self.navigationItem.rightBarButtonItem.enabled = canEdit;
    for (UITextField* tf in self.textFields) {
        tf.enabled = canEdit;
    }
}
- (void)setEditMode:(BOOL)editMode{
    [self changeRightButtonTitleForMode:editMode];
    self.deleteButton.hidden = !editMode;
    for (UITextField* tf in self.textFields) {
        tf.enabled = editMode;
    }
}

- (void)changeRightButtonTitleForMode:(BOOL)editMode{
    if(editMode)
        self.navigationItem.rightBarButtonItem.title = kSaveTitle;
    else
        self.navigationItem.rightBarButtonItem.title = kEditTitle;
}

- (IBAction)save:(id)sender
{
    if([self.navigationItem.rightBarButtonItem.title isEqualToString:kSaveTitle])
        [self updateInfoForSalesPerson:self.salesPerson];
    else if([self.navigationItem.rightBarButtonItem.title isEqualToString:kEditTitle])
        [self setEditMode:YES];
}

- (BOOL)isMe:(SalesPerson*)sp{
    BOOL isMe;
    if(!sp)
        isMe = NO;
    else
        isMe = [[DataStore sharedInstance].salePersonsStore.user.user_id isEqualToString:sp.user_id];
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
