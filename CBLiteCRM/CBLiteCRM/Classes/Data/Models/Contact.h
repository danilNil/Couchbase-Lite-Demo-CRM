//
//  Contact.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

@class Customer;
@interface Contact : CBLModel
@property (strong) Customer* customer;
@property (readonly, strong) NSString* name;
@property (readonly, strong) NSString* position;
@property (readonly, strong) NSString* phoneNumber;
@property (readonly, strong) NSString* email;
@property (readonly, strong) NSString* address;
@property (readonly, strong) NSArray* opportunities;
@property CBLAttachment* photo;
@end
