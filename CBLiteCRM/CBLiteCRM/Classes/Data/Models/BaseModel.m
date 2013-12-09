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

- (instancetype) initInDatabase: (CBLDatabase*)database{
    self = [super initWithNewDocumentInDatabase:database];
    if(self){
        [self setValue: [[self class] docType] ofProperty: @"type"];
    }

    return self;
}

+ (NSString*) uniqueFieldFromDocID: (NSString*)docID forDocType:(NSString*)docType{
    return [docID substringFromIndex:docType.length+1];
}

+ (NSString*) docIDForUniqueField: (NSString*)uniqueValue forDocType:(NSString*)docType{
    return [NSString stringWithFormat:@"%@:%@",docType,uniqueValue];
}

+ (NSString*) docType{
    NSAssert(YES, @"implement doc type in your class");
    return nil;
}

@end
