//
//  AccountSecuityController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "AccountSecuityController.h"
#import "PasswordCell.h"
#import "ComfirmBtnCell.h"
#import "MobileModifyCell.h"
#import "CLAlertView.h"
#import "ValidateHelper.h"

@interface AccountSecuityController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,PasswordCellDelegate>
{
    NSTimer *_timerOld;
    NSTimer *_timerNew;
}
@property(nonatomic,strong)UISegmentedControl * segmentControl;

@property(nonatomic,strong)UITableView * pwdTableView;

@property(nonatomic,strong)UITableView * mobileTableView;

@property(nonatomic,strong)UIScrollView * bgScrollView;

@property(nonatomic,strong)UIButton * OldSendBtn;

@property(nonatomic,strong)NSLayoutConstraint * OldSendBtnWidthConstraint;

@property(nonatomic,strong)NSLayoutConstraint * NewSendBtnWidthConstraint;

@property(nonatomic,strong)UIButton * NewSendBtn;


@property(nonatomic,strong)UITextField * pwdField1;

@property(nonatomic,strong)UITextField * pwdField2;

@property(nonatomic,strong)UITextField * pwdField3;

@property (nonatomic,strong) UITextField * mobileField1;     //原手机号

@property (nonatomic,strong) UITextField * confirmField1;    //第一个验证码

@property (nonatomic,strong) UITextField * mobileField2;     //新手机号码

@property (nonatomic,strong) UITextField * confirmField2;    //第二个验证码

@end

@implementation AccountSecuityController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_timerOld == nil) {//不在倒计时
        self.OldSendBtn.userInteractionEnabled = YES;
        self.NewSendBtn.userInteractionEnabled = YES;

    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_COLOR;
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:nil];
    [self createSegment];
    [self createUI];

}
- (void)createSegment
{
    NSArray * segmentArray = @[@"修改密码",@"修改手机"];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:segmentArray];
    _segmentControl.selectedSegmentIndex = 0;
    //设置segment的选中背景颜色
    _segmentControl.tintColor = [UIColor whiteColor];
    _segmentControl.frame = CGRectMake(100, 0, kScreenWidth -200, 30);
    [_segmentControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentControl;
}
- (void)createUI
{
    
    //创建scrollView作为两张表的载体
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight)];
    _bgScrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - kNavHeight-kTabBarHeight);
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.alwaysBounceVertical = NO;
    _bgScrollView.delegate = self;
    _bgScrollView.bounces = NO;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];
    
    //新消息
    _pwdTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    _pwdTableView.delegate = self;
    _pwdTableView.dataSource = self;
    _pwdTableView.backgroundColor = [UIColor clearColor];
    [_pwdTableView setExtraCellLineHidden];
    [_pwdTableView setCellLineFullInScreen];
    _pwdTableView.separatorColor = [UIColor colorWithHexString:@"ececec"];
    [_bgScrollView addSubview:_pwdTableView];
    [_pwdTableView registerNib:[UINib nibWithNibName:@"PasswordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PasswordCell"];
    [_pwdTableView registerNib:[UINib nibWithNibName:@"ComfirmBtnCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ComfirmBtnCell"];
    
    //已发布
    _mobileTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    _mobileTableView.delegate = self;
    _mobileTableView.dataSource = self;
    [_mobileTableView setExtraCellLineHidden];
    _mobileTableView.separatorColor = [UIColor colorWithHexString:@"f0f0f0"];
    [_mobileTableView setCellLineFullInScreen];
    _mobileTableView.backgroundColor = [UIColor clearColor];
    [_bgScrollView addSubview:_mobileTableView];
    [_mobileTableView registerNib:[UINib nibWithNibName:@"ComfirmBtnCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ComfirmBtnCell"];

    
}

- (void)clickPasswordCellValueChange:(PasswordCell *)cell
{
    if ([cell.pwdSwitch isOn]) {
        cell.textField.secureTextEntry = YES;
    }else{
        cell.textField.secureTextEntry = NO;
    }
    
}

#pragma mark -- tableView的代理和数据源
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _pwdTableView) {
        return 10;
    }else
    {
        return 10;
    }

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _pwdTableView) {
        return 2;
    }else
    {
        return 2;
    }


}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _pwdTableView)
    {
        if (section == 0) {
            return 3;
        }else
        {
            return 1;
        }
    }
    else
    {
        if (section == 0) {
            return 4;
        }else
        {
            return 1;
        }
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _pwdTableView) {
        if (indexPath.section == 0) {
            return 50;
        }else
        {
            return 65;
        }
        
    }else {
        
        if (indexPath.section == 0) {
            return 50;
        }else
        {
            return 65;
        }
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _pwdTableView) {
        if (indexPath.section == 0) {
            static NSString * identifer = @"PasswordCell";
            PasswordCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
            if (indexPath.row == 0) {
                cell.textField.placeholder = @"旧密码输入";
                _pwdField1 = cell.textField;
            }
            if (indexPath.row == 1) {
                cell.textField.placeholder = @"新密码";
                _pwdField2 = cell.textField;
            }
            if (indexPath.row == 2) {
                cell.textField.placeholder = @"请再次输入新密码";
                _pwdField3 = cell.textField;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
        else
        {
            static NSString * identifer = @"ComfirmBtnCell";
            ComfirmBtnCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
            [cell.comfirmBtn removeAllTargets];
            [cell.comfirmBtn addTarget:self action:@selector(modifyPwdBtnClick) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        
    }
    else
    {
        if (indexPath.section == 0) {
            NSString * identify = @"MobileModifyCell";
            MobileModifyCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MobileModifyCell" owner:nil options:nil]lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                cell.textField.placeholder = @"输入原绑定手机号码";
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                _mobileField1 = cell.textField;
                cell.sendBtn.hidden = YES;

            }
            if (indexPath.row == 1) {
                self.OldSendBtnWidthConstraint = cell.sendBtnWidthConstraint;
                self.OldSendBtn = cell.sendBtn;
                [cell.sendBtn removeAllTargets];
                [cell.sendBtn addTarget:self action:@selector(oldSendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.textField.placeholder = @"验证码";
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                _confirmField1 = cell.textField;
                cell.sendBtn.hidden = NO;
            }
            if (indexPath.row == 2) {
                cell.textField.placeholder = @"输入新绑定手机号码";
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                _mobileField2 = cell.textField;
                cell.sendBtn.hidden = YES;

            }
            if (indexPath.row == 3) {
                self.NewSendBtnWidthConstraint = cell.sendBtnWidthConstraint;
                self.NewSendBtn = cell.sendBtn;
                [cell.sendBtn removeAllTargets];
                [cell.sendBtn addTarget:self action:@selector(newSendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.textField.placeholder = @"验证码";
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                _confirmField2 = cell.textField;
                cell.sendBtn.hidden = NO;

            }
            return cell;
        }
        else
        {
            static NSString * identifer = @"ComfirmBtnCell";
            ComfirmBtnCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
            [cell.comfirmBtn removeAllTargets];
            [cell.comfirmBtn addTarget:self action:@selector(modifyMobileBtnClick) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        
    }
    
    
}
/**
 *  退出登录条件配置
 */
-(void)loginOffConfig
{
    NSDictionary *defaultsDictionary = [USER_DEFAULT dictionaryRepresentation];
    for (NSString *key in [defaultsDictionary allKeys])
    {
        if ([key isEqualToString:@"isLogin"]) {
            [USER_DEFAULT removeObjectForKey:key];
        }
        if ([key isEqualToString:@"uid"]) {
            [USER_DEFAULT removeObjectForKey:key];
        }
        if ([key isEqualToString:@"token"]) {
            [USER_DEFAULT removeObjectForKey:key];
        }
        if ([key isEqualToString:@"mobile"]) {
            [USER_DEFAULT removeObjectForKey:key];
        }
        if ([key isEqualToString:@"pwd"]) {
            [USER_DEFAULT removeObjectForKey:key];
        }
    }
    [USER_DEFAULT synchronize];
    
}
#pragma mark --   修改密码 确认修改按钮点击
-(void)modifyPwdBtnClick
{
    [_pwdField1 resignFirstResponder];
    [_pwdField2 resignFirstResponder];
    [_pwdField3 resignFirstResponder];
    
    if (![_pwdField2.text isEqualToString:_pwdField3.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"两次输入的密码不一致" hideAfterDelay:1.0f];
        return;
    }
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
    NSString *url = self.interfaceManager.getEditPassword;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/editPassword" time:time addExtraStr:_pwdField1.text];
    param[@"oPwd"] = _pwdField1.text;
    param[@"nPwd"] = _pwdField2.text;
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        
        [self.hudManager dismissSVHud];

        if (code == 1)
        {
            [self.hudManager showSuccessSVHudWithTitle:@"密码修改成功,请重新登录" hideAfterDelay:1.0f animaton:YES];
            
            [self loginOffConfig];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                LoginGuideController * vc = [[LoginGuideController alloc]init];
                JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
                nav.fullScreenPopGestureEnabled = YES;
                [self presentViewController:nav animated:YES completion:nil];
            });
            
        }
        else
        {
            CLAlertView * alertView = [[CLAlertView alloc] initWithAlertViewWithTitle:@"密码错误" text:@"对不起您输入的密码有误，请确认后重新尝试" DefauleBtn:nil cancelBtn:@"朕知道了" defaultBtnBlock:^(UIButton *defaultBtn) {
                
            } cancelBtnBlock:nil];
            
            [alertView show];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
    }];
    

}

#pragma mark --   手机修改 确认修改按钮点击
-(void)modifyMobileBtnClick
{
    if (![ValidateHelper validateMobile:_mobileField1.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"手机号不正确" hideAfterDelay:1.0f];
        return;
    }
    
    if (![ValidateHelper validateMobile:_mobileField2.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"手机号不正确" hideAfterDelay:1.0f];
        return;
    }
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
    NSString *url = self.interfaceManager.getEditPhone;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/editPhone" time:time];
    param[@"oPhone"] = _mobileField1.text;
    param[@"nPhone"] = _mobileField2.text;
    param[@"oCode"] = _confirmField1.text;
    param[@"nCode"] =  _confirmField2.text;
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1) {
            [self.hudManager showSuccessSVHudWithTitle:@"手机号码修改成功" hideAfterDelay:1.0f animaton:YES];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
    }];
}

//点击了第一个发送按钮
-(void)oldSendBtnClick:(UIButton *)btn
{
    
    if (![ValidateHelper validateMobile:_mobileField1.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"手机号不正确" hideAfterDelay:1.0f];
        return;
    }
    
    NSString *url = self.interfaceManager.getSendCode;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"phone"] = _mobileField1.text;
    param[@"time"] = [HttpParamManager getTime];
    param[@"flag"] = @"changemobile";
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {

            //请求成功，取消按钮的点击
            self.OldSendBtn.userInteractionEnabled = NO;
            //设置验证码的button的title
            [self.OldSendBtn setTitle:@"60s后重新发送" forState:UIControlStateNormal];
            self.OldSendBtnWidthConstraint.constant = 100;
            self.OldSendBtn.backgroundColor = [UIColor colorWithHexString:@"d5d5d2"];
            
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
-(void)timeChange
{
    NSString *time = [self.OldSendBtn.titleLabel.text substringWithRange:NSMakeRange(0, 2)];
    if ([time integerValue] == 0) {
        //倒计时结束，开启用户交互
        self.OldSendBtn.userInteractionEnabled = YES;
        self.OldSendBtnWidthConstraint.constant = 70;
        self.OldSendBtn.backgroundColor = [UIColor colorWithHexString:@"5cb6ff"];
        [self.OldSendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_timerOld invalidate];
        _timerOld = nil;
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%ds后重新发送",[time intValue]-1];
    [self.OldSendBtn setTitle:str forState:UIControlStateNormal];
    
    
}
-(void)timeChange2
{
    NSString *time = [self.NewSendBtn.titleLabel.text substringWithRange:NSMakeRange(0, 2)];
    if ([time integerValue] == 0) {
        //倒计时结束，开启用户交互
        self.NewSendBtn.userInteractionEnabled = YES;
        self.NewSendBtnWidthConstraint.constant = 70;
        self.NewSendBtn.backgroundColor = [UIColor colorWithHexString:@"5cb6ff"];
        [self.NewSendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_timerNew invalidate];
        _timerNew = nil;
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%ds后重新发送",[time intValue]-1];
    [self.NewSendBtn setTitle:str forState:UIControlStateNormal];
    
    
}
-(void)newSendBtnClick:(UIButton *)btn
{
    if (![ValidateHelper validateMobile:_mobileField2.text]) {
        [self.hudManager showErrorSVHudWithTitle:@"手机号不正确" hideAfterDelay:1.0f];
        return;
    }
    
    NSString *url = self.interfaceManager.getSendCode;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    param[@"phone"] = _mobileField2.text;
    param[@"time"] = [HttpParamManager getTime];
    param[@"flag"] = @"changemobile";
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {
            
            //请求成功，取消按钮的点击
            self.NewSendBtn.userInteractionEnabled = NO;
            //设置验证码的button的title
            [self.NewSendBtn setTitle:@"60s后重新发送" forState:UIControlStateNormal];
            self.NewSendBtnWidthConstraint.constant = 100;
            self.NewSendBtn.backgroundColor = [UIColor colorWithHexString:@"d5d5d2"];
            
            //倒计时
            _timerNew =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeChange2) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:_timerNew forMode:NSRunLoopCommonModes];

        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
        
        
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"获取验证码失败" hideAfterDelay:1.0];
    }];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _bgScrollView) {
        
        int page = scrollView.contentOffset.x/kScreenWidth+0.5;
        
        if (page == 0) {
            if (self.segmentControl.selectedSegmentIndex != 0) {
                self.segmentControl.selectedSegmentIndex = 0;
            }
        }
        if (page == 1) {
            if (self.segmentControl.selectedSegmentIndex != 1) {
                self.segmentControl.selectedSegmentIndex = 1;
            }
        }
        
    }
    
}

-(void)segmentValueChanged:(UISegmentedControl *)segmentControl
{
    if (segmentControl.selectedSegmentIndex == 0) {
        [self.bgScrollView setContentOffset:CGPointZero animated:YES];
    }else
    {
        [self.bgScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
