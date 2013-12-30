//
//  SalesViewController.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "FilteringViewController.h"
#import "LogoutProtocol.h"
#import "UIViewController+TableViewReadOnlyOrWriteMode.h"

@interface SalesViewController : FilteringViewController<LogoutProtocol, EditableTableViewControllers>

@end
