//
//  SalesPerson.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import <CouchbaseLite/CouchbaseLite.h>

@interface SalesPerson : CBLModel

@property (strong) NSString* username;
@property (strong) NSString* email;
@property (strong) NSString* phoneNumber;
@property bool approved;


+ (SalesPerson*) createInDatabase: (CBLDatabase*)database
              withUsername: (NSString*)username;
+ (NSString*) usernameFromDocID: (NSString*)docID;
+ (NSString*) docIDForUsername: (NSString*)username;

@end
