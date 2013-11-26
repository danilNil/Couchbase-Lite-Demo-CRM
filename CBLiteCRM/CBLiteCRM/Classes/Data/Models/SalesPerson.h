//
//  SalesPerson.h
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import <CouchbaseLite/CouchbaseLite.h>

@interface SalesPerson : CBLModel

@property (strong) NSString* name;
@property (strong) NSString* email;
@property (strong) NSString* phoneNumber;
@property bool approved;

@end
