//
//  Opportunity.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "Opportunity.h"

@implementation Opportunity
@dynamic customer, creationDate, revenueSize, winProbability, salesStage, contacts, title;


+ (NSString*) docType{
    return kOpportDocType;
}

+ (NSString*)docIDForTitle:(NSString*)title{
    return [super docIDForUniqueField:title forDocType:[self docType]];
}

+ (NSString*) titleFromDocID: (NSString*)docID{
    return [super uniqueFieldFromDocID:docID forDocType:[self docType]];
}

+ (Opportunity*) createInDatabase: (CBLDatabase*)database
                     withTitle: (NSString*)title
{
    Opportunity* opp = [super createInDatabase:database withUniqueField:title andDocType:[self docType]];
    [opp setValue: title ofProperty: @"title"];

    NSError* error;
    if (![opp save: &error])
        return nil;
    return opp;
}

@end
