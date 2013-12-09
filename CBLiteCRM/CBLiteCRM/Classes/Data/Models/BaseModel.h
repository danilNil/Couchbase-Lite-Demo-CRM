//
//  BaseModel.h
//  CBLiteCRM
//
//  Created by Danil on 29/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//


@interface BaseModel : CBLModel
@property (copy) NSString* uniqueField;
@property (copy) NSString* docType;

- (instancetype) initInDatabase: (CBLDatabase*)database;
+ (NSString*) uniqueFieldFromDocID: (NSString*)docID forDocType:(NSString*)docType;
+ (NSString*) docIDForUniqueField: (NSString*)uniqueValue forDocType:(NSString*)docType;
+ (NSString*) docType;
@end
