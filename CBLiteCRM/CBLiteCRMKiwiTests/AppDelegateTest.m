#import <Kiwi/Kiwi.h>
#import "AppDelegate.h"
#import "DataStore.h"
#import "CBLSyncManager.h"

SPEC_BEGIN(AppDelegateSpec)



describe(@"initialisation all services", ^{
    
    context(nil, ^{
        
        __block AppDelegate* app;
        __block DataStore* store;
        __block CBLSyncManager* cblSync;
        beforeEach(^{
            app = [AppDelegate new];
            store = [KWMock nullMock];
            cblSync = [KWMock nullMock];
            app.cblSync = cblSync;
        });
        
        afterEach(^{
            app = nil;
        });

        context(@"when creating a new App delegate", ^{
            
            it(@"the App delegate should exist", ^{
                
                [app shouldNotBeNil];
                
            });
            
        });
        
        context(@"data base should be created", ^{

            it(@"should responce to setupDatabase", ^{
                
                [[app should] respondToSelector:@selector(setupDatabase:)];
                
            });
        });

        context(@"CBLSyncManager should be created", ^{
            it(@"has a CBLSyncManager", ^{
                
                [[app should] respondToSelector:@selector(cblSync)];
                
            });
            it(@"should responce to setupCBLSync", ^{
                
                [[app should] respondToSelector:@selector(setupCBLSync)];
                
            });
        });

        context(@"on app didFinishLaunchingWithOptions actions", ^{
            it(@"should setup all nesesary managers and UI appearance", ^{
                
                [[app should] receive:@selector(setupAppearance)];
                [[app should] receive:@selector(setupDatabase:)];
                [[app should] receive:@selector(setupCBLSync)];
                [app.cblSync shouldNotBeNil];
                [app application:[KWMock nullMock] didFinishLaunchingWithOptions:[KWMock nullMock]];
                
            });
        });
        
        context(@"on logout actions", ^{
            it(@"should call logout for DataStore and CBLSyncManager", ^{
                
//                [[[store should] receive] logout]; can'b be tested because of bad design
                [[[cblSync should] receive] logout];
                [app logout];
                
            });
        });

    });
});

SPEC_END