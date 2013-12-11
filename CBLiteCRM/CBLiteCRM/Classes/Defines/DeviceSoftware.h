//
//  DeviceSoftware.h
//  CBLiteCRM
//
//  Created by Danil on 11/12/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#ifndef CBLiteCRM_DeviceSoftware_h
#define CBLiteCRM_DeviceSoftware_h

BOOL isIOS7()
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    return ([UIDevice.currentDevice.systemVersion compare:@"7" options:NSNumericSearch]) >= NSOrderedSame;
#else
    return NO;
#endif
}


#endif
