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
    UIAlertView* relationalImpactAlertView;
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

- (void)initialize {
    contactsStore = [DataStore sharedInstance].contactsStore;
    opportunitiesStore = [DataStore sharedInstance].opportunitiesStore;
    deletionAlertView = [[UIAlertView alloc] initWithTitle:@"Delete item" message:@"Are you sure you want to remove item" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    relationalImpactAlertView = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
}

- (void)setItem:(CBLModel *)item
{
    _item = item;

    NSError* error;
    NSMutableString* msg = [NSMutableString new];

    relatedContactsQuery = [contactsStore queryContactsForCustomer:(Customer*)item];
    NSUInteger ctCount = [[relatedContactsQuery run:&error] count];
    if (ctCount > 0)
        [msg appendFormat:@"%u contacts", ctCount];

    relatedOpportunitiesQuery = [opportunitiesStore queryOpportunitiesForCustomer:(Customer*)item];
    NSUInteger oppCount = [[relatedOpportunitiesQuery run:&error] count];

    if (ctCount > 0 && oppCount > 0)
        [msg appendString:@" and "];
    if (oppCount > 0)
        [msg appendFormat:@"%u opportunities", oppCount];

    relationalImpactAlertView.message = [NSString stringWithFormat:@"%@ will be deleted", msg];
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
    if (alertView == deletionAlertView && buttonIndex == 1) {
        [relationalImpactAlertView show];
    } else if (alertView == relationalImpactAlertView && buttonIndex == 1) {
        NSError *error;
        [self deleteRelatedObjects];
        [self.item deleteDocument:&error];
        self.deleteAlertBlock(YES);
    }
}

@end
