//
//  LoginGuideController.m
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/7/26.
//  Copyright © 2016年 cqingw. All rights reserved.
//


#import "LoginGuideController.h"
#import "LoginViewController.h"
#import "RegisterController.h"

@interface LoginGuideController ()

@end

@implementation LoginGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"5cb6ff"];
    [self setupNav];
    self.topConstraint.constant = autoScaleH(143);
    self.registerBtn.layer.cornerRadius = 5.0f;
    self.registerBtn.clipsToBounds = YES;
    self.loginBtn.layer.cornerRadius = 5.0f;
    self.loginBtn.clipsToBounds = YES;
    
    [self.registerBtn setborderWidth:1.0 borderColor:[UIColor colorWithHexString:@"5cb6ff"]];
    
    [self.loginBtn setborderWidth:1.0 borderColor:[UIColor colorWithHexString:@"5cb6ff"]];
    
    self.loginBtn.backgroundColor = [UIColor whiteColor];
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"5cb6ff"] forState:UIControlStateNormal];
}
-(void)rightClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setupNav
{
    [self createNavWithLeftBtnImageName:nil leftHighlightImageName:nil leftBtnSelector:nil andCenterTitle:nil andRightBtnImageName:@"iconfont-x" rightHighlightImageName:nil rightBtnSelector:@selector(rightClick)];
    
    //设置y值从屏幕最上方开始
    if (IOS7_OR_LATER && [self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    //开启导航栏透明。使得y值从最上方开始
    [self.navigationController.navigationBar setTranslucent:YES];
    //设置导航栏渲染色
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    //导航栏变为透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:0];
    //让黑线消失的方法
    self.navigationController.navigationBar.shadowImage=[UIImage new];

}
- (IBAction)loginBtnClick:(id)sender {
    LoginViewController *login = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:login animated:YES];
    
}

- (IBAction)registerBtnClick:(id)sender {
    RegisterController *registerVC = [[RegisterController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
@end
