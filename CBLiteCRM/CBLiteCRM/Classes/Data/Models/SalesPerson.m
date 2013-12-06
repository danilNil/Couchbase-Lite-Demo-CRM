//
//  SalesPerson.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "SalesPerson.h"

@implementation SalesPerson
@dynamic username, phoneNumber, email, approved, user_id;

- (instancetype) initInDatabase: (CBLDatabase*)database
                      withEmail: (NSString*)mail
                      andUserID: (NSString*)userId
{
    NSParameterAssert(mail);
    NSParameterAssert(userId);
    
    
    CBLDocument* doc = [database documentWithID: [[self class] docIDForUserId:userId]];
    
    self = [super initWithDocument:doc];
    if (self) {
        self.email = mail;
        self.user_id = userId;
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


- (instancetype) initInDatabase: (CBLDatabase*)database
                    withEmail: (NSString*)mail
{

    CBLDocument* doc = [database documentWithID: [[self class] docIDForUserId:mail]];

    self = [super initWithDocument:doc];
    if (self) {
        // The "type" property identifies what type of document this is.
        // It's used in map functions and by the CBLModelFactory.
        [self setValue: [[self class] docType] ofProperty: @"type"];
        self.email = mail;
    }
    return self;
}

@end
