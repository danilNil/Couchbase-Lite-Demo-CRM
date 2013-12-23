//
//  CBLAuthController.h
//  CBLiteCRM
//
//  Created by Danil on 23/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "CBLAuthProtocol.h"

@interface CBLFacebookAuthManager : NSObject<CBLAuthProtocol>
- (CBLFacebookAuthManager*)initWithFBAppID:(NSString *)facebookAppID;
@end
