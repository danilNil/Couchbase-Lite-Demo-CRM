//
//  CBLAuthController.h
//  CBLiteCRM
//
//  Created by Danil on 23/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBLAuthController : NSObject
- (CBLAuthController*) initWithFBAppID:(NSString *)facebookAppID;

- (void)loginWithFacebook;
- (void)logout;
@end
