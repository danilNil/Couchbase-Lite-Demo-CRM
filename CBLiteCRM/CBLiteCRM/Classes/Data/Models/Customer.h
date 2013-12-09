//
//  Customer.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "BaseModel.h"

@interface Customer : BaseModel
@property (copy, readonly) NSString* companyName;
@property (copy) NSString* industry;
@property (copy) NSString* phone;
@property (copy) NSString* email;
@property (copy) NSString* websiteUrl;
@property (copy) NSString* address;


- (instancetype) initInDatabase: (CBLDatabase*)database
                  withCustomerName: (NSString*)name;

@end
