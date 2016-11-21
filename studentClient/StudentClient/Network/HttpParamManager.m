//
//  HttpParamManager.m
//  学员端
//
//  Created by zuweizhong  on 16/8/2.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "HttpParamManager.h"
#import "LocationManager.h"
@implementation HttpParamManager

+(NSString *)getSignWithIdentify:(NSString *)identify time:(NSString *)time
{
   
    NSString *uuid = [self getUUID];
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@",uuid,identify,kUid,kToken,time];
    NSString *md5Str = [str md5String];
    return md5Str;

}
//couponsId代金券id
+(NSString *)getSignWithIdentify:(NSString *)identify time:(NSString *)time couponsId:(int)couponsId {
    
    NSString *uuid = [self getUUID];
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%d",uuid,identify,kUid,kToken,time,couponsId];
    NSString * md5String = [str md5String];
    return md5String;
    
}
+(NSString *)getUUID
{
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    //暂时，上线后用identifierForVendor
    return identifierForVendor;
}
+(NSString *)getTime
{

    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%d", (int)a];
    
    NSInteger jiange = [[NSUserDefaults standardUserDefaults] integerForKey:@"jiange"];
    
    NSInteger curtime = [timeString integerValue] + jiange;
    
    NSString *curtimeStr = [NSString stringWithFormat:@"%d",(int)curtime];
    
    return curtimeStr;

}
+(NSString *)getDeviceInfo
{
    NSString *str = [NSString stringWithFormat:@"%@,%@",[UIDevice currentDevice].model,[[UIDevice currentDevice] systemVersion]];
    return str;
}
+(NSInteger)getCurrentCityID
{
    NSArray *cityDicArr = kCityDict;
    //暂时使用合肥，上线后使用上面的
    NSString *currentCity1 = [USER_DEFAULT objectForKey:@"locationCity"];
//    NSString *currentCity1 = @"合肥市";
    for (NSDictionary *dic in cityDicArr) {
        if ([dic[@"title"] isEqualToString:currentCity1]) {
            return [dic[@"id"] integerValue];
        }
    }
    return 0;
    
}
//通过城市名称获取城市ID
+(NSInteger)getCityIdWithCityName:(NSString *)cityName
{
    NSArray *cityDicArr = kCityDict;
    //暂时使用合肥，上线后使用上面的
    NSString *currentCity1 = cityName;
    //    NSString *currentCity1 = @"合肥市";
    for (NSDictionary *dic in cityDicArr) {
        if ([dic[@"title"] isEqualToString:currentCity1]) {
            return [dic[@"id"] integerValue];
        }
    }
    return 0;
    
}

+(NSString *)getLongitude
{
    return [LocationManager sharedLocationManager].longitude == 0.0?@"117.662926":[NSString stringWithFormat:@"%f",[LocationManager sharedLocationManager].longitude] ;
}
+(NSString *)getLatitude
{
    return [LocationManager sharedLocationManager].latitude == 0.0?@"32.572815":[NSString stringWithFormat:@"%f",[LocationManager sharedLocationManager].latitude] ;
}

+(NSString *)getSignWithIdentify:(NSString *)identify time:(NSString *)time addExtraStr:(NSString *)extraStr
{
    NSString *uuid = [self getUUID];
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@",uuid,identify,kUid,kToken,time,extraStr];
    NSString *md5Str = [str md5String];
    return md5Str;
}
+(NSInteger)getCurrentProvinceID
{
    
    NSArray *cityDicArr = kProvinceDict;
    //暂时使用合肥，上线后使用上面的
    NSString *currentProvince = [USER_DEFAULT objectForKey:@"province"];
//    NSString *currentProvince = @"安徽";
    
    for (NSDictionary *dic in cityDicArr) {
        if ([dic[@"title"] isEqualToString:currentProvince]) {
            return [dic[@"id"] integerValue];
        }
    }
    return 0;

}

@end
