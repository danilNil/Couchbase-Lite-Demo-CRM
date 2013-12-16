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

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onEpicFail)
                                                 name:@"authentication.fail"
                                               object:nil];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    NSString* userID = [[NSUserDefaults standardUserDefaults] objectForKey: kCBLPrefKeyUserID];
    
    if(userID)
        [self facebookLogin:self];
}

- (void)hideWelcomeScreen{
    [self performSegueWithIdentifier:@"pushMenuController" sender:self];
}

- (AppDelegate*)appDelegate
{
    return [UIApplication sharedApplication].delegate;
}

- (IBAction)facebookLogin:(id)sender {
    [self.view showActivity];
    
    [[self appDelegate] loginAndSync: ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideWelcomeScreen];
            NSLog(@"called complete loginAndSync");
            [self.view hideActivity];
        });
    } asAdmin:self.asAdmin.isOn];
}

- (void) onEpicFail
{
    [self.view hideActivity];
}


@end
