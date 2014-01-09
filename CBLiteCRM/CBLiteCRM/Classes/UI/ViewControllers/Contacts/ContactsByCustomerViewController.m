//
//  ContactsByCustomerViewController.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/30/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "ContactsByCustomerViewController.h"
#import "ContactDetailsViewController.h"
#import "DataStore.h"
#import "ContactsStore.h"
#import "Contact.h"

@implementation ContactsByCustomerViewController

- (void)updateQuery
{
    [super updateQuery];
    self.dataSource.query = [[(ContactsStore*)self.store queryContactsForCustomer:self.customer] asLiveQuery];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]] && sender == self){
        UINavigationController* navc = (UINavigationController*)segue.destinationViewController;
        if([navc.topViewController isKindOfClass:[ContactDetailsViewController class]]){
            ContactDetailsViewController* vc = (ContactDetailsViewController*)navc.topViewController;
            vc.enabledForEditing = NO;
            vc.currentContact = super.selectedContact;
        }
    }
}

@end
