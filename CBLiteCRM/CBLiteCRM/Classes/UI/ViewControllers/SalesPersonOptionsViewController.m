//
//  SalesPersonOptionsViewController.m
//  CBLiteCRM
//
//  Created by Ruslan on 11/26/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "SalesPersonOptionsViewController.h"

@interface SalesPersonOptionsViewController ()

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UIButton *viewAppointments;
@property (strong, nonatomic) IBOutlet UIButton *personLocation;
@property (strong, nonatomic) IBOutlet UIButton *scheduleMeeting;

@end

@implementation SalesPersonOptionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.user = _user;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setUser:(User *)user
{
    _user = user;
    _name.text = user.email;
    [_name sizeToFit];

    [_personLocation setTitle:[NSString stringWithFormat:@"%@ Location", _user.email] forState:UIControlStateNormal];
    CGSize sz = [_personLocation sizeThatFits:CGSizeMake(CGFLOAT_MAX, _personLocation.frame.size.height)];
    _personLocation.frame = CGRectMake(self.view.frame.size.width / 2. - sz.width / 2., _personLocation.frame.origin.y, sz.width, _personLocation.frame.size.height);
    [self.view setNeedsDisplay];
    [self.view layoutSubviews];
    [self.view layoutIfNeeded];
}

@end
