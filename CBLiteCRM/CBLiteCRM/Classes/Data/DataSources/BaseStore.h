//
//  BaseStore.h
//  CBLiteCRM
//
//  Created by Danil on 04/12/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//


@interface BaseStore : NSObject
@property (readonly) CBLDatabase* database;

- (id) initWithDatabase: (CBLDatabase*)database;
@end
