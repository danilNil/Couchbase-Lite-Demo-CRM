//
//  DeviceSoftware.m
//  CBLiteCRM
//
//  Created by Ruslan on 12/12/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "DeviceSoftware.h"

@implementation DeviceSoftware

BOOL isIOS7()
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    return ([UIDevice.currentDevice.systemVersion compare:@"7" options:NSNumericSearch]) >= NSOrderedSame;
#else
    return NO;
#endif
}

@end
