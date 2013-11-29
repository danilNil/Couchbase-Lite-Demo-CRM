//
//  SalesPerson.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "SalesPerson.h"

@implementation SalesPerson
@dynamic username, phoneNumber, email, approved;

+ (NSString*) docType{
    return kContactDocType;
}

+ (NSString*) docIDForEmail: (NSString*)mail {
    return [super docIDForUniqueField:mail forDocType:[self docType]];
}

+ (NSString*) emailFromDocID: (NSString*)docID{
    return [super uniqueFieldFromDocID:docID forDocType:[self docType]];
}


+ (SalesPerson*) createInDatabase: (CBLDatabase*)database
              withEmail: (NSString*)mail
{

    SalesPerson* profile = [super createInDatabase:database withUniqueField:mail andDocType:[self docType]];
    [profile setValue: mail ofProperty: @"email"];
    
    NSError* error;
    if (![profile save: &error])
        return nil;
    return profile;
}

@end
