//
//  SalesPerson.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "SalesPerson.h"

@implementation SalesPerson
@dynamic username, phoneNumber, email, approved, user_id, type, isAdmin;

- (NSString*) personName
{
    if        (self.name)
        return self.name;
    return self.username;
}

- (instancetype) initInDatabase: (CBLDatabase*)database
                     withUserId: (NSString*)userId
                        andName: (NSString*)name

{
    NSParameterAssert(userId);
    
    if(!name)
        name = userId;
    
    self = [self initInDatabase:database withEmail:userId];
    if (self) {
        self.user_id  = userId;
        self.username = userId;
        self.name     = name;
    }
    NSError* error;
    if (![self save: &error]){
        NSLog(@"error: %@", error);
        return nil;
    }
    return self;
}

- (instancetype) initInDatabase: (CBLDatabase*)database
                      withEmail: (NSString*)mail
{
    NSParameterAssert(mail);
    NSString* docID = [[self class] docIDForUserId:mail];
    CBLDocument* doc = [database existingDocumentWithID:docID];
    if(!doc){
        doc = [database documentWithID: docID];
    }
    self = doc.modelObject;

    if(!self)
        self = [SalesPerson modelForDocument:doc];

    if (self) {
        NSLog(@"[[self class] type]: %@",[[self class] type]);
        self.type = [[self class] type];
        self.email = mail;
    }
    return self;
}

+ (NSString*) docIDForUserId: (NSString*)userId {
    return [self docIDForUniqueField:userId forDocType:[self type]];
}

+ (NSString*) userIdFromDocID: (NSString*)docID{
    return [self uniqueFieldFromDocID:docID forDocType:[self type]];
}


+ (NSString*) type{
    return kSalesPersonDocType;
}

+ (NSString*) docIDForUniqueField: (NSString*)uniqueValue forDocType:(NSString*)type{
    return [NSString stringWithFormat:@"%@:%@",type,uniqueValue];
}

+ (NSString*) uniqueFieldFromDocID: (NSString*)docID forDocType:(NSString*)type{
    return [docID substringFromIndex:type.length+1];
}




@end
