//
//  StudentPersonalController.m
//  学员端
//
//  Created by zuweizhong  on 16/8/15.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "StudentPersonalController.h"
#import <WebViewJavascriptBridge.h>
#import "MyOderExtraVC.h"

@interface StudentPersonalController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,strong)WebViewJavascriptBridge *bridge;

@end

@implementation StudentPersonalController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:_titleString];
    
    UIWebView *webView = [[UIWebView alloc]init];
    self.webView = webView;
    self.webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    
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
        StrongSelf(self)
        NSLog(@"objcHander called: %@", data);
        responseCallback(@"Response from testObjcCallback");
        NSString *param = data[@"parame"];
        NSArray *arr = [param componentsSeparatedByString:@":"];
        if ([arr[0] isEqualToString:@"Personal"]) {
            
            if (kLoginStatus) {
                
                NSString *idStr = arr[2];
                NSString *itemId = arr[3];
                //跳转支付
                [self.hudManager showNormalStateSVHUDWithTitle:nil];
                NSString * url = self.interfaceManager.loadOrderUrl;
                NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
                paramDict[@"uid"] = kUid;
                NSString * time = [HttpParamManager getTime];
                paramDict[@"time"] = time;
                paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/loadOrder" time:time];
                paramDict[@"productId"] = idStr;
                paramDict[@"orderType"] = @(3);
                paramDict[@"itemId"] = itemId;
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
                        vc.orderType = 3;
                        [self.navigationController pushViewController:vc animated:YES];
                        [self.hudManager dismissSVHud];
                        
                    } else {
                        [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
                    }
                } failed:^(NSError *error) {
                    
                    [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
                }];

            } else {
                LoginGuideController * vc = [[LoginGuideController alloc]init];
                JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }
        }
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.dynamicTitle) {
        NSString *urlString = webView.request.URL.absoluteString;
        NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.title = str.length > 0 ? str : urlString;
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"加载失败.html" ofType:nil];
    NSString *str = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:str baseURL:nil];
}

- (void)back {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
