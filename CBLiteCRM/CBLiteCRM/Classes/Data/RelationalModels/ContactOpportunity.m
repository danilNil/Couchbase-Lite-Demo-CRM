//
//  ContactOpportunity.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/9/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "ContactOpportunity.h"
#import "Constants.h"

@implementation ContactOpportunity
@dynamic contact, opportunity;

- (instancetype) initInDatabase: (CBLDatabase*)database
                    withContact: (Contact*)ct
                 andOpportunity:(Opportunity*)opp;
{
    self = [super initWithNewDocumentInDatabase:database];
    if(self){
        [self setValue: [[self class] docType] ofProperty: @"type"];
        [self setValue:ct forKey:@"contact"];
        [self setValue:opp forKey:@"opportunity"];
    }
    NSError* error;
    if (![self save: &error])
        return nil;
    return self;
}


+ (NSString*) docType{
    return kContactOpportunityDocType;
}


@end
