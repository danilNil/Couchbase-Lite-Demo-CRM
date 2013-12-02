//
//  SalesPerson.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "BaseModel.h"

@interface SalesPerson : BaseModel

@property (strong) NSString* username;
@property (strong, readonly) NSString* email;
@property (strong) NSString* phoneNumber;
@property bool approved;


+ (SalesPerson*) createInDatabase: (CBLDatabase*)database
              withEmail: (NSString*)mail;
+ (NSString*) emailFromDocID: (NSString*)docID;
+ (NSString*) docIDForEmail: (NSString*)mail;

@end
