//
//  UIAlertView+Helper.m
//  CBLiteCRM
//
//  Created by Andrew on 13.12.13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "UIAlertView+Helper.h"

@implementation UIAlertView (Helper)

+ (void) showErrorMessage:(NSString*)message
{
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"UIAlertView+Helper::showErrorMessage: (Title)")
                                message:message
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"ok",  @"UIAlertView+Helper::showErrorMessage: (cancaleButton)")
                      otherButtonTitles: nil] show];
}

@end
