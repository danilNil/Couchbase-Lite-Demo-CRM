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

+ (Contact*) createInDatabase: (CBLDatabase*)database
                 withEmail: (NSString*)username;
+ (NSString*) emailFromDocID: (NSString*)docID;
+ (NSString*) docIDForEmail: (NSString*)mail;

@end
