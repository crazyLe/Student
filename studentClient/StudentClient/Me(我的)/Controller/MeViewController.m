//
//  MeViewController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//


#import "PersonalSettingVC.h"
#import "MyOrderVC.h"
#import "WithdrawViewController.h"
#import "LLRightAccessoryCell.h"
#import "LLEarnBeanInfoCell.h"
#import "LLBaseInfoView.h"
#import "NSMutableAttributedString+LLExtension.h"
#import "UIViewController+NavigationController.h"
#import "RechargeController.h"
#import "MeViewController.h"
#import "MyCircleViewController.h"
#import "RealNameAuthenticationVC.h"
#import "AlreadyRealNameVC.h"
#import "AccountSecuityController.h"
#import "SafeRightsController.h"
#import "UnBindCoachController.h"
#import "LoginGuideController.h"
#import "RealNameModel.h"
#import "PersonalInfoModel.h"
#import "MyOderExtraVC.h"
#import "MyCoachViewController.h"
#import "CoachModel.h"
#import "XueshiModel.h"
#import "AboutKZController.h"
#import "PPDLoanSdk.h"

#define kHeadImageHeight 226*kHeightScale
@interface MeViewController () <UITableViewDelegate,UITableViewDataSource,LLEarnBeanInfoCellDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)RealNameModel *realName;

@property(nonatomic,strong)PersonalInfoModel *personalInfo;
//科目二教练
@property(strong,nonatomic)CoachModel *secModel;
//科目三教练
@property(strong,nonatomic)CoachModel *thiModel;
//学时
@property(strong,nonatomic)NSArray *xueshiArr;

@property(nonatomic,strong)LLBaseInfoView *baseInfoView;

@property(nonatomic,strong)NSMutableString *coachName;


@end

@implementation MeViewController
{
    NSArray *registerCellArr;
}

- (NSArray *)xueshiArr
{
    if (!_xueshiArr) {
        _xueshiArr = [NSArray array];
    }
    return _xueshiArr;
}

- (id)init
{
    if (self = [super init]) {
        registerCellArr = @[@"LLEarnBeanInfoCell",@"LLRightAccessoryCell"];
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.coachName = [[NSMutableString alloc]init];
    
    self.view.backgroundColor = BG_COLOR;
    
    [self setNavigation];
    
    [self setUI];
    if (![kUid isEqualToString:@"0"]) {
        //判断该用户的认证状态的请求
        [self requestAuthenticationStateData];
        //获取我的教接口
        [self loadCoachData];
        
        [self.hudManager showNormalStateSVHUDWithTitle:nil];
        //请求个人信息
        [self requestData];
    }
   
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(refreshPersonInfo) name:kRefreshPersonInfoNotification object:nil];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(refreshAuthenticationState) name:kAuthenticationStateNotification object:nil];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(refreshCoachState) name:kRefreshMyCoachStateNotification object:nil];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(tableReresh) name:kRefreshBeansShowNotification object:nil];
}

-(void)tableReresh {
    [self.tableView reloadData];
}

-(void)refreshCoachState {
    //获取我的教接口
    [self loadCoachData];
}

-(void)refreshAuthenticationState {
    //判断该用户的认证状态的请求
    [self requestAuthenticationStateData];
}

-(void)refreshPersonInfo {
    if (kLoginStatus) {
        [self requestData];
    }
}

#pragma mark - 使得导航栏透明
- (void)setNavigation {
    [self createNavWithLeftBtnImageName:nil leftHighlightImageName:nil leftBtnSelector:nil andCenterTitle:@"个人中心"];
    
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
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void)setUI {
    [self setBg_TableView];
    
    [self addTableHeadView];
    
    [self.tableView addSubview:self.baseInfoView];
}

- (void)setBg_TableView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabBarHeight) style:UITableViewStylePlain];
    
    self.tableView = tableView;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.tableView setCellLineFullInScreen];
    
    tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:246/255.0 blue:245/255.0 alpha:1];
    
    tableView.separatorColor = [UIColor colorWithHexString:@"ececec"];
    
    tableView.sectionHeaderHeight = 9*kHeightScale;
    
    [self.view addSubview:tableView];
    
    for (NSString *className in registerCellArr) {
        [_tableView registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
    }
}

-(void)addTableHeadView {
    
    self.imageView = [[UIImageView alloc]init];
    
    self.imageView.frame = CGRectMake(0, -kHeadImageHeight, kScreenWidth, kHeadImageHeight);
    
    self.imageView.image = [UIImage imageNamed:@"个人中心头部"];
    
    [self.tableView addSubview:self.imageView];
    
    //设置图片的模式
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    //解决设置UIViewContentModeScaleAspectFill图片超出边框的问题
    self.imageView.clipsToBounds = YES;
    
    self.tableView.contentInset = UIEdgeInsetsMake(kHeadImageHeight, 0, 0, 0);
    [self.tableView setContentOffset:CGPointMake(0, -kHeadImageHeight)];
}
//设置懒加载,防止标签值叠加
- (LLBaseInfoView *)baseInfoView {
    if (!_baseInfoView) {
        
        _baseInfoView = [[LLBaseInfoView alloc] initWithFrame:CGRectMake(0, -kHeadImageHeight, kScreenWidth, kHeadImageHeight)];
    }
    
    return _baseInfoView;
}

- (void)setBaseInfoView {

    [_baseInfoView.headBtn sd_setImageWithURL:[NSURL URLWithString:_personalInfo.face] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像"]];
    
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]init];
    [attStr appendText:_personalInfo.nickName withAttributesArr:@[[UIColor whiteColor],kFont14]];

    if ([_realName.state isEqualToString:@"1"]) {
        //已通过认证
        [attStr appendImg:[UIImage imageNamed:@"iconfont-circle-renzheng-1"] bounds:CGRectMake(5, 0, 13*kWidthScale, 13*kWidthScale)];
    }

    [_baseInfoView.nameLbl setAttributedText:attStr];
    if (!kLoginStatus) {
        _baseInfoView.nameLbl .text = @"请先登录";
    }
    NSArray * provinceArr = kProvinceDict;
    NSString * provinceStr = @"";
    for (NSDictionary * dic in provinceArr) {
        if ([dic[@"id"] isEqualToString:_personalInfo.provinceId]) {
            provinceStr = dic[@"title"];
        }
    }
    NSArray *cityDicArr = kCityDict;
    NSString * cityStr = @"";
    for (NSDictionary *dic in cityDicArr) {
        if ([dic[@"id"] isEqualToString:_personalInfo.cityId]) {
            cityStr = dic[@"title"];
        }
    }
    if (kLoginStatus) {
        _baseInfoView.infoLbl.text = [NSString stringWithFormat:@"%@岁 %@ %@",_personalInfo.age,provinceStr,cityStr];
        
    }
    else
    {
        _baseInfoView.infoLbl.text = nil;
    }
    NSMutableAttributedString *idAttStr = [NSMutableAttributedString attributeStringWithImg:[UIImage imageNamed:@"iconfont-center-about"] bounds:CGRectMake(5, -2, 13*kWidthScale, 13*kWidthScale)];
    NSString * IDString = [NSString stringWithFormat:@"   康庄学员ID: %@",kUid];
    [idAttStr appendText:IDString withAttributesArr:@[[UIColor colorWithHexString:@"ffffff" alpha:1.0f],kFont11]];
    [_baseInfoView.studentIdLbl setAttributedText:idAttStr];
}


/**
 *  核心代码
 *
 *  @param scrollView scrollView
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"%f",self.tableView.contentOffset.y);
    
    CGFloat offSet_Y = self.tableView.contentOffset.y;
    
    if (offSet_Y<-kHeadImageHeight) {
        //获取imageView的原始frame
        CGRect frame = self.imageView.frame;
        //修改y
        frame.origin.y = offSet_Y;
        //修改height
        frame.size.height = -offSet_Y;
        //重新赋值
        self.imageView.frame = frame;
        
    }
    //tableView相对于图片的偏移量
    CGFloat reoffSet = offSet_Y + kHeadImageHeight;
    
    NSLog(@"%f",reoffSet);
    //kHeadImageHeight-64是为了向上拉倒导航栏底部时alpha = 1
    CGFloat alpha = reoffSet/(kHeadImageHeight-64);
    
    NSLog(@"%f",alpha);
    
    if (alpha>=1) {
        alpha = 0.99;
    }
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithHexString:@"353c3f" alpha:alpha]];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - UITableViewDelegate && UITableViewDateSource

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [@[@(1),@(6),@(2),@(1)][section] longValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < 3) {
        if (indexPath.section == 0) {
            if (kBeansShow) {
                return 46*kHeightScale;
            }
            else
            {
                return CGFLOAT_MIN;
            }
        }
        return 46*kHeightScale;
    }
    else
    {
        return 61*kHeightScale;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            LLEarnBeanInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLEarnBeanInfoCell"];
            cell.delegate = self;
            cell.leftImgView.image = [UIImage imageNamed:@"iconfont-center-dou"];
            cell.leftLbl.text = [NSString stringWithFormat:@"赚豆：%@",_personalInfo.beans==nil?@"0":_personalInfo.beans];
            [cell.rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];

            [cell.withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
            if (!kBeansShow) {
                cell.withdrawBtn.hidden = YES;
                cell.leftLbl.hidden = YES;
                cell.leftImgView.hidden = YES;
                cell.rechargeBtn.hidden = YES;
            }
            else
            {
                cell.withdrawBtn.hidden = NO;
                cell.leftLbl.hidden = NO;
                cell.leftImgView.hidden = NO;
                cell.rechargeBtn.hidden = YES;
            }
            return cell;
        }
            break;
        case 1: case 2:
        {
            LLRightAccessoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLRightAccessoryCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            NSArray *leftImgNameArr = @[@[@"iconfont-center-shezhi",@"iconfont-center-tip",@"iconfont-center-jiaoshi",@"iconfont-center-nvshen01",@"iconfont-center-emizhifeiji",@"iconfont-circle-renzheng-1",@"iconfont-center-quan"],@[@"iconfont-center-anquan",@"iconfont-center-about"]];
            NSArray *leftLblTextArr = @[@[@"个人设置",@"我的订单",@"我的教练",@"我的圈子",@"实名认证",@"驾考维权"],@[@"账号安全",@"关于"]];
            cell.leftImgView.image = [UIImage imageNamed:leftImgNameArr[indexPath.section-1][indexPath.row]];
            cell.leftLbl.text = leftLblTextArr[indexPath.section-1][indexPath.row];
            cell.accessoryImgView.image = [UIImage imageNamed:@"iconfont-dingzhi-jiantou-拷贝-2"];
            if ((indexPath.section==1)&&(indexPath.row==3)) {
                
                if ([_personalInfo.mymessage isEqualToString:@"0"]) {
                    cell.accessoryLbl.hidden = YES;
                }
                else
                {
                    cell.accessoryLbl.hidden = NO;
                    [cell setMessageNum:_personalInfo.mymessage];
                }
                
            }
            else
            {
                NSString *status = nil;
                if([_realName.state isEqualToString:@"1"])//已认证
                {
                    status = @"已认证";
                }
                else if([_realName.state isEqualToString:@"0"])//正在认证
                {
                    status = @"正在审核";
                }
                else if([_realName.state isEqualToString:@"2"])//重新认证
                {
                    status = @"重新认证";
                }
                else if([_realName.state isEqualToString:@"-1"])//未认证
                {
                    status = @"未认证";
                }
                [cell setAccessoryLblText:indexPath.row==2?self.coachName:indexPath.row==4?status:@""];
            }
            return cell;
        }
            break;
        case 3:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.backgroundColor = [UIColor clearColor];
            UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cell.contentView addSubview:exitBtn];
            [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(10*kHeightScale, 10*kHeightScale, 10*kHeightScale, 10*kHeightScale));
            }];
            exitBtn.backgroundColor = [UIColor colorWithHexString:@"ff5d5d"];
            exitBtn.layer.masksToBounds = YES;
            exitBtn.layer.cornerRadius = 20.0f*kHeightScale;
            [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if (kLoginStatus) {
                [exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
            }
            else
            {
                [exitBtn setTitle:@"登录" forState:UIControlStateNormal];
            }
            exitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [exitBtn addTarget:self action:@selector(loginoffBtnClick) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
            break;
            
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}
-(void)loginoffBtnClick
{
    if (kLoginStatus) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定退出?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1000;
        [alertView show];
    }
    else
    {
        LoginGuideController *loginVC = [[LoginGuideController alloc]init];
        JTNavigationController *loginnavC = [[JTNavigationController alloc] initWithRootViewController:loginVC];
        loginnavC.fullScreenPopGestureEnabled = YES;
        [self presentViewController:loginnavC animated:YES completion:nil];

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
#pragma mark -- alertView的代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            
            [self loginOffConfig];
            
            _personalInfo = nil;
            
            [self setBaseInfoView];
            
            [self.tableView reloadData];
            
            [LoansSDK logoutAndCleanLoanSDK];
            //刷新钱袋主页
            [NOTIFICATION_CENTER postNotificationName:kRefreshWalletDataNotification object:nil];
        }
        
    }
    if (alertView.tag == 2000) {
        
        if (buttonIndex == 1) {
            
            //审核失败,重新进去认证界面
            RealNameAuthenticationVC * vc = [[RealNameAuthenticationVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
    }
 

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                if (kLoginStatus) {
                    //个人设置
                    PersonalSettingVC * vc = [[PersonalSettingVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.personalInfo = _personalInfo;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    LoginGuideController * vc = [[LoginGuideController alloc]init];
                    JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
                    [self presentViewController:nav animated:YES completion:nil];
                }
                
                
            }
                break;
            case 1:
            {
                if (kLoginStatus) {
                    //我的订单
                    MyOrderVC * vc = [[MyOrderVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    LoginGuideController * vc = [[LoginGuideController alloc]init];
                    JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
                    [self presentViewController:nav animated:YES completion:nil];
                }
                
                
            }
                break;
            case 2:
            {
                if (kLoginStatus) {
                    //我的教练
                    if (self.secModel.idNum == nil && self.thiModel.idNum == nil)
                    {
                        UnBindCoachController *unBindVC =[[UnBindCoachController alloc]init];
                        unBindVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:unBindVC animated:YES];
                    }
                    else
                    {
                        MyCoachViewController *mycoachVC = [[MyCoachViewController alloc]init];
                        mycoachVC.hidesBottomBarWhenPushed = YES;
                        mycoachVC.secondCoach = self.secModel;
                        mycoachVC.thredCoach = self.thiModel;
                        mycoachVC.xueshiArr = self.xueshiArr;
                        [self.navigationController pushViewController:mycoachVC animated:YES];
                    }

                }
                else
                {
                    LoginGuideController * vc = [[LoginGuideController alloc]init];
                    JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
                    [self presentViewController:nav animated:YES completion:nil];
                }
               
            }
                break;
            case 3:
            {
                if (kLoginStatus) {
                    //我的圈子
                    MyCircleViewController *vc = [[MyCircleViewController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else
                {
                    LoginGuideController * vc = [[LoginGuideController alloc]init];
                    JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
                    [self presentViewController:nav animated:YES completion:nil];
                }
                
                
            }
                break;
            case 4:
            {
                if (kLoginStatus) {
                    //根据返回数据判断是否已经实名认证过,根据状态进入对应的界面
                    if ([_realName.state isEqualToString:@"-1"]) {
                        //尚未提交审核,去认证界面
                        RealNameAuthenticationVC * vc = [[RealNameAuthenticationVC alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }if ([_realName.state isEqualToString:@"1"]) {
                        //审核通过,进去已认证界面
                        AlreadyRealNameVC * vc = [[AlreadyRealNameVC alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        vc.realName = _realName;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }if ([_realName.state isEqualToString:@"0"]) {
                        //正在审核中
                        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的实名认证正在审核中..." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        [alertView show];
                        
                    }if ([_realName.state isEqualToString:@"2"]) {
                        //审核失败
                        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的实名认证审核失败,请重新认证" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新认证", nil];
                        alertView.tag = 2000;
                        [alertView show];
                    }

                }
                else
                {
                    LoginGuideController * vc = [[LoginGuideController alloc]init];
                    JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
                    [self presentViewController:nav animated:YES completion:nil];
                
                }

                
            }
                break;
            case 5:
            {
                if (kLoginStatus) {
                    //驾考维权
                    SafeRightsController *safeVC = [[SafeRightsController alloc]init];
                    safeVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:safeVC animated:YES];
                }
                else
                {
                    LoginGuideController * vc = [[LoginGuideController alloc]init];
                    JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
                    [self presentViewController:nav animated:YES completion:nil];
                }
                
            }
                break;
                
            default:
                break;
        }
    }
    else if(indexPath.section == 2)
    {
        if (indexPath.row==0) {
            
            if (kLoginStatus) {
                //账号安全
                AccountSecuityController *accountVC = [[AccountSecuityController alloc]init];
                accountVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:accountVC animated:YES];
            }
            else
            {
                LoginGuideController * vc = [[LoginGuideController alloc]init];
                JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }
            
            
        }
        else
        {
            //关于
            AboutKZController *vc = [[AboutKZController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
    }
}
#pragma mark - 获取个人信息接口
- (void)requestData {

    NSString * url = self.interfaceManager.memberInfo;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * timeString = [HttpParamManager getTime];
    paramDict[@"time"] = timeString;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/member/info" time:timeString];
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"+++%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            
            NSDictionary *infoDict = dict[@"info"];
            
            [[PersonalInfoModel sharedPersonalInfoModel] configDict:infoDict];
            
            _personalInfo = [PersonalInfoModel sharedPersonalInfoModel];
            
            [self setBaseInfoView];
            
            [_tableView reloadData];
            
            [self.hudManager dismissSVHud];
            
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
        }
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
    }];
    
    
}

#pragma mark - 判断认证状态的请求
- (void)requestAuthenticationStateData {
    NSString * url = self.interfaceManager.realNameState;
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * timeString = [HttpParamManager getTime];
    paramDict[@"time"] = timeString;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/userAuth" time:timeString];
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"+++%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            
            NSDictionary * infoDict = dict[@"info"];
            _realName = [RealNameModel mj_objectWithKeyValues:infoDict];
            [self.tableView reloadData];
            
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
        }
        
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        
    }];
}
#pragma mark - 请求我的教练接口，为空值表示为绑定
- (void)loadCoachData {
    NSString *postUrl =  self.interfaceManager.myCoach;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/myCoach" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    [HJHttpManager PostRequestWithUrl:postUrl param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1) {
            
            [self.hudManager dismissSVHud];
            
            NSDictionary *infoDict = dict[@"info"];
            
            NSDictionary *secondDict = infoDict[@"second"];
            
            NSDictionary *thirdDict = infoDict[@"thred"];
            
            self.secModel = [CoachModel mj_objectWithKeyValues:secondDict];
            
            self.thiModel = [CoachModel mj_objectWithKeyValues:thirdDict];
            self.xueshiArr = [XueshiModel mj_objectArrayWithKeyValuesArray:infoDict[@"teachingTimes"]];
            
            self.coachName = [[NSMutableString alloc]init];

            if (self.secModel.name != nil && ![self.secModel.name isEqualToString:@""]) {
                [self.coachName appendString:self.secModel.name];
            }
            
            if (self.thiModel.name != nil && ![self.thiModel.name isEqualToString:@""]) {
                if (self.coachName.length == 0) {
                    [self.coachName appendString:[NSString stringWithFormat:@"%@",self.thiModel.name]];
                }
                else
                {
                    [self.coachName appendString:[NSString stringWithFormat:@",%@",self.thiModel.name]];
                }
            }
            
            [self.tableView reloadData];

        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];
    
}


#pragma  mark -LLEarnBeanInfoCellDelegate

- (void)LLEarnBeanInfoCell:(LLEarnBeanInfoCell *)cell clickRechargeBtn:(UIButton *)rechargeBtn;
{
    if (kLoginStatus) {
        RechargeController *rechargeVC = [[RechargeController alloc]init];
        rechargeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:rechargeVC animated:YES];
    }else
    {
        LoginGuideController * vc = [[LoginGuideController alloc]init];
        JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)LLEarnBeanInfoCell:(LLEarnBeanInfoCell *)cell clickWithdrawBtn:(UIButton *)withdrawBtn;
{
    if (kLoginStatus) {
        
        WithdrawViewController *withdrawVC = [[WithdrawViewController alloc] init];
        withdrawVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:withdrawVC animated:YES];
    }
    else
    {
        LoginGuideController * vc = [[LoginGuideController alloc]init];
        JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    
    }
    
    
}




@end
