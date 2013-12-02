//
//  SalesViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "SalesViewController.h"
#import "DataStore.h"
#import "SalesPerson.h"
#import "SalesPersonOptionsViewController.h"
#import "SalesPerson.h"
#import "SalesPersonCell.h"

@interface SalesViewController ()

@end

@implementation SalesViewController

- (void) updateQuery
{
    self.dataSource.query = [[[DataStore sharedInstance] allUsersQuery] asLiveQuery];
}

- (UITableViewCell *)couchTableSource:(CBLUITableSource*)source cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesPersonCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kSalesPersonCell];
    CBLQueryRow *row = [self.dataSource rowAtIndex:indexPath.row];
    SalesPerson *salesPerson = [SalesPerson modelForDocument: row.document];
    cell.salesPerson = salesPerson;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:kSalesPersonCell];
    SalesPerson *salesPerson;
    salesPerson = self.filteredSource[indexPath.row];
    cell.salesPerson = salesPerson;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"presentSalesPersonOptions" sender:tableView];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SalesPersonOptionsViewController *salesPersonOptionsViewController = [segue destinationViewController];
    if(sender == self.searchDisplayController.searchResultsTableView) {
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        salesPersonOptionsViewController.salesPerson = self.filteredSource[indexPath.row];
    } else {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CBLQueryRow *row = [self.dataSource rowAtIndex:indexPath.row];
        SalesPerson *salesPerson = [SalesPerson modelForDocument: row.document];
        salesPersonOptionsViewController.salesPerson = salesPerson;
    }
}

#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.filteredSource removeAllObjects];
    for (CBLQueryRow* row in self.dataSource.rows) {
        SalesPerson *salesPerson = [SalesPerson modelForDocument:row.document];
        if ([salesPerson.email rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
            [self.filteredSource addObject:salesPerson];
    }
}

@end
