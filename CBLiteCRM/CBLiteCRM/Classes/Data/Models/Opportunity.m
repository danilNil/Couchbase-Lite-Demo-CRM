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

- (instancetype) initInDatabase: (CBLDatabase*)database
                      withTitle: (NSString*)title{
    NSParameterAssert(title);
    self = [super initInDatabase:database];
    if(self){
        [self setValue: title ofProperty: @"title"];
    }
    
    NSError* error;
    if (![self save: &error])
        return nil;
    return self;

}

@end
