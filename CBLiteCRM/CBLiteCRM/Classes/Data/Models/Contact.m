//
//  Contact.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "Contact.h"
#import "OpportunityForContactStore.h"
#import "ContactOpportunity.h"
#import "DataStore.h"

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

- (BOOL)deleteDocument: (NSError**)outError
{
    OpportunityForContactStore *oppCtStore = [DataStore sharedInstance].opportunityContactStore;
    CBLQuery *q = [oppCtStore queryOpportunitiesForContact:self];
    NSError *er;
    for (CBLQueryRow *r in [q rows:&er]) {
        ContactOpportunity *ctOpp = [ContactOpportunity modelForDocument:r.document];
        [ctOpp deleteDocument:&er];
        [ctOpp save:&er];
    }
    return [super deleteDocument:outError];
}

- (UIImage*)photo
{
    NSData * photoData = [[self attachmentNamed:@"photo"] content];

    return [UIImage imageWithData:photoData];
}

@end
