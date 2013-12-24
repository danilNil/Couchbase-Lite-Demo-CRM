//
//  CBLModel+DeleteHelper.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/24/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "CBLModel+DeleteHelper.h"

@implementation CBLModel (DeleteHelper)
@dynamic deleteAlertBlock;

- (void)showDeletionAlert
{
    [[[UIAlertView alloc] initWithTitle:@"Delete item" message:@"Are you sure you want to remove item" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil] show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSError *error;
        if ([self deleteDocument:&error])
            self.deleteAlertBlock(YES);
        else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil] show];
            self.deleteAlertBlock(NO);
        }
    }
}

@end
