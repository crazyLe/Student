//
//  ZhuanXueFeiController.m
//  学员端
//
//  Created by zuweizhong  on 16/8/15.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "ZhuanXueFeiController.h"
@interface ZhuanXueFeiController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;

@end

@implementation ZhuanXueFeiController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:_titleString];
    
    UIWebView *webView = [[UIWebView alloc]init];
    self.webView = webView;
    self.webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlString]];
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    [webView loadRequest:request];
    webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [self.view addSubview:webView];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"req>>%@", request);
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"err>>%@", error);
    return;
#warning 待处理 web与原生交互，为赶上线暂时放到最后处理
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"加载失败.html" ofType:nil];
//    NSString *str = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    [self.webView loadHTMLString:str baseURL:nil];
}

@end
