//
//  CBLAuthProtocol.h
//  CBLiteCRM
//
//  Created by Danil on 23/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

typedef enum {
    AuthMethodNone,
    AuthMethodFacebook,
    AuthMethodPersona,
    AuthMethodEmailAndPassword
} AuthMethod;

@protocol CBLAuthProtocol
@required
- (void)loginWithBlock: (void (^)(id userData, AuthMethod method))block;
- (void)logout;
@end

