//
//  Contact.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//
#import "BaseModel.h"

@class Customer;
@interface Contact : BaseModel
@property (weak) Customer* customer;
@property (copy) NSString* name;
@property (copy) NSString* position;
@property (copy) NSString* phoneNumber;
@property (readonly, copy) NSString* email;
@property (copy) NSString* address;
@property (copy) NSArray* opportunities;

- (instancetype) initInDatabase: (CBLDatabase*)database
                 withEmail: (NSString*)mail;


@end
