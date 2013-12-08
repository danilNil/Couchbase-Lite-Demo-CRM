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
    SalesPersonCell *cell = [[source tableView] dequeueReusableCellWithIdentifier:kSalesPersonCell];
    CBLQueryRow *row = [source rowAtIndex:indexPath.row];
    SalesPerson *salesPerson = [SalesPerson modelForDocument: row.document];
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
        sls = [SalesPerson modelForDocument: row.document];
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
    NSError *err;
    CBLQuery *query = [[DataStore sharedInstance].salePersonsStore filteredQuery];
    CBLQueryEnumerator *enumer = [query rows:&err];
    NSLog(@"%u", [[query rows:&err] count]);

    NSMutableArray *matches = [NSMutableArray new];
    for (NSUInteger i = 0; i < enumer.count; i++) {
        CBLQueryRow* row = [enumer rowAtIndex:i];
        SalesPerson* sp = [SalesPerson modelForDocument:row.document];
        if ([sp.email rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
            [matches addObject:sp.email];
    }
    query.keys = matches;
    NSLog(@"%u", [[query rows:&err] count]);
    self.filteredDataSource.query = [query asLiveQuery];
}

@end
