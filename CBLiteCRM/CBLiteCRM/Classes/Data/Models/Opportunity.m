//
//  Opportunity.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "Opportunity.h"

@implementation Opportunity
@dynamic customer, creationDate, revenueSize, winProbability, salesStage, contacts;

+ (NSString*)docIDForTitle:(NSString*)title{
    return [NSString stringWithFormat:@"%@:%@",kOpportDocType,title];
}

+ (NSString*) titleFromDocID: (NSString*)docID{
    return [docID substringFromIndex: kOpportDocType.length+1];
}

+ (Opportunity*) createInDatabase: (CBLDatabase*)database
                     withTitle: (NSString*)title
{
    NSString* docID = [self docIDForTitle:title];
    CBLDocument* doc = [database documentWithID: docID];
    Opportunity* opp = [Opportunity modelForDocument: doc];
    
    [opp setValue: kOpportDocType ofProperty: @"type"];
    [opp setValue: title ofProperty: @"title"];
    
    NSError* error;
    if (![opp save: &error])
        return nil;
    return opp;
}

@end
