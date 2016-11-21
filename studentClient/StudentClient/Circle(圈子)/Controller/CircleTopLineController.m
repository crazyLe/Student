//
//  CircleTopLineController.m
//  学员端
//
//  Created by zuweizhong  on 16/8/23.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "JSInteractiveManager.h"

#import "CircleTopLineController.h"

@interface CircleTopLineController ()<UIWebViewDelegate>
@property(nonatomic,strong)UISegmentedControl * segmentControl;

@end

@implementation CircleTopLineController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configNav];
    [self createSegment];
    
    _webView = [[UIWebView alloc]init];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&app=1&uid=%@",self.url,kUid]]];
    
    [_webView loadRequest:request];
    
    _webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    [self.view addSubview:_webView];
    
    if (self.js_Manager) {
        self.js_Manager.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
        [self.js_Manager.bridge setWebViewDelegate:self];
        self.js_Manager.block(self);
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"加载失败.html" ofType:nil];
    NSString *str = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:str baseURL:nil];
}

-(void)configNav {
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(clickLeftBtn:) andCenterTitle:nil andRightBtnImageName:@"" rightHighlightImageName:nil rightBtnSelector:nil];
}

- (void)createSegment {
    NSArray * segmentArray = @[@"头条",@"话题"];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:segmentArray];
    _segmentControl.selectedSegmentIndex = 0;
    //设置segment的选中背景颜色
    _segmentControl.tintColor = [UIColor whiteColor];
    [_segmentControl setTitleTextAttributes:@{NSFontAttributeName:kFont13} forState:UIControlStateNormal];
    _segmentControl.frame = CGRectMake(100, 0, kScreenWidth -200, 30);
    [_segmentControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentControl;
}

-(void)segmentValueChanged:(UISegmentedControl *)segmentControl {
    if (segmentControl.selectedSegmentIndex == 0) {
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&app=1&uid=%@",self.url,kUid]]];
        
        [_webView loadRequest:request];
    } else {
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&app=1&uid=%@",self.url2,kUid]]];
        [_webView loadRequest:request];
    }
}

- (void)clickLeftBtn:(UIButton *)leftBtn {
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)setUrl:(NSString *)url {
    if (_url != url) {
        _url = url;
        BOOL needChange = NO;
        NSMutableString *urlStr = [url mutableCopy];
        if (![urlStr containsString:@"app"]) {
            [urlStr appendString:@"&app=1"];
            needChange = YES;
        }
//        if (![urlStr containsString:@"uid"]) {
//            [urlStr appendString:[NSString stringWithFormat:@"&uid=%@",kUid]];
//            needChange = YES;
//        }
        if (needChange) {
            _url = urlStr;
        }
    }
}

- (void)setUrl2:(NSString *)url2 {
    if (_url2 != url2) {
        _url2 = url2;
        BOOL needChange = NO;
        NSMutableString *urlStr = [url2 mutableCopy];
        if (![urlStr containsString:@"app"]) {
            [urlStr appendString:@"&app=1"];
            needChange = YES;
        }
//        if (![urlStr containsString:@"uid"]) {
//            [urlStr appendString:[NSString stringWithFormat:@"&uid=%@",kUid]];
//            needChange = YES;
//        }
        if (needChange) {
            _url2 = urlStr;
        }
    }
}

@end
