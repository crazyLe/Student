//
//  LocationManager.m
//  Finance
//
//  Created by zwz on 15/12/30.
//  Copyright © 2015年 hqwang. All rights reserved.
//

#import "LocationManager.h"
#define CurrentDeviceSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
@interface LocationManager ()<CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager *manager;
/**
 *  定位成功后的回调
 */
@property(nonatomic,copy)LocationFinishBlock loactionFinish;

@end

@implementation LocationManager

singletonImplementation(LocationManager)

-(CLLocationManager *)manager
{
    if(_manager == nil)
    {
        _manager = [[CLLocationManager alloc]init];
    }
    return _manager;
}

-(void)startLocationWithFinishSuccessBlock:(LocationFinishBlock)finishBlock
{
    self.loactionFinish = finishBlock;
    //创建定位管理者
    self.manager.delegate = self;
    self.manager.distanceFilter = MAXFLOAT;
    self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    /*
     注意: iOS7只要开始定位, 系统就会自动要求用户对你的应用程序授权. 但是从iOS8开始, 想要定位必须先"自己""主动"要求用户授权
     在iOS8中不仅仅要主动请求授权, 而且必须再info.plist文件中配置一项属性才能弹出授权窗口
     NSLocationWhenInUseDescription，允许在前台获取GPS的描述(其中一个)
     NSLocationAlwaysUsageDescription，允许在后台获取GPS的描述(其中一个)
     */
    if (CurrentDeviceSystemVersion >= 8.0) {
        NSLog(@"是iOS8");
        // 主动要求用户对我们的程序授权, 授权状态改变就会通知代理
        [self.manager requestAlwaysAuthorization];

    }else
    {
        NSLog(@"是iOS7");
        // 3.开始监听(开始获取位置)
        [self.manager startUpdatingLocation];
    }
   



}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"等待用户授权");
    }else if (status == kCLAuthorizationStatusAuthorizedAlways ||
              status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        NSLog(@"授权成功");
        [self.manager startUpdatingLocation];
        
    }else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位授权失败!" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alertView show];
    }
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *location = [locations lastObject];
    NSLog(@"%f, %f speed = %f", location.coordinate.latitude , location.coordinate.longitude, location.speed);
    
    //记录经纬度
    self.longitude = location.coordinate.longitude;
    self.latitude = location.coordinate.latitude;
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获得的所有信息
             self.locationString = placemark.name;
             self.addressDictionary = placemark.addressDictionary;
             self.placeMark = placemark;
         }
         /**
          *  定位成功回调
          */
         if (self.loactionFinish) {
             
             self.loactionFinish(self.longitude,self.latitude,self.locationString,self.addressDictionary,self.placeMark);
             
         }

     }];
    
    [self stopLocation];
    
}
-(void)stopLocation
{
    [self.manager stopUpdatingLocation];
}





@end
