//
//  CustomersViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

//UI
#import "CustomersViewController.h"
#import "CustomerDetailsViewController.h"

//Data
#import "DataStore.h"
#import "CustomersStore.h"
#import "Customer.h"
#import "CBLModel+DeleteHelper.h"

@interface CustomersViewController ()
<
CBLUITableDelegate
>
@property(nonatomic, strong) Customer* selectedCellData;
@property (nonatomic, weak) CustomersStore* store;

@end

@implementation CustomersViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.modelClass = [Customer class];
    self.firstLevelSearchableProperty = @"companyName";
    self.filteredDataSource.labelProperty = self.firstLevelSearchableProperty;
}

- (void) updateQuery
{
    self.store = [DataStore sharedInstance].customersStore;
    self.dataSource.query = [[self.store allCustomersQuery] asLiveQuery];
}

- (void)didChooseCustomer:(Customer*)cust{
    self.onSelectCustomer(cust);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedCellData = [self customerForPath:indexPath];
    if(self.chooser && self.onSelectCustomer)
        [self didChooseCustomer:self.selectedCellData];
    else
        [self performSegueWithIdentifier:@"presentCustomerDetails" sender:self];
}

- (Customer*)customerForPath:(NSIndexPath*)indexPath
{
    CBLQueryRow *row = [self.currentSource rowAtIndex:indexPath.row];
    return [Customer modelForDocument: row.document];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]] && sender == self){
        CustomerDetailsViewController* vc = (CustomerDetailsViewController*)((UINavigationController*)segue.destinationViewController).topViewController;
        vc.currentCustomer = self.selectedCellData;
    }
}

- (bool)couchTableSource:(CBLUITableSource *)source deleteRow:(CBLQueryRow *)row
{
//    Customer* customer = [Customer modelForDocument:row.document];
//    customer.deleteAlertBlock = [self createOnDeleteBlock];
//    [customer showDeletionAlert];
    NSError* error;
    return [[Customer modelForDocument:row.document] deleteDocument:&error];
}

-(DeleteBlock)createOnDeleteBlock
{
    __weak typeof(self) weakSelf = self;
    return ^(BOOL shouldDelete){
        if (shouldDelete)
            [weakSelf.currentSource.tableView reloadData];
    };
}

@end
