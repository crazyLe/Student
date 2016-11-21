//
//  LLAddress.h
//  Coach
//
//  Created by LL on 16/8/10.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLAddress : NSObject

//获取省份ID （逐级查询）
//provice : 传入省或者直辖市
//注：如果省份获取不到会 会检索市，市检索不到最后会检索县，如果依然找不到就返回NO
+ (void)getProviceId:(NSString *)provice completeBlock:(void(^)(BOOL isSuccess,NSString *areaName,NSString *areaID))block;

//获取市ID   （逐级查询）
//注：如果市查询不到，就不会查询县
+ (void)getCityId:(NSString *)city completeBlock:(void(^)(BOOL isSuccess,NSString *areaName,NSString *areaID))block;

//获取县ID
+ (void)getCountyId:(NSString *)county completeBlock:(void(^)(BOOL isSuccess,NSString *areaName,NSString *areaID))block;

//获取指定地区的ID
//provice       : 省份  NSString eg.安徽省
//city          : 市    NSString  eg.合肥市
//county        : 县    NSString  eg.肥西县
//completeBlock : 完成后回调
//isSuccess     : 是否成功获取
//areaName      : 地区名称
//areaID        : 地区ID
//注意 如果是获取市，直辖市直接填写在provice参数入口 , 非直辖市则必须先提供省provice 再提供city参数 county直接传nil即可
//注意 如果是获取县或者自治区，必须先提供provice，city参数。
+ (void)getAreaIdWithProvince:(NSString *)provice city:(NSString *)city county:(NSString *)county  completeBlock:(void(^)(BOOL isSuccess,NSString *areaName,NSString *areaID))completeBlock;

//获取已经开通的城市的CityId
+ (void)getOpenCityArrCompleteBlock:(void(^)(BOOL isSuccess,NSDictionary *cityDic))block;

@end
