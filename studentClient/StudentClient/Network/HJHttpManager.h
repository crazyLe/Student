//
//  HJHttpManager.h
//  醉了么
//
//  Created by zuweizhong  on 16/6/3.
//  Copyright © 2016年 Hefei JiuYi Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HttpSuccessBlock)(NSData *data);

typedef void (^HttpFailedBlock)(NSError *error);

typedef NS_ENUM(NSInteger,CustomErrorFailed) {
    
    HttpDefultFailed = -1000,
    
    HttpConnectFailed,

};
@interface HJHttpManager : NSObject

/**
 *  get请求(带参)
 */
+(void)GetRequestWithUrl:(NSString *)urlStr  params:(NSDictionary *)params finish:(HttpSuccessBlock)finishBlock failed:(HttpFailedBlock)failedBlock;
/**
 *  get请求(不带参)
 */
+(void)GetRequestWithUrl:(NSString *)urlStr finish:(HttpSuccessBlock)finishBlock failed:(HttpFailedBlock)failedBlock;
/**
 *  post请求
 */
+(void)PostRequestWithUrl:(NSString *)urlStr param:(NSDictionary *)dict finish:(HttpSuccessBlock)finishBlock failed:(HttpFailedBlock)failedBlock;
/**
 *  delete请求
 */
+(void)DeleteRequestWithUrl:(NSString *)urlStr param:(NSDictionary *)dict finish:(HttpSuccessBlock)finishBlock failed:(HttpFailedBlock)failedBlock;
/**上传文件
 1. url地址
 2. 参数
 3. 对应后台网站上[upload.php中]处理文件的[字段"head"]
 4. 要保存在服务器上的[文件名]
 5. 上传文件的[mimeType]
 6. 上传文件的Data[二进制数据]
 */
+(void)UploadFileWithUrl:(NSString *)urlStr param:(NSDictionary *)dict  serviceName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileData:(NSData *)data finish:(HttpSuccessBlock)finishBlock failed:(HttpFailedBlock)failedBlock;


@end
