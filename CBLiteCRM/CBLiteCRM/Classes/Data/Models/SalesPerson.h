//
//  SalesPerson.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "BaseModel.h"

@interface SalesPerson : CBLModel

/** The user_id is usually an email address. */
@property (strong) NSString* user_id;

@property (strong) NSString* username;
@property (strong) NSString* type;
@property (strong) NSString* email;
@property (strong) NSString* editableWorkaroundEmail; // need to removed after SyncManager refactoring and login process simplified
@property (strong) NSString* name;
@property (strong) NSString* phoneNumber;

@property bool approved;
@property bool isAdmin;

@property (readonly) NSString* personName;

- (instancetype) initInDatabase: (CBLDatabase*)database
                     withUserId: (NSString*)userId
                        andName: (NSString*)name;

@end
