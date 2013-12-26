//
//  CBLSyncController.h
//  CBLiteCRM
//
//  Created by Danil on 23/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBLSyncController : NSObject
- (CBLSyncController*)initWithDatabase:(CBLDatabase*)database
                          andServerURL:(NSString*)serverURL;

- (void)startReplicationWithBlock: (void (^)(NSError *error))block;

@end
