//
//  WalletViewController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "NSMutableAttributedString+LLExtension.h"
#import "LLMyCouponCell.h"
#import "LLStageBillCell.h"
#import "LLStudentTaskCell.h"
#import "LLEarnBeansCell.h"
#import "WalletViewController.h"
#import "UIViewController+NavigationController.h"
#import "MyVoucherVC.h"
#import "StagingBillVC.h"
#import <JSBadgeView.h>
#import "WithdrawViewController.h"
#import "RechargeController.h"
#import "ExtraMoneyVC.h"
#import "BaseWebController.h"
#import "ZhuanXueFeiController.h"
#import "SystemMsgController.h"
#import "MessageDataBase.h"
#import "WebHtmlController.h"
@interface WalletViewController () <UITableViewDelegate,UITableViewDataSource,LLEarnBeansCellDelegate,LLWalletSuperCellDelegate>
@property(nonatomic,strong)UIButton * rightBtn;
@property(nonatomic,strong)JSBadgeView * badgeView;
@property(nonatomic,strong)UITableView * tableView;
/**
 *  数据源
 */
@property (nonatomic,strong)NSMutableDictionary * couponDict;
@property (nonatomic,strong)NSMutableDictionary * reimbursementDict;
@property (nonatomic,strong)NSMutableDictionary * taskDict;//任务
@property (nonatomic,strong)NSMutableDictionary * userinfoDict;//用户头像


@end

@implementation WalletViewController
{
    NSArray *heightForRowArr;
    NSArray *registerCellArr;
}

- (id)init
{
    if (self = [super init]) {
        if (kBeansShow) {
            heightForRowArr = @[@(140),@(140),@(180),@(110)];
        }
        else
        {
            heightForRowArr = @[@(90),@(120),@(180),@(110)];
        }
        registerCellArr = @[@"LLEarnBeansCell",@"LLStudentTaskCell",@"LLStageBillCell",@"LLMyCouponCell"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigation];
    [self setUI];
    
    
    self.couponDict = [NSMutableDictionary new];
    self.reimbursementDict = [NSMutableDictionary new];
    self.taskDict = [NSMutableDictionary new];
    self.userinfoDict = [NSMutableDictionary new];
    
    [self initWithData];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(refreshData) name:kRefreshWalletDataNotification object:nil];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(refreshPersonInfo) name:kRefreshPersonInfoNotification object:nil];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(msgRead) name:kMakeMsgIsReadNotification object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(msgRead) name:kUpdateMainMsgRedPointNotification object:nil];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(tableReresh) name:kRefreshBeansShowNotification object:nil];

    

}
-(void)tableReresh
{
    if (kBeansShow) {
        heightForRowArr = @[@(140),@(140),@(180),@(110)];
    }
    else
    {
        heightForRowArr = @[@(90),@(120),@(180),@(110)];
    }
    [self.tableView reloadData];
}
-(void)msgRead
{
    [self setNavigation];
}
-(void)refreshPersonInfo
{
    [self initWithData];
}
-(void)refreshData
{
    self.couponDict = nil;
    self.reimbursementDict = nil;
    self.taskDict = nil;
    self.userinfoDict = nil;
    
    [self.tableView reloadData];
}

- (void)setNavigation
{
    NSArray *navBtns = [self createNavWithLeftBtnImageName:nil leftHighlightImageName:nil leftBtnSelector:nil andCenterTitle:@"钱袋" andRightBtnImageName:@"图层-110" rightHighlightImageName:nil rightBtnSelector:@selector(rightBtnClick)];
    
    self.rightBtn = navBtns[1];
    
    self.rightBtn.width = 20;
    
    //1、在父控件（parentView）上显示，显示的位置TopRight
    self.badgeView = [[JSBadgeView alloc]initWithParentView:self.rightBtn alignment:JSBadgeViewAlignmentTopRight];
    //2、如果显示的位置不对，可以自己调整，超爽啊！
    self.badgeView.badgePositionAdjustment = CGPointMake(0, 3);
    //1、背景色
    self.badgeView.badgeBackgroundColor = [UIColor redColor];
    //2、没有反光面
    self.badgeView.badgeOverlayColor = [UIColor clearColor];
    //3、外圈的颜色，默认是白色
    self.badgeView.badgeStrokeColor = [UIColor redColor];
    
    /*****设置数字****/
    //1、用字符
    if ([[MessageDataBase shareInstance] queryAllUnRead].count != 0) {
        self.badgeView.badgeText = [NSString stringWithFormat:@"%ld",[[MessageDataBase shareInstance] queryAllUnRead].count];
    }
    else
    {
        self.badgeView.badgeText = nil;
    }
    //当更新数字时，最好刷新，不然由于frame固定的，数字为2位时，红圈变形
    [self.badgeView setNeedsLayout];
    
     
    
}
-(void)rightBtnClick
{
    if (kLoginStatus) {
        
        SystemMsgController *msgVC = [[SystemMsgController alloc]init];
        msgVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:msgVC animated:YES];
    }
    else
    {
        LoginGuideController * vc = [[LoginGuideController alloc]init];
        JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }


}
- (void)setUI
{
    [self setBg_TableView];
}

- (void)setBg_TableView
{
    UITableView *bg_TableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView = bg_TableView;
    [self.view addSubview:bg_TableView];
    [bg_TableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, kTabBarHeight, 0));
    }];
    bg_TableView.delegate = self;
    bg_TableView.dataSource = self;
    bg_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    bg_TableView.backgroundColor = [UIColor colorWithHexString:@"f2f7f6"];
    for (NSString *className in registerCellArr) {
        [bg_TableView registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
    }
}

//数据请求
- (void)initWithData
{
    if ([kUid isEqualToString:@"0"]) {
        return;
    }

    NSString *url = self.interfaceManager.getMypurseUrl;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Mypurse/Purse" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1)
        {
            self.couponDict = [dict[@"info"] objectForKey:@"coupon"];
            self.reimbursementDict = [dict[@"info"] objectForKey:@"reimbursement"];
            self.taskDict = [dict[@"info"] objectForKey:@"task"];
            self.userinfoDict = [dict[@"info"] objectForKey:@"userinfo"];
            [self.hudManager dismissSVHud];
            [self.tableView reloadData];
        } else if (code == 2) {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //验证失败，去登录
                LoginGuideController *loginVC = [[LoginGuideController alloc]init];
                JTNavigationController *loginnavC = [[JTNavigationController alloc] initWithRootViewController:loginVC];
                loginnavC.fullScreenPopGestureEnabled = YES;
                [UIApplication sharedApplication].keyWindow.rootViewController = loginnavC;
            });
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
    }];
}
#pragma mark - 帮助
-(void)earnBeansCell:(LLEarnBeansCell *)cell didClickHelpBtnWithDict:(NSDictionary *)dict
{

    WebHtmlController *htmlVC = [[WebHtmlController alloc]init];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"如何获取赚豆" ofType:@"html"];
    NSString *str = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    htmlVC.htmlString = str;
    htmlVC.hidesBottomBarWhenPushed = YES;
    htmlVC.titleString = @"如何获取赚豆";
    [self.navigationController pushViewController:htmlVC animated:YES];
    /*
    BaseWebController *baseVC = [[BaseWebController alloc]init];
    NSString *urlPath = self.interfaceManager.beansHowGet;
    baseVC.urlString = urlPath;
    baseVC.hidesBottomBarWhenPushed = YES;
    baseVC.titleString = @"如何获取赚豆";
    [self.navigationController pushViewController:baseVC animated:YES];
     */
}
#pragma mark - 规则
-(void)earnBeansCell:(LLEarnBeansCell *)cell didClickRuleBtnWithDict:(NSDictionary *)dict
{
    WebHtmlController *htmlVC = [[WebHtmlController alloc]init];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"赚豆规则" ofType:@"html"];
    NSString *str = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    htmlVC.htmlString = str;
    htmlVC.hidesBottomBarWhenPushed = YES;
    htmlVC.titleString = @"赚豆规则";
    [self.navigationController pushViewController:htmlVC animated:YES];
    /*
    BaseWebController *baseVC = [[BaseWebController alloc]init];
    NSString *urlPath = self.interfaceManager.beansRule;
    baseVC.urlString = urlPath;
    baseVC.hidesBottomBarWhenPushed = YES;
    baseVC.titleString = @"赚豆规则";
    [self.navigationController pushViewController:baseVC animated:YES];
     */

}
#pragma mark - 提现
-(void)earnBeansCell:(LLEarnBeansCell *)cell didClickWithdrawBtnWithDict:(NSDictionary *)dict
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
#pragma mark - 记录
-(void)earnBeansCell:(LLEarnBeansCell *)cell didClickRecordBtnWithDict:(NSDictionary *)dict
{
    if (kLoginStatus) {
        
        ExtraMoneyVC *VC = [[ExtraMoneyVC alloc]init];
        VC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
    else
    {
        LoginGuideController * vc = [[LoginGuideController alloc]init];
        JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
   

}
#pragma mark - 充值
-(void)earnBeansCell:(LLEarnBeansCell *)cell didClickRechargeBtnWithDict:(NSDictionary *)dict
{
    if (kLoginStatus) {
        
        RechargeController *withdrawVC = [[RechargeController alloc] init];
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

#pragma mark - UITableViewDelegate && UITableViewDateSource

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 10;
    }
    return CGFLOAT_MIN;

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]init];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [heightForRowArr[indexPath.section] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            LLEarnBeansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLEarnBeansCell"];
            cell.delegate = self;
            [cell.headBtn sd_setImageWithURL:[NSURL URLWithString: [_userinfoDict objectForKey:@"head"]==nil?@"0":([_userinfoDict objectForKey:@"head"])] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像"]];
            NSMutableAttributedString *attStr = [NSMutableAttributedString attributeStringWithText:[_userinfoDict objectForKey:@"name"]==nil?@"":[_userinfoDict objectForKey:@"name"] attributes:@[[UIColor colorWithHexString:@"666666"],[UIFont boldSystemFontOfSize:18*kScreenWidth/414]]];
            [attStr appendText:@" " withAttributesArr:nil];
            if ([[_userinfoDict objectForKey:@"state"] isEqualToString:@"1"]) {
                [attStr appendImg:[UIImage imageNamed:@"iconfont-circle-renzheng-1"] bounds:CGRectMake(0, -3, 15, 15)];
            }
            NSString *str = [_userinfoDict objectForKey:@"is_app"];
            if ([str isKindOfClass:[NSString class]]) {
                if ([[_userinfoDict objectForKey:@"is_app"] isEqualToString:@"1"]){
                    [attStr appendText:@" " withAttributesArr:nil];
                    [attStr appendImg:[UIImage imageNamed:@"iconfont-circle"] bounds:CGRectMake(0, -3, 15, 15)];
                }
            }
            NSLog(@"%d",kBeansShow);
            if (kBeansShow) {
                [attStr appendBreakLineWithInterval:7];
                [attStr appendText:@"赚豆:" withAttributesArr:@[[UIColor colorWithHexString:@"999999"],kFont12]];
                [attStr appendText:[_userinfoDict objectForKey:@"beans"]==nil?@"0":[_userinfoDict objectForKey:@"beans"] withAttributesArr:@[[UIColor colorWithHexString:@"fe5e5b"],kFont12]];
            }
            else
            {
                [attStr appendBreakLineWithInterval:7];
                [attStr appendText:@"" withAttributesArr:@[[UIColor colorWithHexString:@"999999"],kFont12]];
            }
            [cell.nameLbl setAttributedText:attStr];

            [cell.rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
            [cell.withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
            if (!kBeansShow) {
                cell.withdrawBtn.hidden = YES;
                cell.rechargeBtn.hidden = YES;//充值按钮
            } else {
                cell.withdrawBtn.hidden = NO;
                cell.rechargeBtn.hidden = YES;//充值按钮
            }
            NSArray *btnImgNameArr = @[@"iconfont-money-jilu",@"iconfont-money-rule",@"iconfont-money-why"];
            NSArray *btnTitleArr = @[@"赚豆流通记录",@"赚豆规则",@"如何获得赚豆"];
            int i = 0;
            for (UIButton *btn in @[cell.recordBtn,cell.ruleBtn,cell.helpBtn]) {
                [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:btnImgNameArr[i]] forState:UIControlStateNormal];
                i++;
            }
            if (!kBeansShow) {
                cell.recordBtn.hidden = YES;
                cell.ruleBtn.hidden = YES;  
                cell.helpBtn.hidden = YES;
            }
            else
            {
                cell.recordBtn.hidden = NO;
                cell.ruleBtn.hidden = NO;
                cell.helpBtn.hidden = NO;
            }
            
            return cell;
        }
            break;
        case 1:
        {
            LLStudentTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLStudentTaskCell"];
            cell.titleLbl.text = @"学员任务";
            cell.taskProgressLbl.text = @"任务进度：";
            if (kBeansShow) {
                cell.alreadyReceiveLbl.hidden = NO;
                cell.canReceiveLbl.hidden = NO;
                cell.alreadyReceiveLbl.text = [NSString stringWithFormat:@"已领：%@赚豆",[_taskDict objectForKey:@"taskBeans"]==nil?@"0":[_taskDict objectForKey:@"taskBeans"]];
                cell.canReceiveLbl.text = [NSString stringWithFormat:@"可领：%@赚豆",[_taskDict objectForKey:@"taskBeansBalance"]==nil?@"0":[_taskDict objectForKey:@"taskBeansBalance"]];
            }
            else
            {
                cell.alreadyReceiveLbl.hidden = YES;
                cell.canReceiveLbl.hidden = YES;
            }
            [cell.rightBtn setTitle:@"继续任务" forState:UIControlStateNormal];
            [cell.rightBtn setImage:[UIImage imageNamed:@"iconfont-money-rightarrow"] forState:UIControlStateNormal];
            CGFloat pro = [[_taskDict objectForKey:@"taskProgress"] floatValue];
            [cell.progressView setProgress:(float)pro/100];
            cell.delegate = self;
            return cell;
        }
            break;
        case 2:
        {
            LLStageBillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLStageBillCell"];
            cell.titleLbl.text = @"分期账单";
            NSString * progressStr = [_reimbursementDict objectForKey:@"taskProgress"];
            progressStr = progressStr == nil? @"0" : progressStr;
            NSString * str1 = [NSString stringWithFormat:@"学车费用：¥%@",progressStr];
            
            NSString * str2 = [NSString stringWithFormat:@"总  利  息：¥%@",[_reimbursementDict objectForKey:@"interest"]==nil||((NSString *)[_reimbursementDict objectForKey:@"interest"]).length==0?@"0":[_reimbursementDict objectForKey:@"interest"]];
            
            NSString * str3 = [NSString stringWithFormat:@"月\t    供：¥%@",[_reimbursementDict objectForKey:@"installmentMoney"]==nil||((NSString *)[_reimbursementDict objectForKey:@"installmentMoney"]).length==0?@"0":[_reimbursementDict objectForKey:@"installmentMoney"]];
            NSString * str4 = [NSString stringWithFormat:@"分期时限：%@个月",[_reimbursementDict objectForKey:@"installmentCount"]==nil||((NSString *)[_reimbursementDict objectForKey:@"installmentCount"]).length==0?@"0":[_reimbursementDict objectForKey:@"installmentCount"]];
            NSString * str5 = [NSString stringWithFormat:@"已\t    还：%@个月",[_reimbursementDict objectForKey:@"completeCount"]==nil?@"0":[_reimbursementDict objectForKey:@"completeCount"]];
            NSString * str6 = [NSString stringWithFormat:@"还  款  日：%@",[_reimbursementDict objectForKey:@"reimbursement"]==nil||((NSString *)[_reimbursementDict objectForKey:@"reimbursement"]).length==0?@"每月01日":[_reimbursementDict objectForKey:@"reimbursement"]];
            
            NSArray * lblTextArr = @[str1,str2,str3,str4,str5,str6];
            for (int i = 0; i < 6; i++) {
                UILabel *lbl = cell.lblArr[i];
                lbl.text = lblTextArr[i];
            }
            [cell.rightBtn setTitle:@"去还款" forState:UIControlStateNormal];
            [cell.rightBtn setImage:[UIImage imageNamed:@"iconfont-money-rightarrow"] forState:UIControlStateNormal];
            
            //state 还款状态判断（已还，未还，超时未还）
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
            
            NSString * stateStr = [_reimbursementDict objectForKey:@"state"];
            if ([stateStr isEqualToString:@"已还"]) {
                [attStr appendText:@"*本月账单已还清" withAttributesArr:@[[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1],kFont11]];
            }else if ([stateStr isEqualToString:@"未还"]){
                [attStr appendText:@"*本月账单未还  " withAttributesArr:@[[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1],kFont11]];
            }else if ([stateStr isEqualToString:@"超时未还"]){
                [attStr appendText:@"*本月超时未还  " withAttributesArr:@[[UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1],kFont11]];
            }
            cell.promptLbl.attributedText = attStr;
            
            cell.delegate = self;

            return cell;
        }
            break;
        case 3:
        {
            LLMyCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLMyCouponCell"];
            cell.titleLbl.text = @"我的代金券";
            NSArray *lblTextArr = @[[NSString stringWithFormat:@"可用：%@",[_couponDict objectForKey:@"allNum"]==nil?@"0":[_couponDict objectForKey:@"allNum"]],[NSString stringWithFormat:@"快过期：%@",[_couponDict objectForKey:@"expiredSoonNum"]==nil?@"0":[_couponDict objectForKey:@"expiredSoonNum"]],[NSString stringWithFormat:@"已过期：%@",[_couponDict objectForKey:@"expiredNum"]==nil?@"0":[_couponDict objectForKey:@"expiredNum"]]];
            for (int i = 0; i < 3; i++) {
                UILabel *lbl = cell.lblArr[i];
                lbl.text = lblTextArr[i];
            }
            [cell.rightBtn setTitle:@"查看详情" forState:UIControlStateNormal];
            [cell.rightBtn setImage:[UIImage imageNamed:@"iconfont-money-rightarrow"] forState:UIControlStateNormal];
            cell.delegate = self;

            return cell;
        }
            break;
            
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}
-(void)LLStudentTaskCellDidClickRightBtn:(LLWalletSuperCell *)cell
{
    if ([cell isKindOfClass:[LLStudentTaskCell class]]) {
        if (kLoginStatus) {
            //学员任务
            ZhuanXueFeiController *vc = [[ZhuanXueFeiController alloc]init];
            NSString *time = [HttpParamManager getTime];
            vc.urlString = [NSString stringWithFormat:@"%@?app=1&uid=%@&sign=%@&time=%@",self.interfaceManager.xueFeiTaskUrl,kUid,[HttpParamManager getSignWithIdentify:@"/task" time:time],time];
            vc.titleString = @"学员任务";
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
    if ([cell isKindOfClass:[LLStageBillCell class]]) {

        if (kLoginStatus) {
            //分期账单
            StagingBillVC * vc = [[StagingBillVC alloc] init];
            vc.installmentBIllidStr = [_reimbursementDict objectForKey:@"installmentBIllid"];
            if ([vc.installmentBIllidStr isEqualToString:@""]) {
                [self.hudManager showErrorSVHudWithTitle:@"暂无分期账单" hideAfterDelay:1.0];
                return;
            }
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

    if ([cell isKindOfClass:[LLMyCouponCell class]]) {
        
        if (kLoginStatus) {
            //我的代金券
            MyVoucherVC * vc = [[MyVoucherVC alloc] init];
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

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
