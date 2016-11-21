//
//  NSObject+HJGeneral.m
//  小筛子
//
//  Created by zwz on 15/6/27.
//  Copyright (c) 2015年 zwz. All rights reserved.
//

#import "NSObject+HJGeneral.h"
#import "HJDeviceDetailManager.h"
#import <objc/runtime.h>
@implementation NSObject (HJGeneral)

static BOOL _hasNetwork;
static MyNetworkStatus _status;

-(PersonalInfoModel *)currentUserInfo
{
    return [PersonalInfoModel sharedPersonalInfoModel];
}
-(HJInterfaceManager *)interfaceManager
{
    return [HJInterfaceManager sharedHJInterfaceManager];
}
-(ProgressHUD *)hudManager
{
    return [ProgressHUD sharedInstance];
}
-(LocationManager *)locationManager
{
    return [LocationManager sharedLocationManager];
}
#pragma mark - 当前设备类型
- (DeviceType)currentDeviceType
{
    if ([[HJDeviceDetailManager deviceModelName] rangeOfString:@"6+"].location != NSNotFound) {
        return DeviceType6P_Series;
    }
    else if ([[HJDeviceDetailManager deviceModelName] rangeOfString:@"6"].location != NSNotFound) {
        return DeviceType6_Series;
    }
    else if ([[HJDeviceDetailManager deviceModelName] rangeOfString:@"4S"].location != NSNotFound) {
        return DeviceType4_Series;
    }
    else if ([[HJDeviceDetailManager deviceModelName] rangeOfString:@"5"].location != NSNotFound) {
        return DeviceType5_Series;
    }
    else if ([[HJDeviceDetailManager deviceModelName] rangeOfString:@"Simulator"].location != NSNotFound) {
        return DeviceType_Simulator;
    }else
    {
        return DeviceType_Unknow;
    }
}
-(void)setHasNetwork:(BOOL)hasNetwork
{
    _hasNetwork = hasNetwork;
}
-(BOOL)hasNetwork
{
    return _hasNetwork;
}
-(void)setNetworkStatus:(MyNetworkStatus)networkStatus
{
    _status = networkStatus;
}
-(MyNetworkStatus)networkStatus
{
    return _status;
}

@end
