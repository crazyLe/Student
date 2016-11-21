//
//  HttpParamManager.h
//  学员端
//
//  Created by zuweizhong  on 16/8/2.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpParamManager : NSObject

+(NSString *)getSignWithIdentify:(NSString *)identify time:(NSString *)time;

+(NSString *)getSignWithIdentify:(NSString *)identify time:(NSString *)time couponsId:(int)couponsId;

+(NSString *)getUUID;

+(NSString *)getTime;

+(NSString *)getDeviceInfo;

+(NSInteger)getCurrentCityID;

//通过城市名称获取城市ID
+(NSInteger)getCityIdWithCityName:(NSString *)cityName;

+(NSInteger)getCurrentProvinceID;

/**
 *  经度
 */
+(NSString *)getLongitude;
/**
 *  纬度
 */
+(NSString *)getLatitude;


+(NSString *)getSignWithIdentify:(NSString *)identify time:(NSString *)time addExtraStr:(NSString *)extraStr;

@end
