//
//  CustomersViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

//UI
#import "CustomersViewController.h"
#import "CustomerDetailsViewController.h"

//Data
#import "DataStore.h"
#import "CustomersStore.h"
#import "Customer.h"

@interface CustomersViewController ()
<
CBLUITableDelegate
>
@property(nonatomic, strong) Customer* selectedCellData;

@end

@implementation CustomersViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.modelClass = [Customer class];
    self.searchableProperty = @"companyName";
    [self updateUIForState:self.chooser];
    self.filteredDataSource.labelProperty = self.searchableProperty;
}

- (void)updateUIForState:(BOOL)chooser{
    if(chooser) {
//        self.navigationItem.rightBarButtonItem
        UIBarButtonItem *btn = self.navigationItem.rightBarButtonItem;

//        btn.enabled = NO;
//        NSLog(@"%@", NSStringFromCGRect([btn frame]));
    }
}

- (void) updateQuery
{
    self.store = [DataStore sharedInstance].customersStore;
    self.dataSource.query = [[(CustomersStore*)self.store allCustomersQuery] asLiveQuery];
}

- (void)didChooseCustomer:(Customer*)cust{
    self.onSelectCustomer(cust);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCellData = [self customerForPath:indexPath];
    if(self.chooser && self.onSelectCustomer)
        [self didChooseCustomer:self.selectedCellData];
    else
        [self performSegueWithIdentifier:@"presentCustomerDetails" sender:self];
}

- (Customer*)customerForPath:(NSIndexPath*)indexPath{
    Customer* csmr;
    CBLQueryRow *row = [self.currentSource rowAtIndex:indexPath.row];
    csmr = [Customer modelForDocument: row.document];
    return csmr;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]] && sender == self){
        CustomerDetailsViewController* vc = (CustomerDetailsViewController*)((UINavigationController*)segue.destinationViewController).topViewController;
        vc.currentCustomer = self.selectedCellData;
    }
}

@end
