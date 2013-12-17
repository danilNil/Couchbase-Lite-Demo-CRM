//
//  MenuViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize needLogout;

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.needLogout)
        [self logout:self];
}

- (IBAction)logout:(id)sender {
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    [app logout];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
