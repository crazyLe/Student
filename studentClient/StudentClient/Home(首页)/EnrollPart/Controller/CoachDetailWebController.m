//
//  CoachDetailWebController.m
//  学员端
//
//  Created by zuweizhong  on 16/8/16.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "CoachDetailWebController.h"
#import <WebViewJavascriptBridge.h>
#import "OrderInfoModel.h"
#import "UMSocial.h"
#import "VouchPopView.h"
#import "MyOderExtraVC.h"
#import "UIView+Cover.h"
@interface CoachDetailWebController ()<UIWebViewDelegate,UMSocialUIDelegate,VouchPopViewDelegate>

@property(nonatomic,strong)WebViewJavascriptBridge * bridge;
@property(nonatomic,strong)UIWebView * webView;
@property(nonatomic,assign)int currentVouchId;
@property(nonatomic,strong)VouchPopView *popView;
@property(nonatomic,strong)UIView * coverView;

@end

@implementation CoachDetailWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:_titleString];
    
    UIWebView *webView = [[UIWebView alloc]init];
    webView.backgroundColor = [UIColor whiteColor];
    self.webView = webView;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlString]];
    
    [webView loadRequest:request];
    
    webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [self.view addSubview:webView];
    
    
    //JS和OC交互

    if(_bridge){
        return;
    }
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    
    [_bridge setWebViewDelegate:self];
    
    WeakSelf(self)
    
    [_bridge registerHandler:@"objcHander" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"objcHander called: %@", data);
        responseCallback(@"Response from testObjcCallback");
        NSString *param = data[@"parame"];
        NSArray *arr = [param componentsSeparatedByString:@":"];
        if ([arr[0] isEqualToString:@"coach"]) {
            if (kLoginStatus) {
                NSString *idStr = arr[2];
                //跳转支付
                [weakself.hudManager showNormalStateSVHUDWithTitle:nil];
                NSString * url = weakself.interfaceManager.loadOrderUrl;
                NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
                paramDict[@"uid"] = kUid;
                NSString * time = [HttpParamManager getTime];
                paramDict[@"time"] = time;
                paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/loadOrder" time:time];
                paramDict[@"productId"] = idStr;
                paramDict[@"orderType"] = @(2);
                paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
                
                [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
                    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    HJLog(@">>>%@",dict);
                    NSInteger code = [dict[@"code"] integerValue];
                    NSString * msg = dict[@"msg"];
                    if (code == 1) {
                        NSDictionary * infoDict = [dict objectForKey:@"info"][@"orderInfo"];
                        OrderInfoModel * orderInfoModel = [OrderInfoModel mj_objectWithKeyValues:infoDict];
                        MyOderExtraVC *vc = [[MyOderExtraVC alloc] init];
                        vc.orderInfoModel = orderInfoModel;
                        vc.orderType = 2;
                        [weakself.navigationController pushViewController:vc animated:YES];
                        [weakself.hudManager dismissSVHud];
                        
                    } else {
                        [weakself.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
                    }
                } failed:^(NSError *error) {
                    [weakself.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
                }];
            } else {
            
                LoginGuideController * vc = [[LoginGuideController alloc]init];
            
                JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
            
                [self presentViewController:nav animated:YES completion:nil];
            }
        }

        if ([param hasPrefix:@"Share:"]) {

            NSString *urlStr = [param substringFromIndex:6];
            //如果需要分享回调，请将delegate对象设置self，并实现下面的回调方法
            [UMSocialData defaultData].extConfig.title = @"康庄学车微名片";
            [UMSocialData defaultData].extConfig.qqData.url = urlStr;
            [UMSocialData defaultData].extConfig.qzoneData.url = urlStr;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = urlStr;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlStr;
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"507fcab25270157b37000010"
                                              shareText:urlStr
                                             shareImage:[UIImage imageNamed:@"图标"]
                                        shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]
                                               delegate:self];
            return;
        }
        
        if ([arr[0] isEqualToString:@"Coupon"]) {
            
            if (kLoginStatus) {
                weakself.currentVouchId = [arr[2] intValue];
                //领取代金券
                [weakself getDaiJingQuan];
            } else {
                LoginGuideController * vc = [[LoginGuideController alloc]init];
                
                JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
                
                [self presentViewController:nav animated:YES completion:nil];
            }
        }
    }];
}

-(void)vouchPopViewDidClickKnowBtn:(VouchPopView *)popView {
    self.view.touchCoverHandler(self.coverView);
}
#pragma mark - 代金券
-(void)getDaiJingQuan
{
    __weak typeof(self) weakSelf = self;
    
    //领取代金券
    [self.hudManager showNormalStateSVHUDWithTitle:@"领取中..."];
    
    NSString * url = self.interfaceManager.reveiveVouchers;
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    
    paramDict[@"couponsId"] = @(self.currentVouchId);
    
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/coupon/ReceiveVouchers" time:time couponsId:self.currentVouchId];
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"++++%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            
            NSDictionary *subdict = dict[@"info"];
            VouchersListModel *model = [VouchersListModel mj_objectWithKeyValues:subdict];
            self.view.touchCoverHandler = ^(UIView *cover){
                
                [weakSelf.coverView removeFromSuperview];
                
                [weakSelf.popView removeFromSuperview];
                
            };
            self.coverView = self.view.translucentCoverView;
            //添加蒙版
            [self.view addSubview:self.coverView];
            //添加
            VouchPopView *popView = [[[NSBundle mainBundle]loadNibNamed:@"VouchPopView" owner:nil options:nil]lastObject];
            self.popView = popView;
            //复制给View
            self.popView.vouchers = model;
            self.popView.delegate = self;
            popView.frame = CGRectMake(20*AutoSizeScaleX, 0, kScreenWidth-40*AutoSizeScaleX,  (kScreenWidth-40*AutoSizeScaleX)*1.3);
            popView.center = CGPointMake(self.view.centerX, self.view.centerY-100);
            CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            k.values = @[@(0.1),@(1.0),@(1.1)];
            k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(0.9),@(1.0)];
            k.calculationMode = kCAAnimationLinear;
            [_popView.layer addAnimation:k forKey:@"SHOW"];
            [self.view addSubview:_popView];
            
            [self.hudManager dismissSVHud];
        }
        else
        {
            
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
        }
        
        
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        
    }];
    
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"加载失败.html" ofType:nil];
    NSString *str = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:str baseURL:nil];
    
}
- (void)back{
    if (self.webView.canGoBack) {
        [self.webView goBack];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
