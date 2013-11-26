//
//  SalesPersonCell.h
//  CBLiteCRM
//
//  Created by Ruslan on 11/26/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

extern NSString *kSalesPersonCell;

@interface SalesPersonCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *name;

@property (nonatomic) BOOL checked;

@end
