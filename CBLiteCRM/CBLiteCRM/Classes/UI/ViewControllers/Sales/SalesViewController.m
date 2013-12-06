//
//  SalesViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

//UI
#import "SalesViewController.h"
#import "SalesPersonOptionsViewController.h"
#import "SalesPersonCell.h"

//Data
#import "DataStore.h"
#import "SalePersonsStore.h"
#import "SalesPerson.h"


@interface SalesViewController ()
@property(nonatomic, strong) SalesPerson* selectedCellData;

@end

@implementation SalesViewController

- (void) updateQuery
{
    self.dataSource.query = [[[DataStore sharedInstance].salePersonsStore allUsersQuery] asLiveQuery];
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
    self.selectedCellData = [self salesForPath:indexPath];
    [self performSegueWithIdentifier:@"presentSalesPersonOptions" sender:tableView];
}

- (SalesPerson*)salesForPath:(NSIndexPath*)indexPath{
    SalesPerson* sls;
    CBLQueryRow *row = [self.dataSource rowAtIndex:indexPath.row];
//    if (self.filteredSource.count == 0){
        sls = [SalesPerson modelForDocument: row.document];
//    } else {
//        sls = self.filteredSource[indexPath.row];
//    }
    return sls;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SalesPersonOptionsViewController *salesPersonOptionsViewController = [segue destinationViewController];
    salesPersonOptionsViewController.salesPerson =self.selectedCellData;
}

#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    CBLQuery *query = [[DataStore sharedInstance].salePersonsStore allUsersQuery];
    query.startKey = @[searchText];
    query.endKey = @[searchText, @{}];
    self.filteredDataSource.query = [query asLiveQuery];
//    [self.filteredSource removeAllObjects];
//    for (CBLQueryRow* row in self.dataSource.rows) {
//        SalesPerson *salesPerson = [SalesPerson modelForDocument:row.document];
//        if ([salesPerson.email rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
//            [self.filteredSource addObject:salesPerson];
//    }
}

@end
