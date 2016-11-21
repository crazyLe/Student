//
//  HttpsTools.h
//  KZXC_Instructor
//
//  Created by 翁昌青 on 16/6/27.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^succeedInfoOthers)(id backdata ,int code, NSString *msg);
typedef void(^succeed)(id backData);
typedef void(^failure)(NSError *error);

@interface HttpsTools : NSObject

+(NSString *)getLoginPhone:(NSString *)phone andIdentify:(NSString *)identify andTime:(NSString *)time;

+(NSString *)getSignWithIdentify:(NSString *)identify time:(NSString *)time;

/**
 *  经度
 */
+(NSString *)getLongitude;
/**
 *  纬度
 */
+(NSString *)getLatitude;



+ (void)GET:(NSString *)urlStr parameters:(NSDictionary *)dict progress:(void (^)(NSProgress *downloadProgress))progress succeed:(void (^)(id responseObject))succeed failure:(void (^)(NSError *error))failure;

+ (void)POST:(NSString *)urlStr parameter:(NSDictionary *)dict progress:(void (^)(NSProgress *downloadProgress))progress succeed:(void (^)(id responseObject))succeed failure:(void (^)(NSError *error))failure;
/**
 *  post请求
 *
 *  @param urlStr            post请求地址
 *  @param dict              请求数据
 *  @param progress          进度
 *  @param succeedInfoOthers 请求成功返回数据
 *  @param failure           失败
 */
+ (void)kPOST:(NSString *)urlStr parameter:(NSDictionary *)dict progress:(void(^)(NSProgress *downloadProgress))progress succeed:(void(^)(id backdata,int code ,NSString *msg))succeedInfoOthers failure:(void (^)(NSError *error))failure;

@end
