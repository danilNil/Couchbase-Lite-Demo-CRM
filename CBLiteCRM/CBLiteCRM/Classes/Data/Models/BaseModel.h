//
//  BaseModel.h
//  CBLiteCRM
//
//  Created by Danil on 29/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//


@interface BaseModel : CBLModel
@property (strong) NSString* uniqueField;
@property (strong) NSString* docType;

+ (id) createInDatabase: (CBLDatabase*)database
        withUniqueField: (NSString*)uniqueField
             andDocType:(NSString*)docType;
+ (NSString*) uniqueFieldFromDocID: (NSString*)docID forDocType:(NSString*)docType;
+ (NSString*) docIDForUniqueField: (NSString*)uniqueValue forDocType:(NSString*)docType;

@end
