//
//  Contact.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "Contact.h"

@implementation Contact
@dynamic customer, name, position, phoneNumber, email, address, opportunities;


+ (NSString*) docIDForEmail: (NSString*)mail {
    return [super docIDForUniqueField:mail forDocType:kContactDocType];
}

+ (NSString*) emailFromDocID: (NSString*)docID{
    return [super uniqueFieldFromDocID:docID forDocType:kContactDocType];
}

+ (Contact*) createInDatabase: (CBLDatabase*)database
                     withEmail: (NSString*)mail
{
    Contact* profile = [super createInDatabase:database withUniqueField:mail andDocType:kContactDocType];
    [profile setValue: mail ofProperty: @"email"];
    NSError* error;
    if (![profile save: &error])
        return nil;
    return profile;
}
@end
