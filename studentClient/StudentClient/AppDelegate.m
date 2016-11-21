//
//  AppDelegate.m
//  学员端
//
//  Created by zuweizhong  on 16/7/8.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import <Bugtags/Bugtags.h>
#import <LCTabBarController.h>
#import "HomeViewController.h"
#import "WalletViewController.h"
#import "CircleViewController.h"
#import "MeViewController.h"
#import "LocationManager.h"
#import "AutoScaleManager.h"
#import "LoginGuideController.h"
#import "ExamQuestionDataBase.h"
#import "AddressManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "JPUSHService.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "HcdGuideViewManager.h"
#import "CheckVersionManager.h"
#import "PPDLoanSdk.h"

static NSString *const kPPDSDKAPPID = @"8ce2ac99984641faaaf3e5293f4d2e26";
static NSString *const kPPDSDKPublicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCzGS8AXAxqEvpnO48fdWLe0wAJ2TQVaQpJCvrrhC2RK8ULiI0g5suEqj7Odwk6pw2/lGQV/zCE6vBoe+oU6cx6l5/dvSjmuA+tXOe5cHbsTRHnthIRW+iTuDuoeYBhx91bC0RpecZ3uW9sgMj65ERb8IxmC8V1UbJ2JVLgPI5r5QIDAQAB";
static NSString *const kPPDSDKPrivateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALMZLwBcDGoS+mc7jx91Yt7TAAnZNBVpCkkK+uuELZErxQuIjSDmy4SqPs53CTqnDb+UZBX/MITq8Gh76hTpzHqXn929KOa4D61c57lwduxNEee2EhFb6JO4O6h5gGHH3VsLRGl5xne5b2yAyPrkRFvwjGYLxXVRsnYlUuA8jmvlAgMBAAECgYBFalheQk8JeeuVwW7amYvFo3BbYNUgC0NSRjA0wllK7/UCYF2ax/lPpRCMw3RPSFo6y8/y+qKakdi2FnkGvAtlPomq70pnXnjX/c8cwFaARHtl7E09f88VRzfhAJfLOZ/0zGhnJP5cxqJTIDFGPs3o2L78Q8s41PhnIAZmChn+IQJBANj6N9xGkT/4+j+K3izRJzH840ue1Uom3k+Cz4i/NVlIniOKFF5VfuMa4In4zVnZH7qoTgtiFSM9S/NWXyfZq+0CQQDTTv1Wt3lekXL/8WfXr49bsAnKZPIQR4SWJ1WGMDA3mhCpohalz9TrBSRSw5NXXEW6WjOmDRQg3BBR4QeupHDZAkBE+fZ8HirarWnQfXL3yF2vdHdFeO7RLd4KZMlY7YAmLAGpxqGHA6Lcy5SKCAAwCegeTJbS45FYrInSh6ikYHxZAkBg7YTL+FFWDcYAnU2S5FcQKcnz6yYWTZgGAHj8mrIjbyphhZZ57MGwJKWqyUeW9R6PAr1aV/l5sThTNrP9ajTRAkEAm9rVjygjVYl6mv6YO6r/3mh9Fdc1fn9/TM1A3gaqwrfSn9q8a7CZP/NR0iBn8oTrUicsEXkoMooCcuwJfcXVmA==";


@interface AppDelegate ()<WXApiDelegate>


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //崩溃日志收集
    BugtagsOptions *options = [[BugtagsOptions alloc] init];
    options.trackingCrashes = YES;
    options.trackingNetwork = YES;
    [Bugtags startWithAppKey:@"cf0db6e9032313decb151a3b339b84f7" invocationEvent:BTGInvocationEventNone options:options];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    //设置电池条为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    [self setupThirdSDKConfigWithOptions:launchOptions];
    
    //默认不展示赚豆
    [USER_DEFAULT setObject:@(NO) forKey:@"BeansShow"];
    // 启动将 弹屏设置为 未弹过
    [USER_DEFAULT setObject:@(NO) forKey:@"hasPopedADView"];

    [USER_DEFAULT synchronize];

    return YES;
}

- (void)setupThirdSDKConfigWithOptions:(NSDictionary *)launchOptions {
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;

#pragma warning  拍拍贷 加这句模拟器跑会崩溃，只能真机跑
    [LoansSDK loadPPDLoanSDKInit:kPPDSDKAPPID publicKey:kPPDSDKPublicKey privateKey:kPPDSDKPrivateKey];
    
    //开始定位
    [[LocationManager sharedLocationManager] startLocationWithFinishSuccessBlock:^(CGFloat longitude, CGFloat latitude, NSString *locationString, NSDictionary *addressDictionary, CLPlacemark *placeMark) {
        HJLog(@"%f-------%f--------%@-------%@",longitude,latitude,locationString,addressDictionary);
        NSString *province = addressDictionary[@"State"];
        NSString *str = [province substringToIndex:province.length - 1];
        [USER_DEFAULT setObject:str forKey:@"province"];
    }];

    //配置数据库
    [self configDataBase];

    //配置根控制器
    [self configRootController];

    //向微信终端注册ID，这里的APPID一般建议写成宏,容易维护
    [WXApi registerApp:@"wx91df4f13f335929f" withDescription:@"康庄学员"];

    [UMSocialData setAppKey:@"57b8236de0f55a35c600157d"];

    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx91df4f13f335929f" appSecret:@"51ed515bfb76a7398c95390f102d955d" url:@"http://www.umeng.com/social"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"1105631066" appKey:@"TnQZFnrVhaviaauu" url:@"http://www.umeng.com/social"];

    [self configJpush:launchOptions];
}


-(void)configRootController {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //根据版本号来判断是否需要显示引导页，一般来说每更新一个版本引导页都会有相应的修改
    BOOL show = [userDefaults boolForKey:[NSString stringWithFormat:@"version_%@", version]];
    
    if (show) {
        [self setTabBarRootViewController];
        return;
    }

    self.window.rootViewController = [[UIViewController alloc]init];
    
    NSMutableArray *images = [NSMutableArray new];
    
    [images addObject:[UIImage imageNamed:@"闪屏-1"]];
    [images addObject:[UIImage imageNamed:@"闪屏-2"]];
    [images addObject:[UIImage imageNamed:@"闪屏-3"]];
    [[HcdGuideViewManager sharedInstance] showGuideViewWithImages:images
                                                   andButtonTitle:@""
                                              andButtonTitleColor:[UIColor whiteColor]
                                                 andButtonBGColor:[UIColor clearColor]
                                             andButtonBorderColor:[UIColor whiteColor]
     
                                                    startBtnblock:^{
                                                        
                                                        [self setTabBarRootViewController];
                                                        
                                                    }];
}

-(void)configJpush:(NSDictionary *)launchOptions {
    //Required
    //可以添加自定义categories
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];

    //Required
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"556bba4c86aa93866b9ec721"
                          channel:@"Publish channel"
                 apsForProduction:NO];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


-(void)configDataBase {
    if (kQuestionErrorRateTimeString) {
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy-MM-dd";
        NSDate *lastDate = [df dateFromString:kQuestionErrorRateTimeString];
        NSDate *after7Date = [GHDateTools dateByAddingDays:lastDate day:7];
        NSDate *currentDate = [NSDate date];
        NSString *after7DateStr = [df stringFromDate:after7Date];
        NSString *currentDateStr = [df stringFromDate:currentDate];

        if ([GHDateTools compareDate:after7DateStr withDate:currentDateStr]==1) {
            //获取试题错误率，每周同步一次
            [self loadInCorrectRadio];
        }
    } else {
        //获取试题错误率，每周同步一次
        [self loadInCorrectRadio];
    }
}

-(void)loadInCorrectRadio {
    NSString *url = self.interfaceManager.getErrorRate;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/errorRate" time:time];
    param[@"deviceInfo"] =[HttpParamManager getDeviceInfo];
    param[@"cityId"] = @([HttpParamManager getCurrentCityID]);
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {
            NSArray *arr = dict[@"info"];
 
            //异步更新数据库
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
                for (NSDictionary *dic in arr) {
                    int idNum = [dic[@"id"] intValue];
                    [[ExamQuestionDataBase shareInstance] updateErrorRateWithRate:dic[@"rate"] questionId:idNum];
                }
            });
            NSDate *date = [NSDate date];
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            df.dateFormat = @"yyyy-MM-dd";
            NSString *dateStr = [df stringFromDate:date];
            [USER_DEFAULT setObject:dateStr forKey:@"QuestionErrorRateTime"];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            });
        }
   
    } failed:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
        });
    }];
}

-(void)setTabBarRootViewController {
    HomeViewController *home = [[HomeViewController alloc] init];
    home.title = @"首页";
    home.tabBarItem.image = [UIImage imageNamed:@"首页"];
    home.tabBarItem.selectedImage = [UIImage imageNamed:@"首页_selected"];
    
    WalletViewController *wallet = [[WalletViewController alloc] init];
    wallet.title = @"钱袋";
    wallet.tabBarItem.image = [UIImage imageNamed:@"钱袋"];
    wallet.tabBarItem.selectedImage = [UIImage imageNamed:@"钱袋_selected"];
    
    CircleViewController *circle = [[CircleViewController alloc] init];
    circle.title = @"圈子";
    circle.tabBarItem.image = [UIImage imageNamed:@"圈子"];
    circle.tabBarItem.selectedImage = [UIImage imageNamed:@"圈子_selected"];
    
    
    MeViewController *me = [[MeViewController alloc] init];
    me.title = @"我的";
    me.tabBarItem.image = [UIImage imageNamed:@"我的"];
    me.tabBarItem.selectedImage = [UIImage imageNamed:@"我的_selected"];
    
    JTNavigationController *navC1 = [[JTNavigationController alloc] initWithRootViewController:home];
    navC1.fullScreenPopGestureEnabled = YES;
    
    JTNavigationController *navC2 = [[JTNavigationController alloc] initWithRootViewController:wallet];
    navC2.fullScreenPopGestureEnabled = YES;
    
    JTNavigationController *navC3 = [[JTNavigationController alloc] initWithRootViewController:circle];
    navC3.fullScreenPopGestureEnabled = YES;
    
    JTNavigationController *navC4 = [[JTNavigationController alloc] initWithRootViewController:me];
    navC4.fullScreenPopGestureEnabled = YES;
    
    
    LCTabBarController *tabBarC    = [[LCTabBarController alloc] init];
    tabBarC.view.backgroundColor   = [UIColor whiteColor];
    tabBarC.itemTitleFont          = [UIFont systemFontOfSize:11];
    tabBarC.itemTitleColor         = [UIColor darkGrayColor];
    tabBarC.selectedItemTitleColor = [UIColor colorWithHexString:@"#5bb6ff"];
    tabBarC.itemTitleColor = [UIColor colorWithHexString:@"#848484"];
    tabBarC.viewControllers = @[navC1, navC2, navC3, navC4];
    self.window.rootViewController = tabBarC;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (_allowRotation == 1) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return (UIInterfaceOrientationMaskPortrait);
    }
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate {
    if (_allowRotation == 1) {
        return YES;
    }
    return NO;
}

//只要是调用手机上的支付宝客户端，在支付宝客户端操作完成返回自己的app时，都会调用这个方法,
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK（这个是将支付宝客户端的支付结果传回给SDK）
        if ([url.host containsString:@"safepay"]) {
            [[AlipaySDK defaultService]
             processOrderWithPaymentResult:url
             standbyCallback:^(NSDictionary *resultDic)
             {
                 NSLog(@"result = %@",resultDic);
                 int code = [resultDic[@"resultStatus"] intValue];
                 if (9000 == code) {
                     [NOTIFICATION_CENTER postNotificationName:@"ALIPAYSUCCEED" object:nil];
                 }
                 NSLog(@" ------result = %@",resultDic);//返回的支付结果3
             }];
            return YES;
        } else {
            //9.0后的方法微信
            return [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}

//前面的两个方法被iOS9弃用了，如果是Xcode7.2网上的话会出现无法进入进入微信的onResp回调方法，就是这个原因。本来我是不想写着两个旧方法的，但是一看官方的demo上写的这两个，我就也写了。。。。
//9.0前的方法，为了适配低版本 保留
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK（这个是将支付宝客户端的支付结果传回给SDK）
        if ([url.host containsString:@"safepay"]) {
            [[AlipaySDK defaultService]
             processOrderWithPaymentResult:url
             standbyCallback:^(NSDictionary *resultDic)
             {
                 NSLog(@"result = %@",resultDic);
                 int code = [resultDic[@"resultStatus"] intValue];
                 if (9000 == code) {
                     [NOTIFICATION_CENTER postNotificationName:@"ALIPAYSUCCEED" object:nil];
                 }
                 NSLog(@" ------result = %@",resultDic);//返回的支付结果
             }];
            return YES;
        } else {
            //9.0后的方法微信
            return [WXApi handleOpenURL:url delegate:self];
        }
    }
    return result;
}



//微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法,显示支付结果的
-(void) onResp:(BaseResp*)resp {
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0:
                payResoult = @"支付结果：成功！";
                [[NSNotificationCenter defaultCenter] postNotificationName:kWeiXinPaySuccessNotification object:nil];
                break;
            case -1:
                payResoult = @"支付结果：失败！";
                [[NSNotificationCenter defaultCenter] postNotificationName:kWeiXinPayFailNotification object:nil];

                break;
            case -2:
                payResoult = @"用户已经退出支付！";
                [[NSNotificationCenter defaultCenter] postNotificationName:kWeiXinPayFailNotification object:nil];

                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                [[NSNotificationCenter defaultCenter] postNotificationName:kWeiXinPayFailNotification object:nil];
                break;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [JPUSHService setBadge:0];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [JPUSHService setBadge:0];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    
    //检查版本
    [[CheckVersionManager sharedCheckVersionManager] checkVersion];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
