//
//  CheckVersionManager.m
//  学员端
//
//  Created by zuweizhong  on 16/8/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "AddressManager.h"
#import "CheckVersionManager.h"

@implementation CheckVersionManager

singletonImplementation(CheckVersionManager)

-(void)checkVersion
{
    [self loadVersion];
}
-(void)loadVersion
{
    NSString *url = self.interfaceManager.checkVersion;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    param[@"version"] = versioncode;
    param[@"channel"] = @(1);
    param[@"time"] = time;
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        if (code == 1)
        {
            //服务器时间
            NSString *servertime = dict[@"info"][@"serverTime"];
            
            NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[dat timeIntervalSince1970];
            //当前时间
            NSString *timeString = [NSString stringWithFormat:@"%d", (int)a];
            
            //时间间隔
            NSInteger jiange = [servertime integerValue] - [timeString integerValue];
            
            [[NSUserDefaults standardUserDefaults] setInteger:jiange forKey:@"jiange"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            NSString *updateCode = dict[@"info"][@"updateCode"];
            NSString *updateInfo = dict[@"info"][@"updateInfo"];
            NSString *updateUrl = dict[@"info"][@"updateUrl"];

            BOOL beansShow = [dict[@"info"][@"beans_show"] boolValue];
            
            [USER_DEFAULT setObject:@(beansShow) forKey:@"BeansShow"];
            [USER_DEFAULT synchronize];
            NSLog(@"dsddcc-----%d",kBeansShow);
            
            NSString *area_ver = dict[@"info"][@"area_ver"];
            
            area_ver = [NSString stringWithFormat:@"%@",area_ver];
            
            NSString *old_area_ver = [kUserDefault objectForKey:@"CoachAreaVersion"];
            
            BOOL isCacheProvinceData = [[kUserDefault objectForKey:cacheProvinceDataKey] boolValue];
            BOOL isCacheCityData = [[kUserDefault objectForKey:cacheCityDataKey] boolValue];
            BOOL isCacheCountyData = [[kUserDefault objectForKey:cacheCountyDataKey] boolValue];

            if (!old_area_ver || !isCacheProvinceData || !isCacheCityData || !isCacheCountyData || ![area_ver isEqualToString:old_area_ver]) {
                //更新地址数据
                [[AddressManager sharedAddressManager] updateAddressInfo];
            }

            [NOTIFICATION_CENTER postNotificationName:kRefreshBeansShowNotification object:nil];

            if ([updateCode isEqualToString:@"1"]) {//建议升级
                UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"有新版本"
                                                                                  message:updateInfo
                                                                           preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                                         nil;
                                                                     }];
                UIAlertAction *upgradeAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // 通过获取到的url打开应用在appstore，并跳转到应用下载页面
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
                }];
                [alertCtl addAction:cancelAction];
                [alertCtl addAction:upgradeAction];
                
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtl animated:YES completion:nil];
            }
            if ([updateCode isEqualToString:@"2"]) {//强制升级
                UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"有新版本"
                                                                                  message:updateInfo
                                                                           preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *upgradeAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    // 通过获取到的url打开应用在appstore，并跳转到应用下载页面
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
                }];
                
                [alertCtl addAction:upgradeAction];
                
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtl animated:YES completion:nil];
            }
        }

    } failed:^(NSError *error) {
        
    }];
}
@end
