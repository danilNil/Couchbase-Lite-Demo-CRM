//
//  ContactsByCustomerViewController.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/30/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "ContactsByCustomerViewController.h"
#import "DataStore.h"
#import "ContactsStore.h"
#import "Contact.h"

@interface ContactsByCustomerViewController ()

@end

@implementation ContactsByCustomerViewController

- (void)updateQuery
{
    self.dataSource.query = [[(ContactsStore*)self.store queryContactsForCustomer:self.customer] asLiveQuery];
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    CBLQueryRow *row = [self.currentSource rowAtIndex:indexPath.row];
//    self.selectedContact = [Contact modelForDocument: row.document];
//    if(self.chooser && self.onSelectContact)
//        [self didChooseContact:self.selectedContact];
//    else
//        [self performSegueWithIdentifier:@"presentContactDetails" sender:self];
//}

@end
