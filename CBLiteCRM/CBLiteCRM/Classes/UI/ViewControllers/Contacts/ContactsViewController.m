//
//  ContactsViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactDetailsViewController.h"
#import "DataStore.h"
#import "Contact.h"
#import "ContactCell.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView reloadData];
}

- (void) updateQuery
{
    if(!self.filteredOpp)
        self.dataSource.query = [[[DataStore sharedInstance] queryContacts] asLiveQuery];
    else
        self.dataSource.query = [[[DataStore sharedInstance] queryContactsByOpport:self.filteredOpp] asLiveQuery];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:kContactCellIdentifier forIndexPath:indexPath];
    Contact *contact;
    contact = self.filteredSource[indexPath.row];
    cell.contact = contact;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"presentContactDetails" sender:self];
}

- (UITableViewCell *)couchTableSource:(CBLUITableSource *)source cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kContactCellIdentifier];
    CBLQueryRow *row = [self.dataSource rowAtIndex:indexPath.row];
    Contact *contact = [Contact modelForDocument: row.document];
    cell.contact = contact;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController* navc = (UINavigationController*)segue.destinationViewController;
        if([navc.topViewController isKindOfClass:[ContactDetailsViewController class]]){
            ContactDetailsViewController* vc = (ContactDetailsViewController*)navc.topViewController;
            CBLQueryRow *row = [self.dataSource rowAtIndex:[self.tableView indexPathForSelectedRow].row];
            vc.currentContact = [Contact modelForDocument: row.document];
        }
    }
}

#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self.filteredSource removeAllObjects];
    for (CBLQueryRow* row in self.dataSource.rows) {
        Contact *contact = [Contact modelForDocument:row.document];
        if ([contact.email rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
            [self.filteredSource addObject:contact];
    }
}

@end
