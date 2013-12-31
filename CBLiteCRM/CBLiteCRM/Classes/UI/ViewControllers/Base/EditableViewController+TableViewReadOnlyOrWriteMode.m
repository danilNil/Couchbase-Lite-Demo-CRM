//
//  UIViewController+TableViewReadOnlyOrWriteMode.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/30/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "EditableViewController+TableViewReadOnlyOrWriteMode.h"
@implementation EditableViewController (TableViewReadOnlyOrWriteMode)


- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.enabledForEditing)
        return UITableViewCellEditingStyleDelete;
    return UITableViewCellEditingStyleNone;
}

@end
