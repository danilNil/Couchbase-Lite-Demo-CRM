//
//  SalesPerson.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "BaseModel.h"

@interface SalesPerson : CBLModel

/** The user_id is usually an email address. */
@property (readwrite) NSString* user_id;

@property (readwrite) NSString* username;
@property (readwrite) NSString* email;
@property (readwrite) NSString* phoneNumber;
@property bool approved;


- (instancetype) initInDatabase: (CBLDatabase*)database
                      withEmail: (NSString*)mail
                      andUserID: (NSString*)userId;
- (instancetype) initInDatabase: (CBLDatabase*)database
                      withEmail: (NSString*)mail;
+ (NSString*) userIdFromDocID: (NSString*)docID;
+ (NSString*) docIDForUserId: (NSString*)mail;

@end
