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
#import "AppDelegate.h"
//Data
#import "DataStore.h"
#import "SalePersonsStore.h"
#import "SalesPerson.h"


@interface SalesViewController ()
@property(nonatomic, strong) SalesPerson* selectedCellData;
@end

@implementation SalesViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.modelClass = [SalesPerson class];
    self.firstLevelSearchableProperty = @"email";
}
- (void) updateQuery
{
    self.store = [DataStore sharedInstance].salePersonsStore;
    self.dataSource.query = [[(SalePersonsStore*)self.store allUsersQuery] asLiveQuery];
}

- (UITableViewCell *)couchTableSource:(CBLUITableSource*)source cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SalesPersonCell *cell = [[source tableView] dequeueReusableCellWithIdentifier:kSalesPersonCell];
    CBLQueryRow *row = [source rowAtIndex:indexPath.row];
    SalesPerson *salesPerson = [SalesPerson modelForDocument: row.document];
    cell.salesPerson = salesPerson;
    cell.checkmark.hidden = ![[DataStore sharedInstance] salePersonsStore].user.isAdmin;
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    CBLQueryRow *row = [self.dataSource rowAtIndex:indexPath.row];
    BOOL isMe = [self isRowMe:row];
    return isMe;
}

- (bool)couchTableSource:(CBLUITableSource*)source
               deleteRow:(CBLQueryRow*)row{
    SalesPerson *salesPerson = [SalesPerson modelForDocument: row.document];
    BOOL isMe = [self isRowMe:row];
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    [app logout];
    NSError* err;
    [salesPerson deleteDocument:&err];
    if(err){
        NSLog(@"err in deleting: %@", err);
    }
    return isMe;
}

- (BOOL)isRowMe:(CBLQueryRow*)row{
    SalesPerson *salesPerson = [SalesPerson modelForDocument: row.document];
    BOOL isMe = [[DataStore sharedInstance].salePersonsStore.user.user_id isEqualToString:salesPerson.user_id];
    return isMe;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedCellData = [self salesForPath:indexPath];
    [self performSegueWithIdentifier:@"presentSalesPersonOptions" sender:tableView];
}

- (SalesPerson*)salesForPath:(NSIndexPath*)indexPath{
    SalesPerson* sls;
    CBLQueryRow *row = [self.currentSource rowAtIndex:indexPath.row];
    sls = [SalesPerson modelForDocument: row.document];
    return sls;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SalesPersonOptionsViewController *salesPersonOptionsViewController = [segue destinationViewController];
    salesPersonOptionsViewController.salesPerson = self.selectedCellData;
}

@end
