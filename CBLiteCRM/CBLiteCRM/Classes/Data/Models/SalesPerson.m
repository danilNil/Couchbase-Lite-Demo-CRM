//
//  SalesPerson.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "SalesPerson.h"

@implementation SalesPerson
@dynamic username, phoneNumber, email, approved, user_id, type, isAdmin;

- (instancetype) initInDatabase: (CBLDatabase*)database
                   withUserName: (NSString*)username
                      andMail: (NSString*)mail
{
    NSParameterAssert(username);
    NSParameterAssert(mail);
    
    self = [self initInDatabase:database withEmail:mail];
    if (self) {
        self.user_id = mail;
        self.username = username;
        self.approved = NO;
        self.isAdmin = NO;
    }
    return self;
}

- (instancetype) initInDatabase: (CBLDatabase*)database
                      withEmail: (NSString*)mail
{
    NSParameterAssert(mail);
    NSString* docID = [[self class] docIDForUserId:mail];
    CBLDocument* doc = [database existingDocumentWithID:docID];
    if(doc){
        self = doc.modelObject;
    }else{
        doc = [database documentWithID: docID];
        self = [super initWithDocument:doc];
    }
    
    if (self) {
        self.type = [[self class] docType];
        self.email = mail;
    }
    return self;
}

+ (NSString*) docIDForUserId: (NSString*)userId {
    return [self docIDForUniqueField:userId forDocType:[self docType]];
}

+ (NSString*) userIdFromDocID: (NSString*)docID{
    return [self uniqueFieldFromDocID:docID forDocType:[self docType]];
}


+ (NSString*) docType{
    return kSalesPersonDocType;
}

+ (NSString*) docIDForUniqueField: (NSString*)uniqueValue forDocType:(NSString*)docType{
    return [NSString stringWithFormat:@"%@:%@",docType,uniqueValue];
}

+ (NSString*) uniqueFieldFromDocID: (NSString*)docID forDocType:(NSString*)docType{
    return [docID substringFromIndex:docType.length+1];
}




@end
