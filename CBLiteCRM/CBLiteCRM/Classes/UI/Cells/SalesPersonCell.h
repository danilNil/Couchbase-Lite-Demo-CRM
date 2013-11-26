//
//  SalesPersonCell.h
//  CBLiteCRM
//
//  Created by Ruslan on 11/26/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

extern NSString *kSalesPersonCell;

@class SalesPerson;

@interface SalesPersonCell : UITableViewCell

@property (weak, nonatomic) SalesPerson *salesPerson;

@property (nonatomic) BOOL checked;

@end
