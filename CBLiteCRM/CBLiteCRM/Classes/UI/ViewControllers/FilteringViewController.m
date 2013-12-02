//
//  FilteringViewController.m
//  CBLiteCRM
//
//  Created by Ruslan Musagitov on 01.12.13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "FilteringViewController.h"

@interface FilteringViewController ()

@end

@implementation FilteringViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){}
    return self;
}

- (void)updateQuery
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [CBLUITableSource new];
    self.dataSource.tableView = self.tableView;
    self.tableView.dataSource = self.dataSource;
    [self updateQuery];
    self.filteredSource = [NSMutableArray arrayWithCapacity:self.dataSource.rows.count];
}

//- (UITableViewCell *)couchTableSource:(CBLUITableSource *)source cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    ContactCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kContactCellIdentifier];
//    CBLQueryRow *row = [self.dataSource rowAtIndex:indexPath.row];
//    Contact *contact = [Contact modelForDocument: row.document];
//    cell.contact = contact;
//    return cell;
//}


@end
