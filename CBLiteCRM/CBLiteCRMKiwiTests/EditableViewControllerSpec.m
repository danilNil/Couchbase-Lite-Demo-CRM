#import <Kiwi/Kiwi.h>
#import "EditableViewController.h"

@interface EditableViewController (PrivateMethods)
- (void)setRightButtonEnabled:(BOOL)enabled;
@end

SPEC_BEGIN(EditableViewControllerSpec)

describe(@"set read mode", ^{
    context(nil, ^{
        
        __block EditableViewController* vc;
        beforeEach(^{
            vc = [EditableViewController new];
        });
        
        afterEach(^{
            vc = nil;
        });
        
        context(@"vc disabled for editing", ^{
            it(@"right button should be disabled", ^{
                [[vc should] receive:@selector(setRightButtonEnabled:) withArguments:theValue(NO)];
                vc.enabledForEditing = NO;
            });
        });
        
        context(@"vc enabled for editing", ^{
            it(@"right button should be enabled", ^{
                [[vc should] receive:@selector(setRightButtonEnabled:) withArguments:theValue(YES)];
                vc.enabledForEditing = YES;
            });
        });
        
    });
    
});

SPEC_END