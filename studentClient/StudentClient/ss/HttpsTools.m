//
//  HttpsTools.m
//  KZXC_Instructor
//
//  Created by 翁昌青 on 16/6/27.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "HttpsTools.h"
#import "NSString+Hash.h"
#import "LocationManager.h"
//#import "PopView.h"
#import "HttpParamManager.h"
#import <AFNetworking.h>

#define pushID [HttpParamManager getUUID]

@implementation HttpsTools

+(NSString *)getLoginPhone:(NSString *)phone andIdentify:(NSString *)identify andTime:(NSString *)time
{
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@",pushID,identify,time,phone];
    NSString *md5Str = [NSString get32BitMD5_lowercaseString:str];
    return md5Str;
}

+(NSString *)getSignWithIdentify:(NSString *)identify time:(NSString *)time
{
//    NSString *uuid = deviceInfo;
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@",pushID,identify,kUid,kToken,time];
    NSString *md5Str = [NSString get32BitMD5_lowercaseString:str];
    return md5Str;
}

+(NSString *)getLongitude

{
    return [LocationManager sharedLocationManager].longitude == 0.0?@"117.662926":[NSString stringWithFormat:@"%f",[LocationManager sharedLocationManager].longitude] ;
}
+(NSString *)getLatitude
{
    return [LocationManager sharedLocationManager].latitude == 0.0?@"32.572815":[NSString stringWithFormat:@"%f",[LocationManager sharedLocationManager].latitude] ;
}




+ (AFSecurityPolicy *)customSecurityPolicy
{
    
    //先导入证书，找到证书的路径
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"kangzhuangxueche" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}

+(void)GET:(NSString *)urlStr parameters:(NSDictionary *)dict progress:(void (^)(NSProgress *))progress succeed:(void (^)(id))succeed failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //HTTPS SSL的验证，在此处调用上面的代码，给这个证书验证；
//    [manager setSecurityPolicy:[HttpsTools customSecurityPolicy]];
    
    // 加上这行代码，https ssl 验证。
    if(NO)
    {
        [manager setSecurityPolicy:[HttpsTools customSecurityPolicy]];
    }
    else
    {
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
    }
    
    [manager GET:@"" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
        NSLog(@"");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeed(responseObject);
        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+(void)POST:(NSString *)urlStr parameter:(NSDictionary *)dict progress:(void (^)(NSProgress *))progress succeed:(void (^)(id))succeed failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //HTTPS SSL的验证，在此处调用上面的代码，给这个证书验证；
    if(NO)
    {
        [manager setSecurityPolicy:[HttpsTools customSecurityPolicy]];
    }
    else
    {
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
    }
    
    [manager POST:urlStr parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        
        NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        int code = [dicJson[@"code"] intValue];
        
        if (2 == code) {
//            PopView *pop = [PopView logoutWithPopview];
//            [pop show];
            
        }else
        {
            succeed(dicJson);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (void)kPOST:(NSString *)urlStr parameter:(NSDictionary *)dict progress:(void(^)(NSProgress *downloadProgress))progress succeed:(void(^)(id backdata,int code ,NSString *msg))succeedInfoOthers failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //HTTPS SSL的验证，在此处调用上面的代码，给这个证书验证；
    if(NO)
    {
        [manager setSecurityPolicy:[HttpsTools customSecurityPolicy]];
    }
    else
    {
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
    }

    
    
    [manager POST:urlStr parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;

        NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
        int code = [dicJson[@"code"] intValue];
        
        if (2 == code) {
//            PopView *pop = [PopView logoutWithPopview];
//            [pop show];
            
        }else
        {
            NSDictionary *info = dicJson[@"info"];
            
            NSString *msg = dicJson[@"msg"];
            
            succeedInfoOthers(info,code,msg);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        [self.hudManager dismissSVHud];
    }];
}
- (void)test
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //get
    [manager GET:@"" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    //post
    [manager POST:@"" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"");
    }];
    
    //上传
    [manager POST:@"" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSLog(@"");
        
        //上传文件参数
        UIImage *iamge = [UIImage imageNamed:@"123.png"];
        NSData *data = UIImagePNGRepresentation(iamge);
        //这个就是参数
        [formData appendPartWithFileData:data name:@"file" fileName:@"123.png" mimeType:@"image/png"];

        /**
         *  第二种是通过URL来获取路径，进入沙盒或者系统相册等等
         */
//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"文件地址"] name:@"file" fileName:@"1234.png" mimeType:@"application/octet-stream" error:nil];
        
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        NSLog(@"");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"");
    }];

}

@end
