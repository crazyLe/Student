//
//  LLAddress.m
//  Coach
//
//  Created by LL on 16/8/10.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "SCDBManager.h"
#import "ChineseToPinyin.h"
#import "LLAddress.h"
#import "ProvinceModel.h"

@implementation LLAddress

#pragma mark - Network

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self loadAddress];
    });
}

+ (void)getAreaIdWithProvince:(NSString *)provice city:(NSString *)city county:(NSString *)county  completeBlock:(void(^)(BOOL isSuccess,NSString *areaName,NSString *areaID))completeBlock
{
//    NSMutableDictionary *paraDic = [@{@"uid":kUid,@"time":kTimeStamp,@"deviceInfo":kDeviceInfo,@"sign":kSignWithIdentify(@"/getAddress")} mutableCopy];
//    [paraDic setObject:@"1" forKey:@"levelid"];
    
    NSString *timestr = [HttpParamManager getTime];
    
    NSMutableDictionary *paraDic = [@{@"uid":kUid,@"time":timestr,@"deviceInfo":[HttpParamManager getDeviceInfo],@"sign":[HttpsTools getSignWithIdentify:@"/getAddress" time:timestr]} mutableCopy];
    [paraDic setObject:@"1" forKey:@"levelid"];
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getAddressRequestWithParaDic:paraDic completeBlock:^(NSArray *addArr){
            //遍历省
            if (isEmptyArr(addArr)) {
                completeBlock(NO,nil,nil);
                return ;
            }
            BOOL isFondProvice = NO;
            for (NSDictionary *dic in addArr) {
                if ([dic[@"title"] rangeOfString:provice].location != NSNotFound) {
                    if (isEmptyStr(city)) {
                        completeBlock(YES,dic[@"title"],dic[@"id"]);
                        return;
                    }
                    [paraDic removeObjectForKey:@"levelid"];
                    [paraDic setObject:dic[@"id"] forKey:@"parentId"];
                    [self getAddressRequestWithParaDic:paraDic completeBlock:^(NSArray *addArr) {
                        //遍历市
                        //                        NSLog(@"市===>%@",[LLUtils replaceUnicode:[NSString stringWithFormat:@"%@",addArr]]);
                        if (isEmptyArr(addArr)) {
                            completeBlock(NO,nil,nil);
                            return ;
                        }
                        BOOL isFondCity = NO;
                        for (NSDictionary *dic in addArr) {
                            if ([dic[@"title"] rangeOfString:city].location != NSNotFound) {
                                if (isEmptyStr(county)) {
                                    completeBlock(YES,dic[@"title"],dic[@"id"]);
                                    return;
                                }
                                [paraDic setObject:dic[@"id"] forKey:@"parentId"];
                                [self getAddressRequestWithParaDic:paraDic completeBlock:^(NSArray *addArr) {
                                    //遍历县
                                    if (isEmptyArr(addArr)) {
                                        completeBlock(NO,nil,nil);
                                        return ;
                                    }
                                    BOOL isFondCounty = NO;
                                    for (NSDictionary *dic in addArr) {
                                        if ([dic[@"title"] rangeOfString:county].location != NSNotFound) {
//                                            NSLog(@"县名称===>%@\nID===>%@",dic[@"title"],dic[@"id"]);
                                            isFondCounty = YES;
                                            completeBlock(YES,dic[@"title"],dic[@"id"]);
                                            break;
                                        }
                                    }
                                    if (!isFondCounty) {
                                        completeBlock(NO,nil,nil);
                                        return ;
                                    }
                                }];
                                isFondCity = YES;
                                break;
                            }
                        }
                        if (!isFondCity) {
                            completeBlock(NO,nil,nil);
                            return ;
                        }
                    }];
                    isFondProvice = YES;
                    break;
                }
            }
            if (!isFondProvice) {
                completeBlock(NO,nil,nil);
                return;
            }
        }];
    });
}

//获取省份ID
//provice : 传入省或者直辖市
//注：如果省份获取不到会 会检索市，市检索不到最后会检索县，如果依然找不到就返回NO
+ (void)getProviceId:(NSString *)provice completeBlock:(void(^)(BOOL isSuccess,NSString *areaName,NSString *areaID))block
{
   [self getAreaID:provice levelId:@"1" completeBlock:^(BOOL isSuccess, NSString *areaName, NSString *areaID) {
       if (isSuccess) {
           dispatch_async(dispatch_get_main_queue(), ^{
               block(YES,areaName,areaID);
           });
       }
       else
       {
           [self getCityId:provice completeBlock:^(BOOL isSuccess, NSString *areaName, NSString *areaID) {
               if (isSuccess) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       block(YES,areaName,areaID);
                   });
               }
               else
               {
                   [self getCountyId:provice completeBlock:^(BOOL isSuccess, NSString *areaName, NSString *areaID) {
                       if (isSuccess) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               block(YES,areaName,areaID);
                           });
                       }
                       else
                       {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               block(NO,nil,nil);
                           });
                       }
                   }];
               }
           }];
       }
   }];
}

//获取市ID
//注：如果市查询不到，就不会查询县
+ (void)getCityId:(NSString *)city completeBlock:(void(^)(BOOL isSuccess,NSString *areaName,NSString *areaID))block
{
    [self getAreaID:city levelId:@"2" completeBlock:^(BOOL isSuccess, NSString *areaName, NSString *areaID) {
        if (isSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(YES,areaName,areaID);
            });
        }
        else
        {
            [self getCountyId:city completeBlock:^(BOOL isSuccess, NSString *areaName, NSString *areaID) {
                if (isSuccess) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(YES,areaName,areaID);
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(NO,nil,nil);
                    });
                }
            }];
        }
    }];
}

//获取县ID
+ (void)getCountyId:(NSString *)county completeBlock:(void(^)(BOOL isSuccess,NSString *areaName,NSString *areaID))block
{
    [self getAreaID:county levelId:@"3" completeBlock:^(BOOL isSuccess, NSString *areaName, NSString *areaID) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isSuccess) {
                block(YES,areaName,areaID);
            }
            else
            {
                block(NO,nil,nil);
            }
        });
    }];
}

+ (void)getAreaID:(NSString *)area levelId:(NSString *)level completeBlock:(void(^)(BOOL isSuccess,NSString *areaName,NSString *areaID))block
{
    if (isEmptyStr(area)) {
        NSLog(@"getAreaID方法传入参数area为空!");
        return;
    }
    NSString *timestr = [HttpParamManager getTime];
    NSMutableDictionary *paraDic = [@{@"uid":kUid,@"time":timestr,@"deviceInfo":[HttpParamManager getDeviceInfo],@"sign":[HttpsTools getSignWithIdentify:@"/getAddress" time:timestr]} mutableCopy];
    [paraDic setObject:level forKey:@"levelid"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *tableNameArr = @[kProvinceTableName,kOpenCityTableName,kCountyTableName];
        NSArray *tableColumnArr = @[kProvinceTableCollumnArr,kOpenCityTableColumnArr,kCountyTableCollumnArr];

        //先从数据库里读取，看有没有
//        NSArray *addArr = [[SCDBManager shareInstance] getAllObjectsFromTable:tableNameArr[[level intValue]-1] KeyArr:tableColumnArr[[level intValue]-1]];
        
        [[SCDBManager shareInstance] getAllObjectsFromTable:tableNameArr[[level intValue]-1] keyArr:tableColumnArr[[level intValue]-1] completionBlock:^(NSArray *addArr) {
            if (addArr.count>0) {
                for (NSDictionary *dic in addArr) {
                    if ([dic[@"title"] rangeOfString:area].location != NSNotFound) {
                        block(YES,dic[@"title" ],dic[@"id"]);
                        return ;
                    }
                }
                block(NO,nil,nil);
            }
            else
            {
                //数据库没有，发起网络请求获取数据
                [self getAddressRequestWithParaDic:paraDic completeBlock:^(NSArray *addArr) {
                    //遍历查询
                    if (addArr.count>0) {
                        //缓存到数据库
                        SCDBManager *db_manager = [SCDBManager shareInstance];
                        
                        [db_manager createTableWithName:tableNameArr[[level intValue]-1] keyArr:tableColumnArr[[level intValue]-1]];
                        [db_manager insertIntoTable:tableNameArr[[level intValue]-1] dicArr:addArr insertColumnArr:tableColumnArr[[level intValue]-1]];
                    }
                    
                    for (NSDictionary *dic in addArr) {
                        if ([dic[@"title"] rangeOfString:area].location != NSNotFound) {
                            block(YES,dic[@"title" ],dic[@"id"]);
                            return ;
                        }
                    }
                    block(NO,nil,nil);
                    
                    if (!isEmptyArr(addArr)) {
                        [self loadAddress];
                    }
                }];
            }
        }];
        
    });
}

+ (void)getAddressRequestWithParaDic:(NSDictionary *)dic completeBlock:(void(^)(NSArray *addArr))block
{
    
    [HttpsTools kPOST:getxueyuanAddressUrl parameter:dic progress:^(NSProgress *downloadProgress) {
        
    } succeed:^(id backdata, int code, NSString *msg) {
        if (1 == code) {
            //请求成功
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                block(backdata[@"address"]);
            });
        }
    } failure:^(NSError *error) {
        
    }];
//    [NetworkEngine postRequestWithRelativeAdd:@"/getAddress" paraDic:dic completeBlock:^(BOOL isSuccess, id jsonObj) {
//        if (isSuccess) {
//            if ([jsonObj[@"code"] isEqualToNumber:@(1)]) {
//                //请求成功
//                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                    block(jsonObj[@"info"][@"address"]);
//                });
//            }
//            else if([jsonObj[@"code"] isEqualToNumber:@(2)])
//            {
//                //需要登录
//                block(nil);
//            }
//            else
//            {
//                block(nil);
//            }
//        }
//        else
//        {
//            block(nil);
//        }
//    }];
}

+ (void)loadAddress
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *addressArray = [NSMutableArray array];
        NSData *data = [NSData dataNamed:@"krsys_area.json"];
        NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *cityDicArr = kProvinceDict;

        for (NSDictionary *dic in cityDicArr) {
            NSString *idNum = dic[@"id"];
            for (int i = 0; i<dataArray.count; i++) {
                NSString *idNum2 = dataArray[i][@"id"];
                if ([idNum2 isEqualToString:idNum]) {
                    ProvinceModel *model = [ProvinceModel mj_objectWithKeyValues:dataArray[i]];
                    model.citys = [NSMutableArray array];
                    for (int j = 0; j<dataArray.count; j++) {
                        NSDictionary *dict2=dataArray[j];
                        if ([dict2[@"parent_id"] integerValue] == model.idNum) {
                            CityModel *cityModel = [CityModel mj_objectWithKeyValues:dict2];
                            [model.citys addObject:cityModel];
                            cityModel.countrys = [NSMutableArray array];
                            for (int m = 0; m<dataArray.count; m++) {
                                NSDictionary *dict3=dataArray[m];
                                if ([dict3[@"parent_id"] integerValue] == cityModel.idNum) {
                                    CountryModel *countryModel = [CountryModel mj_objectWithKeyValues:dict3];
                                    [cityModel.countrys addObject:countryModel];
                                }
                            }
                        }
                    }
                    //将student类型变为NSData类型
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
                    [addressArray addObject:data];
                }
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [kUserDefault setObject:addressArray forKey:@"addressArray"];
        });
    });
}

- (NSData *)dataNamed:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
    if (!path) return nil;
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

//获取已经开通的城市的CityId
+ (void)getOpenCityArrCompleteBlock:(void(^)(BOOL isSuccess,NSDictionary *cityDic))block
{
    NSString *levelId = @"2";
    
    NSString *timestr = [HttpParamManager getTime];
    
//    NSMutableDictionary *paraDic = [@{@"uid":kUid,@"time":timestr,@"deviceInfo":[HttpParamManager getDeviceInfo],@"sign":[HttpsTools getSignWithIdentify:@"/getAddress" time:timestr]} mutableCopy];
//    [paraDic setObject:levelId forKey:@"levelid"];
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    
    paraDic[@"uid"] = @"0";
    paraDic[@"time"] = timestr;
    paraDic[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    paraDic[@"sign"] = [HttpsTools getSignWithIdentify:@"/getAddress" time:timestr];
    paraDic[@"levelid"] = levelId;
    
//    NSMutableDictionary *paraDic = [@{@"uid":kHandleEmptyStr(kUid),@"time":kTimeStamp,@"deviceInfo":kDeviceInfo,@"sign":kSignWithIdentify(@"/getAddress")} mutableCopy];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //网络请求获取数据
            [self getAddressRequestWithParaDic:paraDic completeBlock:^(NSArray *addArr) {
                
                if (addArr.count>0) {
                    SCDBManager *db_manager = [SCDBManager shareInstance];
                    
                    [db_manager createTableWithName:kOpenCityTableName keyArr:kOpenCityTableColumnArr];
                    [db_manager insertIntoTable:kOpenCityTableName dicArr:addArr insertColumnArr:kOpenCityTableColumnArr];
                }
                
            }];
    });
}

/*
(
  {
    hot = 0;
    id = 110100;
    name = "\U5317\U4eac\U5e02";
    "parent_id" = 110000;
    pinyin = beijing;
    "short_name" = "\U5317\U4eac";
    title = "\U5317\U4eac\U5e02";
  }
)
*/
@end
