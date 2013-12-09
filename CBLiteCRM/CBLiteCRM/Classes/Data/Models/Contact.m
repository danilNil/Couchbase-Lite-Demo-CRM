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

+ (NSString*) docType{
   return kContactDocType;
}

- (instancetype) initInDatabase: (CBLDatabase*)database
                  withEmail: (NSString*)mail
{
    NSParameterAssert(mail);
    self = [super initInDatabase:database];
    if(self){
        [self setValue: mail ofProperty: @"email"];
    }

    NSError* error;
    if (![self save: &error])
        return nil;
    return self;
}
@end
