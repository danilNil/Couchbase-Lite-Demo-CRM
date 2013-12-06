//
//  ViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "WelcomeViewController.h"
#import "UIView+Activity.h"
#import "AppDelegate.h"

//Data
#import "DataStore.h"
#import "SalePersonsStore.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)hideWelcomeScreen{
    [self performSegueWithIdentifier:@"pushMenuController" sender:self];
}

- (IBAction)facebookLogin:(id)sender {
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    [self.view showActivity];
    [app loginAndSync: ^(){
        [self hideWelcomeScreen];
        NSLog(@"called complete loginAndSync");
        [self.view hideActivity];
    }];
}


@end
