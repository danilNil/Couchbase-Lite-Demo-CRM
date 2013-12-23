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

- (NSString*)positionAtCompanyForLabel:(UILabel *)label
{
    CGSize expectedLabelSize2 = [self sizeForString:[self getFullPositionAtCompany] inLabel:label];
    if (([self hasCompanyName] || [self hasPosition]) && expectedLabelSize2.width > label.bounds.size.width)
        return [self getTruncatedPositionAtCompanyToFitLabel:label];
    else
        return [self getFullPositionAtCompany];
}

- (NSString*)getTruncatedPositionAtCompanyToFitLabel:(UILabel*)label {
    NSString *position = self.position;
    float halfWidth = label.bounds.size.width / 2.;
    CGSize positionSize = [self sizeForString:position inLabel:label];
    CGSize dotsSize = [self sizeForString:@"..." inLabel:label];
    NSString *company = @"";
    CGSize companySize = CGSizeZero;

    if ([self hasCompanyName]) {
        if ([self hasPosition])
            company = [NSString stringWithFormat:@" at %@", [self customerCompanyName]];
        else
            company = [NSString stringWithFormat:@"at %@", [self customerCompanyName]];

        companySize = [self sizeForString:company inLabel:label];

        if (companySize.width + positionSize.width > label.bounds.size.width) {
            float fitWidth = MAX(label.bounds.size.width - positionSize.width, halfWidth);
            while (companySize.width + dotsSize.width > fitWidth) {
                company = [self substringString:company];
                companySize = [self sizeForString:company inLabel:label];
            }
            company = [company stringByAppendingString:@"..."];
        }
        companySize = [self sizeForString:company inLabel:label];
    }

    if (positionSize.width + companySize.width > label.bounds.size.width) {
        while (positionSize.width + companySize.width + dotsSize.width > label.bounds.size.width) {
            position = [self substringString:position];
            positionSize = [self sizeForString:position inLabel:label];
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

- (CGSize)sizeForString:(NSString*)string inLabel:(UILabel*)label {
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:label.font forKey: NSFontAttributeName];
    return [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, label.bounds.size.height)
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
