//
//  ContactsViewController.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//
@class Opportunity;
@interface ContactsViewController : UIViewController<UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Opportunity* filteredOpp;
@end
