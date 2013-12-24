//
//  CBLModel+DeleteHelper.h
//  CBLiteCRM
//
//  Created by Ruslan on 12/24/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import <CouchbaseLite/CouchbaseLite.h>

typedef void (^DeleteBlock)(BOOL shouldDelete);

@interface CBLModel (DeleteHelper)
<
UIAlertViewDelegate
>

@property (nonatomic, copy) DeleteBlock deleteAlertBlock;

- (void)showDeletionAlert;

@end
