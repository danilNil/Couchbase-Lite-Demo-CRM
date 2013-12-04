//
//  BaseStore.m
//  CBLiteCRM
//
//  Created by Danil on 04/12/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "BaseStore.h"

@implementation BaseStore
- (id) initWithDatabase: (CBLDatabase*)database {
    self = [super init];
    if (self) {
        _database = database;
    }
    return self;
}
@end
