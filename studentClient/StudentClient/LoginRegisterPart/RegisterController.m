//
//  RegisterController.m
//  KZXC_Headmaster
//
//  Created by 翁昌青 on 16/7/26.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "RegisterController.h"
#import "LoginViewController.h"
#import "ValidateHelper/ValidateHelper.h"
#import "BaseWebController.h"
@interface RegisterController ()<UITextFieldDelegate>
{
    NSTimer *_timerOld;
}
@property (weak, nonatomic) IBOutlet UITextField *mobileTextF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeBtnWidthConstraint;

@property (weak, nonatomic) IBOutlet UITextField *codeTextF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

- (IBAction)getCodeBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextF;

@property (weak, nonatomic) IBOutlet UITextField *pwdConfirmTextF;

- (IBAction)xieyiBtnClick:(id)sender;



@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"5cb6ff"];
    
    [self setupNav];
    
    [self configUI];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_timerOld == nil) {//不在倒计时
        self.getCodeBtn.userInteractionEnabled = YES;
        
    }
}
-(void)configUI
{
    self.mobileTextF.textColor = [UIColor whiteColor];
    self.codeTextF.textColor = [UIColor whiteColor];
    self.pwdTextF.textColor = [UIColor whiteColor];
    self.pwdConfirmTextF.textColor = [UIColor whiteColor];
    
    self.mobileTextF.font = [UIFont systemFontOfSize:14];
    self.codeTextF.font = [UIFont systemFontOfSize:14];
    self.pwdTextF.font = [UIFont systemFontOfSize:14];
    self.pwdConfirmTextF.font = [UIFont systemFontOfSize:14];
    
    
    [self.mobileTextF setValue:[UIColor colorWithHexString:@"bde2ff"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.codeTextF setValue:[UIColor colorWithHexString:@"bde2ff"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.pwdTextF setValue:[UIColor colorWithHexString:@"bde2ff"] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.pwdConfirmTextF setValue:[UIColor colorWithHexString:@"bde2ff"] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.loginBtn.clipsToBounds = YES;
    self.loginBtn.layer.cornerRadius = 20.0f;
    
    self.getCodeBtn.clipsToBounds = YES;
    [self.getCodeBtn setborderWidth:LINE_HEIGHT borderColor:[UIColor colorWithHexString:@"bde2ff"]];
    self.getCodeBtn.layer.cornerRadius = 3.0f;
    
    self.codeTextF.secureTextEntry = NO;

    self.pwdTextF.secureTextEntry = YES;
    
    self.pwdConfirmTextF.secureTextEntry = YES;

}

-(void)timeChange
{
    NSString *time = [self.getCodeBtn.titleLabel.text substringWithRange:NSMakeRange(0, 2)];
    if ([time integerValue] == 0) {
        //倒计时结束，开启用户交互
        self.getCodeBtn.userInteractionEnabled = YES;
        [self.getCodeBtn setborderWidth:LINE_HEIGHT borderColor:[UIColor colorWithHexString:@"bde2ff"]];
        self.codeBtnWidthConstraint.constant = 70;
        [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timerOld invalidate];
        _timerOld = nil;
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%ds后重新发送",[time intValue]-1];
    [self.getCodeBtn setTitle:str forState:UIControlStateNormal];
    
    
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
    
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"注册"];
    
    
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
    
    if (![ValidateHelper validateMobile:self.mobileTextF.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"手机号不正确" hideAfterDelay:1.0f];
        return;
    }

    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    
    NSString *url = self.interfaceManager.getRegisterCode;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"phone"] = self.mobileTextF.text;
    param[@"time"] = [HttpParamManager getTime];

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
            self.codeBtnWidthConstraint.constant = 100;
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
- (IBAction)loginBtnClick:(id)sender {
    
    if (![ValidateHelper validateMobile:self.mobileTextF.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"手机号不正确" hideAfterDelay:1.0f];
        return;
    }
    
    if (![self.pwdTextF.text isEqualToString:self.pwdConfirmTextF.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"两次输入的密码不一致" hideAfterDelay:1.0f];
        return;
    }
    
    if (![ValidateHelper validatePassword:self.pwdTextF.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"密码必须在6-20位之间" hideAfterDelay:1.0f];
        return;
    }
    
    NSString *url = self.interfaceManager.registerUrl;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"phone"] = self.mobileTextF.text;
    param[@"time"] = [HttpParamManager getTime];
    param[@"code"] = self.codeTextF.text;
    param[@"pwd"] = self.pwdTextF.text;
    param[@"confirmPwd"] = self.pwdConfirmTextF.text;
    param[@"pushID"] =[HttpParamManager getUUID];
    param[@"deviceInfo"] = [NSString stringWithFormat:@"%@,%@",[UIDevice currentDevice].model,[[UIDevice currentDevice] systemVersion]];
    
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {
            [self.hudManager showSuccessSVHudWithTitle:msg hideAfterDelay:1.0 animaton:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LoginViewController *login = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:login animated:YES];

            });
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];

        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"注册失败" hideAfterDelay:1.0];
    }];

}

- (IBAction)xieyiBtnClick:(id)sender {
    
    BaseWebController *baseVC = [[BaseWebController alloc]init];
    NSString *urlStr =self.interfaceManager.agreementUrl;
    baseVC.urlString = urlStr;
    baseVC.titleString = @"注册协议";
    [self.navigationController pushViewController:baseVC animated:YES];
}
@end
