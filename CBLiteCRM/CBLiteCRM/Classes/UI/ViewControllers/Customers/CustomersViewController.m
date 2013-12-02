//
//  CustomersViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "CustomersViewController.h"
#import "CustomerDetailsViewController.h"
#import "DataStore.h"
#import "Customer.h"

@interface CustomersViewController ()
<
UITableViewDelegate,
UISearchBarDelegate,
UISearchDisplayDelegate
>

@end

@implementation CustomersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) updateQuery
{
    self.dataSource.query = [[[DataStore sharedInstance] allCustomersQuery] asLiveQuery];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerCell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomerCell"];

    Customer *customer = self.filteredSource[indexPath.row];
    cell.textLabel.text = customer.companyName;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"presentCustomerDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[CustomerDetailsViewController class]] && [sender isKindOfClass:[CustomersViewController class]]){
        CustomerDetailsViewController* vc = segue.destinationViewController;
        Customer *customer;
        if (self.filteredSource.count == 0) {
            CBLQueryRow *row = [self.dataSource rowAtIndex:[self.tableView indexPathForSelectedRow].row];
            customer = [Customer modelForDocument: row.document];
        } else {
            customer = self.filteredSource[[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow].row];
        }
        vc.currentCustomer = customer;
    }
}

#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self.filteredSource removeAllObjects];
    for (CBLQueryRow* row in self.dataSource.rows) {
        Customer *customer = [Customer modelForDocument:row.document];
        if ([customer.companyName rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
            [self.filteredSource addObject:customer];
    }
}

#pragma mark - UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
    [self.tableView reloadData];
}


@end
