//
//  CBLSocialSync.h
//  TodoLite7
//
//  Created by Chris Anderson on 11/16/13.
//  Copyright (c) 2013 Chris Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

//#import "CBLSyncAuthenticator.h"

@class CBLSyncManager;

#pragma mark - Authenticators


// base Authenticator, you can inherit from this to
// create a custom Authenticator
@protocol CBLSyncAuthenticator <NSObject>
@property (readwrite) CBLSyncManager *syncManager;
-(void) getCredentials: (void (^)(NSString *userID, NSDictionary *userData))block;
-(void) registerCredentialsWithReplications: (NSArray *)repls;
- (void)logoutUser:(NSString*)userID;
@end

// example Facebook Authenticator
@interface CBLFacebookAuthenticator : NSObject<CBLSyncAuthenticator>
@property (readonly) NSString *facebookAppID;
- (instancetype) initWithAppID:(NSString *)facebookAppID;
@end

#pragma mark - CBLSyncManager

@interface CBLSyncManager : NSObject

- (instancetype) initSyncForDatabase:(CBLDatabase*)database
                             withURL:(NSURL*)remoteURL;

- (instancetype) initSyncForDatabase:(CBLDatabase*)database
                      withURL:(NSURL*)remoteURL
                       asUser:(NSString*)userID;

@property (readonly) CBLDatabase *database;
@property (readonly) NSString *userID;
@property (readonly) NSURL *remoteURL;
@property (readwrite, nonatomic) NSObject<CBLSyncAuthenticator> *authenticator;

//// setup the facebook authenticator
- (void)setAuthenticator:(NSObject<CBLSyncAuthenticator> *)authenticator;

// register a callback for when we discover the user info
- (void)beforeFirstSync: (void (^)(NSString *userID, NSDictionary *userData, NSError **outError))block;

// register a callback for after the sync begins making progress
- (void)onSyncConnected: (void (^)())block;

- (void)start;
- (void)logout;

// These are not KVO-observable; observe SyncManagerStateChangedNotification instead
@property (nonatomic, readonly) unsigned completed, total;
@property (nonatomic, readonly) float progress;
@property (nonatomic, readonly) bool active;
@property (nonatomic, readonly) CBLReplicationStatus status;
@property (nonatomic, readonly) NSError* error;


@end


/** Posted by a SyncManager instance when its replication state properties change. */
extern NSString* const SyncManagerStateChangedNotification;
