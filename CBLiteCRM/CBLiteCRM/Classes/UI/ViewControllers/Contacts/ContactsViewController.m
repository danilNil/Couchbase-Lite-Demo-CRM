//
//  ContactsViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

//UI
#import "ContactsViewController.h"
#import "ContactDetailsViewController.h"
#import "ContactCell.h"

//Data
#import "DataStore.h"
#import "ContactsStore.h"
#import "Contact.h"


@interface ContactsViewController ()
@property(nonatomic, strong) Contact* selectedContact;
@end

@implementation ContactsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void) updateQuery
{
    if(!self.filteredOpp)
        self.dataSource.query = [[[DataStore sharedInstance].contactsStore queryContacts] asLiveQuery];
    else
        self.dataSource.query = [[[DataStore sharedInstance].contactsStore queryContactsByOpport:self.filteredOpp] asLiveQuery];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBLQueryRow *row = [self.dataSource rowAtIndex:indexPath.row];
    self.selectedContact = [Contact modelForDocument: row.document];
    [self performSegueWithIdentifier:@"presentContactDetails" sender:self];
}

- (UITableViewCell *)couchTableSource:(CBLUITableSource *)source cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = [[source tableView] dequeueReusableCellWithIdentifier:kContactCellIdentifier];
    CBLQueryRow *row = [source rowAtIndex:indexPath.row];
    Contact *contact = [Contact modelForDocument: row.document];
    cell.contact = contact;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]] && sender == self){
        UINavigationController* navc = (UINavigationController*)segue.destinationViewController;
        if([navc.topViewController isKindOfClass:[ContactDetailsViewController class]]){
            ContactDetailsViewController* vc = (ContactDetailsViewController*)navc.topViewController;
            vc.currentContact = self.selectedContact;
        }
    }
}

#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {   
    NSError *err;
    CBLQuery *query = [[DataStore sharedInstance].contactsStore filteredQuery];
    CBLQueryEnumerator *enumer = [query rows:&err];
    NSLog(@"%u", [[query rows:&err] count]);
    
    NSMutableArray *matches = [NSMutableArray new];
    for (NSUInteger i = 0; i < enumer.count; i++) {
        CBLQueryRow* row = [enumer rowAtIndex:i];
        Contact* ct = [Contact modelForDocument:row.document];
        if ([ct.email rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
            [matches addObject:ct.email];
    }
    query.keys = matches;
    NSLog(@"%u", [[query rows:&err] count]);
    self.filteredDataSource.query = [query asLiveQuery];

    
}

@end
