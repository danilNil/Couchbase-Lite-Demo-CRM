//
//  Contact+Helper.m
//  CBLiteCRM
//
//  Created by Andrew on 12.12.13.
//  Copyright (c) 2013 Couchbase. All rights reserved.
//

#import "Contact+Helper.h"
#import "Customer.h"

@implementation Contact (Helper)

- (NSString*)customerCompanyName
{
    return self.customer.companyName;
}

- (NSString*)positionAtCompanyForSize:(CGSize)size font:(UIFont*)font
{
    CGSize expectedLabelSize2 = [self sizeForString:[self getFullPositionAtCompany] fitSize:size font:font];
    if (([self hasCompanyName] || [self hasPosition]) && expectedLabelSize2.width > size.width)
        return [self getTruncatedPositionAtCompanyToFitSize:size font:font];
    else
        return [self getFullPositionAtCompany];
}

- (NSString*)getTruncatedPositionAtCompanyToFitSize:(CGSize)size font:(UIFont*)font {
    NSString *position = self.position;
    float halfWidth = size.width / 2.;
    CGSize positionSize = [self sizeForString:position fitSize:size font:font];
    CGSize dotsSize = [self sizeForString:@"..." fitSize:size font:font];
    NSString *company = @"";
    CGSize companySize = CGSizeZero;

    if ([self hasCompanyName]) {
        if ([self hasPosition])
            company = [NSString stringWithFormat:@" at %@", [self customerCompanyName]];
        else
            company = [NSString stringWithFormat:@"at %@", [self customerCompanyName]];

        companySize = [self sizeForString:company fitSize:size font:font];

        if (companySize.width + positionSize.width > size.width) {
            float fitWidth = MAX(size.width - positionSize.width, halfWidth);
            while (companySize.width + dotsSize.width > fitWidth) {
                company = [self substringString:company];
                companySize = [self sizeForString:company fitSize:size font:font];
            }
            company = [company stringByAppendingString:@"..."];
        }
        companySize = [self sizeForString:company fitSize:size font:font];
    }

    if (positionSize.width + companySize.width > size.width) {
        while (positionSize.width + companySize.width + dotsSize.width > size.width) {
            position = [self substringString:position];
            positionSize = [self sizeForString:position fitSize:size font:font];
        }
        position = [position stringByAppendingString:@"..."];
    }
    return [position stringByAppendingString:company];
}

- (NSString*)getFullPositionAtCompany {
    NSMutableString * positionAtCompany = [NSMutableString new];
    if ([self hasPosition])
        [positionAtCompany appendFormat:@"%@ ", self.position];
    if ([self hasCompanyName])
        [positionAtCompany appendFormat:@"at %@", [self customerCompanyName]];
    return positionAtCompany;
}

- (CGSize)sizeForString:(NSString*)string fitSize:(CGSize)size font:(UIFont*)font {
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:font forKey: NSFontAttributeName];
    return [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, size.height)
                                options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                             attributes:stringAttributes context:nil].size;

}

- (NSString*)substringString:(NSString*)string {
    return [string substringToIndex:string.length - 2];
}

- (BOOL)hasPosition
{
    return [self.position length] != 0;
}

- (BOOL)hasCompanyName
{
    return [[self customerCompanyName] length] != 0;
}

@end
