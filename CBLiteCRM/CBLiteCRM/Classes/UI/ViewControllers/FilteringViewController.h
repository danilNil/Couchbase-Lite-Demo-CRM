//
//  FilteringViewController.h
//  CBLiteCRM
//
//  Created by Ruslan Musagitov on 01.12.13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

@interface FilteringViewController : UIViewController

@property Class cellClass;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *filteredSource;

@end
