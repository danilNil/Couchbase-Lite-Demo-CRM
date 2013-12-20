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

- (NSString*)positionAtCompany
{
    NSMutableString * positionAtCompany = [NSMutableString new];
    
    if ([self hasPosition])
        [positionAtCompany appendFormat:@"%@ ", self.position];
    
    if ([self hasCompanyName])
        [positionAtCompany appendFormat:@"at %@", [self customerCompanyName]];
    
    return positionAtCompany;
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
