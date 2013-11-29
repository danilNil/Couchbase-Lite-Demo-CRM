//
//  BaseModel.m
//  CBLiteCRM
//
//  Created by Danil on 29/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
@dynamic uniqueField,docType;

+ (id) createInDatabase: (CBLDatabase*)database
        withUniqueField: (NSString*)uniqueField
             andDocType:(NSString*)docType{
    NSString* docID = [self docIDForUniqueField:uniqueField forDocType:docType];
    CBLDocument* doc = [database documentWithID: docID];
    BaseModel* newModel = [[self class] modelForDocument: doc];
    
    [newModel setValue:docType ofProperty: @"type"];
    [newModel setValue:docType ofProperty:@"docType"];
    [newModel setValue:uniqueField ofProperty:@"uniqueField"];

    NSError* error;
    if (![newModel save: &error])
        return nil;
    return newModel;
}

+ (NSString*) uniqueFieldFromDocID: (NSString*)docID forDocType:(NSString*)docType{
    return [docID substringFromIndex:docType.length+1];
}

+ (NSString*) docIDForUniqueField: (NSString*)uniqueValue forDocType:(NSString*)docType{
    return [NSString stringWithFormat:@"%@:%@",docType,uniqueValue];
}


@end
