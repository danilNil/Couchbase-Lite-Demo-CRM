//
//  RoundedImageView.m
//  CBLiteCRM
//
//  Created by Andrew on 12.12.13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "RoundedImageView.h"

#import <QuartzCore/QuartzCore.h>

#define kRoundedImageViewDefaultCorderRadius 5.f
#define kRoundedImageViewDefaultBorderWidth  0.5

@implementation RoundedImageView

- (void)setCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = cornerRadius;
    self.layer.borderWidth   = borderWidth;
    self.layer.borderColor   = kBaseGrayColor.CGColor;
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if  (self) {
        [self setCornerRadius:kRoundedImageViewDefaultCorderRadius
                  borderWidth:kRoundedImageViewDefaultBorderWidth];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setCornerRadius:kRoundedImageViewDefaultCorderRadius
              borderWidth:kRoundedImageViewDefaultBorderWidth];
}

@end
