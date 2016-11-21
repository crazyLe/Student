//
//  ExamRankController.m
//  学员端
//
//  Created by zuweizhong  on 16/8/15.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "ExamRankController.h"
#import <WebViewJavascriptBridge.h>
#import "UMSocial.h"

@interface ExamRankController ()<UIWebViewDelegate,UMSocialUIDelegate>

@property(nonatomic,strong)UIWebView * webView;
@property(nonatomic,strong)WebViewJavascriptBridge * bridge;

@end

@implementation ExamRankController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self.subjectNum isEqualToString:@"一"]) {
           [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"科一模考排行榜"];
    } else {
        [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"科四模考排行榜"];
    }
    
    UIWebView *webView = [[UIWebView alloc]init];
    webView.backgroundColor = [UIColor whiteColor];
    self.webView = webView;
    self.webView.delegate = self;
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
        }
    }];


}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"加载失败.html" ofType:nil];
    NSString *str = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:str baseURL:nil];
    
}
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
