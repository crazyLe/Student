//
//  WebHtmlController.m
//  学员端
//
//  Created by mac on 16/8/31.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "WebHtmlController.h"

@interface WebHtmlController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView * webView;

@end

@implementation WebHtmlController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:_titleString];
    
    UIWebView *webView = [[UIWebView alloc]init];
    self.webView = webView;
    self.webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    [webView loadHTMLString:_htmlString baseURL:nil];
    webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [self.view addSubview:webView];
}


- (void)back{
    
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"加载失败.html" ofType:nil];
    NSString *str = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:str baseURL:nil];
    
}
@end
