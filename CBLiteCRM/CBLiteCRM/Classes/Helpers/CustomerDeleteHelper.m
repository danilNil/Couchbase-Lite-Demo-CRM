//
//  CustomerDeleteHelper.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/27/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "CustomerDeleteHelper.h"
#import "ContactsStore.h"
#import "OpportunitiesStore.h"
#import "DataStore.h"

@interface CustomerDeleteHelper ()
{
    UIAlertView* deletionAlertView;
    ContactsStore* contactsStore;
    OpportunitiesStore* opportunitiesStore;
    CBLQuery* relatedContactsQuery;
    CBLQuery* relatedOpportunitiesQuery;
}
@end

@implementation CustomerDeleteHelper
@synthesize item = _item;

- (id)initWithItem:(CBLModel*)item
{
    self = [super init];
    if (self) {
        _item = item;
        [self initialize];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    contactsStore = [DataStore sharedInstance].contactsStore;
    opportunitiesStore = [DataStore sharedInstance].opportunitiesStore;
    deletionAlertView = [[UIAlertView alloc] initWithTitle:@"Delete item" message:@"Are you sure you want to remove item" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
}

- (void)setItem:(CBLModel *)item
{
    _item = item;
    [self setDeleteMessageForItem:item];
}

- (void)setDeleteMessageForItem:(CBLModel *)item
{
    NSError* error;
    NSMutableString* msg = [NSMutableString new];
    relatedContactsQuery = [contactsStore queryContactsForCustomer:(Customer*)item];
    NSUInteger ctCount = [[relatedContactsQuery run:&error] count];

    relatedOpportunitiesQuery = [opportunitiesStore queryOpportunitiesForCustomer:(Customer*)item];
    NSUInteger oppCount = [[relatedOpportunitiesQuery run:&error] count];

    if (ctCount == 1)
        [msg appendFormat:@"%u contact", ctCount];
    else if (ctCount > 1)
        [msg appendFormat:@"%u contacts", ctCount];

    if (ctCount > 0 && oppCount > 0)
        [msg appendString:@" and "];
    if (oppCount == 1)
        [msg appendFormat:@"%u opportunity", oppCount];
    else if (oppCount > 1)
        [msg appendFormat:@"%u opportunities", oppCount];

    if (oppCount + ctCount > 0)
        deletionAlertView.message = [NSString stringWithFormat:@"Are you sure you want to remove item.\nAlso %@ will be deleted", msg];
    else
        deletionAlertView.message = @"Are you sure you want to remove item";
}

- (void)showDeletionAlert
{
    [deletionAlertView show];
}

- (void)deleteRelatedObjects
{
    [self deleteRelatedContacts];
    [self deleteRelatedOpportunities];
}

- (void)deleteRelatedContacts
{
    NSError* error;
    for (CBLQueryRow* row in [relatedContactsQuery run:&error])
        [row.document deleteDocument:&error];
}

- (void)deleteRelatedOpportunities
{
    NSError* error;
    for (CBLQueryRow* row in [relatedOpportunitiesQuery run:&error])
        [row.document deleteDocument:&error];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSError *error;
        [self deleteRelatedObjects];
        [self.item deleteDocument:&error];
        self.deleteAlertBlock(YES);
    }
}

@end
