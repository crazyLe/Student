//
//  ActionWebController.m
//  学员端
//
//  Created by 翁昌青 on 16/8/8.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "ActionWebController.h"

@interface ActionWebController ()

@end

@implementation ActionWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createNavigationBar];
    
    if (_urlstr.length == 0) {
        _urlstr = @"http//:www.baidu.com";
    }
    
    NSURL *url = [NSURL URLWithString:_urlstr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_web loadRequest:request];


    
}
- (void)createNavigationBar {
    
    self.navigationItem.leftBarButtonItem.customView =  [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftAction) andCenterTitle:nil];

}

-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
