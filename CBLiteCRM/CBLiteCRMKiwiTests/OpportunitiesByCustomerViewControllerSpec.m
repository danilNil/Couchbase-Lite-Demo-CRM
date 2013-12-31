#import <Kiwi/Kiwi.h>
#import "OpportunitiesByCustomerViewController.h"
#import "OpportunityDetailesViewController.h"
#import "Customer.h"

@interface OpportunitiesByCustomerViewController (PrivateMethods)
- (void)setRightButtonEnabled:(BOOL)enabled;
- (void)setCustomer:(Customer*)customer to:(OpportunityDetailesViewController*)vc;
@end

SPEC_BEGIN(OpportunitiesByCustomerViewControllerSpec)

describe(@"set read mode", ^{
    context(nil, ^{

        __block OpportunitiesByCustomerViewController* vc;
        beforeEach(^{
            vc = [OpportunitiesByCustomerViewController new];
        });

        afterEach(^{
            vc = nil;
        });


        context(@"vc disabled for editing", ^{
            it(@"plus button should be disabled and table view shouldn't allow us to delete cell by swipe", ^{
                [[vc should] receive:@selector(setRightButtonEnabled:) withArguments:theValue(NO)];
                vc.enabledForEditing = NO;
                [[theValue([vc tableView:[KWMock nullMock] editingStyleForRowAtIndexPath:[KWMock nullMock]]) should] equal:theValue(UITableViewCellEditingStyleNone)];
            });
        });

        context(@"vc enabled for editing", ^{
            it(@"plus button should be enabled and table view should allow us to delete cell by swipe", ^{
                [[vc should] receive:@selector(setRightButtonEnabled:) withArguments:theValue(YES)];
                vc.enabledForEditing = YES;
                [[theValue([vc tableView:[KWMock nullMock] editingStyleForRowAtIndexPath:[KWMock nullMock]]) should] equal:theValue(UITableViewCellEditingStyleDelete)];
            });
            it(@"click on plus button in enabled for editing", ^{
                Customer *customer = [KWMock nullMock];
                OpportunityDetailesViewController *controller = [OpportunityDetailesViewController new];
                [vc setCustomer:customer to:controller];
                [[controller.preselectedCustomer should] beIdenticalTo:customer];
            });
        });

        context(@"click on cell in enabled for editing", ^{
            vc.enabledForEditing = YES;

            [[[vc should] receive] prepareForSegue:[KWMock nullMock] sender:[KWMock nullMock]];
            SEL rightBarButtonItemSelector = vc.navigationItem.rightBarButtonItem.action;
            [vc.navigationItem.rightBarButtonItem performSelector:rightBarButtonItemSelector];
        });
    });

});

SPEC_END