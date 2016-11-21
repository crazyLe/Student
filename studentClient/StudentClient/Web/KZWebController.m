//
//  KZWebController.m
//  StudentClient
//
//  Created by sky on 2016/9/23.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "KZWebController.h"
#import <WebViewJavascriptBridge.h>
#import "MyOderExtraVC.h"

@interface KZWebController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *aWebView;

@property(nonatomic,strong)WebViewJavascriptBridge *bridge;

@end

@implementation KZWebController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(backAction) andCenterTitle:self.title];

    self.aWebView.delegate = self;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.webURL]];
    [self.aWebView loadRequest:request];

    if (self.withOrderInteration) {
        //JS和OC交互

        if(_bridge){
            return;
        }

        [WebViewJavascriptBridge enableLogging];

        _bridge = [WebViewJavascriptBridge bridgeForWebView:self.aWebView];

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
}

- (void)backAction {
    if (self.aWebView.canGoBack) {
        [self.aWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.dynamicTitle) {
        NSString *urlString = webView.request.URL.absoluteString;
        NSString *str = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.title = str.length > 0 ? str : urlString;
    }
}

@end
