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

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.modelClass = [Contact class];
    self.firstLevelSearchableProperty = @"email";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateQuery];
    [self.tableView reloadData];
}

- (void) updateQuery
{
    self.store = [DataStore sharedInstance].contactsStore;
    if (self.filteringOpportunity)
        self.dataSource.query = [[(ContactsStore*)self.store queryContactsForOpportunity:self.filteringOpportunity] asLiveQuery];
    else if(self.filteredCustomer)
        self.dataSource.query = [[(ContactsStore*)self.store queryContactsByCustomer:self.filteredCustomer] asLiveQuery];
    else
        self.dataSource.query = [[(ContactsStore*)self.store queryContacts] asLiveQuery];
}

- (void)didChooseContact:(Contact*)ct{
    self.onSelectContact(ct);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBLQueryRow *row = [self.currentSource rowAtIndex:indexPath.row];
    self.selectedContact = [Contact modelForDocument: row.document];
    if(self.chooser && self.onSelectContact)
        [self didChooseContact:self.selectedContact];
    else
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

@end
