//
//  CBLAuthController.m
//  CBLiteCRM
//
//  Created by Danil on 23/12/13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "CBLFacebookAuthManager.h"

@interface CBLFacebookAuthManager()
@property (nonatomic, strong) NSString *facebookAppID;
@end

@implementation CBLFacebookAuthManager

- (CBLFacebookAuthManager*) initWithFBAppID:(NSString *)facebookAppID{
    return nil;
}

- (void)loginWithBlock: (void (^)(id userData, AuthMethod method))block{
    
}

- (void)logout{
    
}


@end
