//
//  BorderedToggleButton.m
//  CBLiteCRM
//
//  Created by Andrew on 13.12.13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "BorderedToggleButton.h"

#import <QuartzCore/QuartzCore.h>

#define kBorderedToggleButtonDefaultBorderWidth  0.5

@implementation BorderedToggleButton

- (void) setDefaultColors
{
    self.bgColorNormal   = [UIColor whiteColor];
    self.bgColorSelected = [UIColor greenColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.masksToBounds = YES;
    self.layer.borderWidth   = borderWidth;
    self.layer.borderColor   = kBaseGrayColor.CGColor;
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if  (self) {
        [self setBorderWidth:kBorderedToggleButtonDefaultBorderWidth];
        [self setDefaultColors];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBorderWidth:kBorderedToggleButtonDefaultBorderWidth];
    [self setDefaultColors];
}

- (void) setSelected:(BOOL)selected
{
    self.backgroundColor = (selected) ? self.bgColorSelected : self.bgColorNormal;
    
    [super setSelected:selected];
}

@end
