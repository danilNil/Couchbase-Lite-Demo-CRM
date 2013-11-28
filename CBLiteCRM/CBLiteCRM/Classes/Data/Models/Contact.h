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
@property (strong) NSString* name;
@property (strong) NSString* position;
@property (strong) NSString* phoneNumber;
@property (readonly, strong) NSString* email;
@property (strong) NSString* address;
@property (strong) NSArray* opportunities;

+ (Contact*) createInDatabase: (CBLDatabase*)database
                 withUsername: (NSString*)username;
+ (NSString*) usernameFromDocID: (NSString*)docID;
+ (NSString*) docIDForUsername: (NSString*)username;

@end
