//
//  FilteringViewController.m
//  CBLiteCRM
//
//  Created by Ruslan Musagitov on 01.12.13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "FilteringViewController.h"

@interface FilteringViewController ()

@property (nonatomic, strong) CBLUITableSource* dataSource;

@end

@implementation FilteringViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self.searchDisplayController.searchResultsTableView registerClass:[self.cellClass class] forCellReuseIdentifier:self.cellIdentifier];
        [self.tableView registerClass:[self.cellClass class] forCellReuseIdentifier:self.cellIdentifier];
        self.dataSource = [CBLUITableSource new];
        self.dataSource.tableView = self.tableView;
        self.tableView.dataSource = self.dataSource;
        [self updateQuery];
        self.filteredSource = [NSMutableArray arrayWithCapacity:self.dataSource.rows.count];
    }
    return self;
}

- (void)updateQuery
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


@end
