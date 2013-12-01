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
<
CBLUITableDelegate
>
{
    CBLUITableSource* dataSource;
    Contact* selectedContact;
}
@end

@implementation ContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[ContactCell class] forCellReuseIdentifier:kContactCellIdentifier];
    dataSource = [CBLUITableSource new];
    dataSource.tableView = self.tableView;
    self.tableView.dataSource = dataSource;
    [self updateQuery];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void) updateQuery {
    if(!self.filteredOpp)
        dataSource.query = [[[DataStore sharedInstance] queryContacts] asLiveQuery];
    else{
        dataSource.query = [[[DataStore sharedInstance] queryContactsByOpport:self.filteredOpp] asLiveQuery];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBLQueryRow *row = [dataSource rowAtIndex:indexPath.row];
    selectedContact = [Contact modelForDocument: row.document];
    
    [self performSegueWithIdentifier:@"presentContactDetails" sender:self];
}

- (UITableViewCell *)couchTableSource:(CBLUITableSource *)source cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kContactCellIdentifier];
    CBLQueryRow *row = [dataSource rowAtIndex:indexPath.row];
    Contact *contact = [Contact modelForDocument: row.document];
    cell.contact = contact;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController* navc = (UINavigationController*)segue.destinationViewController;
        if([navc.topViewController isKindOfClass:[ContactDetailsViewController class]]){
            ContactDetailsViewController* vc = (ContactDetailsViewController*)navc.topViewController;
            vc.currentContact = selectedContact;
        }
    }
}

@end
