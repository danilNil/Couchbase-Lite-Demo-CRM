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

+ (NSString*) docType{
    NSAssert(YES, @"implement doc type in your class");
    return nil;
}

@end
