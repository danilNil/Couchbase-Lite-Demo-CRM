//
//  FilteringViewController.h
//  CBLiteCRM
//
//  Created by Ruslan Musagitov on 01.12.13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

@interface FilteringViewController : UIViewController 
<
UITableViewDelegate,
UISearchBarDelegate,
UISearchDisplayDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *filteredSource;
@property (nonatomic, strong) CBLUITableSource* dataSource;

@end
