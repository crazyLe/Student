//
//  LoginViewController.m
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/7/26.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "LoginViewController.h"
#import "ValidateHelper.h"
#import "AppDelegate.h"
#import "JpushManager.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    NSTimer *_timerOld;
}
@property (weak, nonatomic) IBOutlet UITextField *mobileTextF;

@property (weak, nonatomic) IBOutlet UIImageView *hudImageView;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;


- (IBAction)getCodeBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnClick:(id)sender;
@property(nonatomic,strong)UISegmentedControl * segmentControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeWidthConstraint;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"5cb6ff"];

    [self setupNav];
    
    [self createSegment];
    
    [self configUI];
    
}
-(void)configUI
{
    self.mobileTextF.textColor = [UIColor whiteColor];
    self.passwordTextF.textColor = [UIColor whiteColor];
    self.mobileTextF.font = [UIFont systemFontOfSize:14];
    self.passwordTextF.font = [UIFont systemFontOfSize:14];
    [self.mobileTextF setValue:[UIColor colorWithHexString:@"bde2ff"] forKeyPath:@"_placeholderLabel.textColor"];
 
    [self.passwordTextF setValue:[UIColor colorWithHexString:@"bde2ff"] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.loginBtn.clipsToBounds = YES;
    self.loginBtn.layer.cornerRadius = 20.0f;
    
    self.getCodeBtn.clipsToBounds = YES;
    [self.getCodeBtn setborderWidth:LINE_HEIGHT borderColor:[UIColor colorWithHexString:@"bde2ff"]];
    self.getCodeBtn.layer.cornerRadius = 3.0f;
    
    self.codeWidthConstraint.constant = 0;
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];

}
- (void)createSegment
{
    NSArray * segmentArray = @[@"密码登录",@"验证码登录"];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:segmentArray];
    _segmentControl.selectedSegmentIndex = 0;
    //设置segment的选中背景颜色
    _segmentControl.tintColor = [UIColor whiteColor];
    _segmentControl.frame = CGRectMake(100, 0, kScreenWidth -200, 30);
    [_segmentControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentControl;
}
-(void)segmentValueChanged:(UISegmentedControl *)segmentControl
{
    if (segmentControl.selectedSegmentIndex == 1)
    {
        self.codeWidthConstraint.constant = 70;
        self.hudImageView.image = [UIImage imageNamed:@"注册登录切图iconfont-icon"];
        self.passwordTextF.placeholder = @"验证码";
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
    else
    {
        self.codeWidthConstraint.constant = 0;
        self.hudImageView.image = [UIImage imageNamed:@"iconfont-yanzhengma"];
        self.passwordTextF.placeholder = @"密码";
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    
    }

}
- (void)setupNav
{
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
    
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:nil];
    
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (IBAction)getCodeBtnClick:(id)sender {
    
    if (self.segmentControl.selectedSegmentIndex == 1) {//验证码登录
        if (![ValidateHelper validateMobile:self.mobileTextF.text]) {
            [self.hudManager showErrorSVHudWithTitle:@"手机号不正确" hideAfterDelay:1.0f];
            return;
        }
       
        [self.hudManager showNormalStateSVHUDWithTitle:nil];
        
        NSString *url = self.interfaceManager.getSendCode;
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        param[@"phone"] = self.mobileTextF.text;
        param[@"time"] = [HttpParamManager getTime];
        param[@"flag"] = @"login";

        [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            HJLog(@"%@",dict);
            NSInteger code = [dict[@"code"] integerValue];
            NSString *msg = dict[@"msg"];
            
            if (code == 1) {
                [self.hudManager dismissSVHud];
                //请求成功，取消按钮的点击
                self.getCodeBtn.userInteractionEnabled = NO;
                //设置验证码的button的title
                [self.getCodeBtn setTitle:@"60s后重新发送" forState:UIControlStateNormal];
                //self.codeBtnWidthConstraint.constant = 100;
                [self.getCodeBtn setborderWidth:LINE_HEIGHT borderColor:[UIColor colorWithHexString:@"d5d5d2"]];
                
                //倒计时
                _timerOld =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop]addTimer:_timerOld forMode:NSRunLoopCommonModes];
                
            }
            else
            {
                [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            }
            
            
            
        } failed:^(NSError *error) {
            [self.hudManager showErrorSVHudWithTitle:@"获取验证码失败" hideAfterDelay:1.0];
        }];
        
        
    }
    
}
-(void)timeChange
{
    NSString *time = [self.getCodeBtn.titleLabel.text substringWithRange:NSMakeRange(0, 2)];
    if ([time integerValue] == 0) {
        //倒计时结束，开启用户交互
        self.getCodeBtn.userInteractionEnabled = YES;
        [self.getCodeBtn setborderWidth:LINE_HEIGHT borderColor:[UIColor colorWithHexString:@"bde2ff"]];
        //self.codeBtnWidthConstraint.constant = 70;
        [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timerOld invalidate];
        _timerOld = nil;
        return;
    }
    
    NSString *str = [NSString stringWithFormat:@"%ds后重新发送",[time intValue]-1];
    [self.getCodeBtn setTitle:str forState:UIControlStateNormal];
    
    
}
- (IBAction)loginBtnClick:(id)sender
{
    [self.view endEditing:YES];
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在登录..."];
    
    if (self.segmentControl.selectedSegmentIndex == 0) {//密码登录
        
        if (![ValidateHelper validateMobile:self.mobileTextF.text]) {
            [self.hudManager showErrorSVHudWithTitle:@"手机号不正确" hideAfterDelay:1.0f];
            return;
        }
        
        if (![ValidateHelper validatePassword:self.passwordTextF.text]) {
            [self.hudManager showErrorSVHudWithTitle:@"密码必须在6-20位之间" hideAfterDelay:1.0f];
            return;
        }
        
        NSString *url = self.interfaceManager.loginUrl;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSString *time = [HttpParamManager getTime];

        param[@"phone"] = self.mobileTextF.text;
        param[@"password"] = self.passwordTextF.text;
        param[@"deviceInfo"] =[HttpParamManager getDeviceInfo];
        param[@"pushID"] = [HttpParamManager getUUID];
        param[@"loginChannel"] = @"1";

        param[@"time"] = time;
        param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/user/login"time:time];
       
        [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
            NSDictionary * jsonDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            HJLog(@">>>>%@",jsonDic);
            NSInteger code = [jsonDic[@"code"] integerValue];
            NSString * msgString = jsonDic[@"msg"];
            if (code == 1) {
                
                NSDictionary * infoDic = [jsonDic objectForKey:@"info"];
                NSString * uid = [infoDic objectForKey:@"uid"];
                NSString * token = [infoDic objectForKey:@"token"];
                [USER_DEFAULT setObject:uid forKey:@"uid"];
                [USER_DEFAULT setObject:token forKey:@"token"];
                [USER_DEFAULT setObject:self.mobileTextF.text forKey:@"mobile"];
                [USER_DEFAULT setObject:self.passwordTextF.text forKey:@"pwd"];
                [USER_DEFAULT setObject:@"1" forKey:@"isLogin"];
                [USER_DEFAULT synchronize];
                [self.hudManager dismissSVHud];
                //jpush监听
                [[JpushManager sharedJpushManager] startMonitor];
                //密码登录成功
                AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appD setTabBarRootViewController];
                
            }else {
                
                [self.hudManager showErrorSVHudWithTitle:msgString hideAfterDelay:1.0f];
                
            }
            
            
        } failed:^(NSError *error) {
            
            [self.hudManager showErrorSVHudWithTitle:@"登录失败" hideAfterDelay:1.0f];
            
        }];
        
    }
    
    
    else//验证码登录
    {
        if (![ValidateHelper validateMobile:self.mobileTextF.text]) {
            [self.hudManager showErrorSVHudWithTitle:@"手机号不正确" hideAfterDelay:1.0f];
            return;
        }
        [self.view endEditing:YES];
        NSString * urlString = self.interfaceManager.loginUrl;
        NSMutableDictionary * paramDic = [[NSMutableDictionary alloc] init];
        NSString *time = [HttpParamManager getTime];
        paramDic[@"phone"] = self.mobileTextF.text;
        paramDic[@"password"] = self.passwordTextF.text;
        paramDic[@"deviceInfo"] =[HttpParamManager getDeviceInfo];
        paramDic[@"pushID"] = [HttpParamManager getUUID];
        paramDic[@"loginChannel"] = @"2";
        paramDic[@"time"] = [HttpParamManager getTime];
        
        paramDic[@"sign"] = [HttpParamManager getSignWithIdentify:@"/user/login" time:time];

        
        [HJHttpManager PostRequestWithUrl:urlString param:paramDic finish:^(NSData *data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            HJLog(@">>>>%@",dict);
            NSInteger code = [dict[@"code"] integerValue];
            NSString * msgString = dict[@"msg"];
            if (code == 1) {
            
                NSDictionary * infoDic = [dict objectForKey:@"info"];
                NSString * uid = [infoDic objectForKey:@"uid"];
                NSString * token = [infoDic objectForKey:@"token"];
                [USER_DEFAULT setObject:uid forKey:@"uid"];
                [USER_DEFAULT setObject:token forKey:@"token"];
                [USER_DEFAULT setObject:self.mobileTextF.text forKey:@"mobile"];
                [USER_DEFAULT setObject:self.passwordTextF.text forKey:@"pwd"];
                [USER_DEFAULT setObject:@"1" forKey:@"isLogin"];
                [USER_DEFAULT synchronize];

                [self.hudManager dismissSVHud];
                //jpush监听
                [[JpushManager sharedJpushManager] startMonitor];
                //验证码登录成功
                AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [appD setTabBarRootViewController];
            }else {
                
                [self.hudManager showErrorSVHudWithTitle:msgString hideAfterDelay:1];
                
            }
            
            
            
        } failed:^(NSError *error) {
            
            [self.hudManager showErrorSVHudWithTitle:@"登录失败" hideAfterDelay:1];
            
            
        }];
        

    }
    
    
    
    
    
    
}
@end
