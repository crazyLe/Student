//
//  HomeViewController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "HomeViewController.h"
#import "LocationButton.h"
#import "EnrollCell.h"
#import "TopLineCell.h"
#import "SubjectOneHomeVC.h"
#import "SubjectThreeHomeVC.h"
#import "SubjectTwoHomeVC.h"
#import "StudyCell.h"
#import "TestCell.h"
#import "PhotoCell.h"
#import "NewWalfCell.h"
#import "RecommendPackageCell.h"
#import "ZeroNoneCell.h"
#import "PartnerTrainingDetailVC.h"
#import "PartnerTrainingVC.h"
#import "SubjectOneExamHomeVC.h"
#import "SubjectTwoExamHomeVC.h"
#import "FindCoachVC.h"
#import "FindDriverSchoolVC.h"
#import "PersonalTailController.h"
#import "VoucherViewController.h"
#import "MsgNotificationController.h"
#import "CitySelectController.h"
#import <JTNavigationController.h>
#import <JSBadgeView.h>
#import "LoginGuideController.h"
#import "BannerImageModel.h"
#import "KZRecommendPackage.h"
#import "SubjectFourHomeVC.h"
#import "BaseWebController.h"
#import "ZhuanXueFeiController.h"
#import "StudentPersonalController.h"
#import "WeiMingPianWebController.h"
#import "DebitCreditController.h"
#import "KZWebController.h"
#import "KZADLunchView.h"

//暂时import，要删
#import "StagesApplyResultController.h"
#import "UIView+Cover.h"
#import "ApplyOnlineViewController.h"
#import "LookExamAreaVC.h"
#import "JpushManager.h"
#import "SystemMsgController.h"
#import "MessageDataBase.h"
#import "CircleDetailWebController.h"
#import "CircleJSManager.h"
#import "CircleTopLineController.h"


static NSString *const kRecommendPackageCellID = @"RecommendPackageCell";

static NSString *const kZeroNoneCellID = @"ZeroNoneCell";

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,StudyCellDelegate,TestCellDelegate,EnrollCellDelegate,NewWalfCellDelegate,TopLineCellDelegate,PhotoCellDelegate>

@property(nonatomic, strong)LocationButton *leftBtn;

@property(nonatomic, strong)UIButton *rightBtn;

@property(nonatomic, strong)JSBadgeView *badgeView;

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSMutableArray *bannerArray;

@property(nonatomic, strong)NSMutableArray *showImagesArray;

@property(nonatomic, strong)NSMutableArray *studentTopArray;

@property(nonatomic, strong) KZRecommendPackage *recommendPackage;

@property(nonatomic, strong) BannerImageModel *popADItem;

@property(nonatomic, strong) KZADLunchView *popADView;

@property(nonatomic, assign) BOOL shouldPopADView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bannerArray = [NSMutableArray array];
    
    self.showImagesArray = [NSMutableArray array];
    
    self.studentTopArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f7f6"];
    
    [self configNav];
    
    [self createUI];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(loactionChange) name:kLocationChangeNotification object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(msgRead) name:kMakeMsgIsReadNotification object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(msgRead) name:kUpdateMainMsgRedPointNotification object:nil];

    [self sendrequest];
    //jpush监听
    [[JpushManager sharedJpushManager] startMonitor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.shouldPopADView) {
        [self showPopAD];
    }
}

- (void)sendrequest {
    [self loadData];
}

-(void)msgRead {
    [self configNav];
}

-(void)dealloc {
    [NOTIFICATION_CENTER removeObserver:self];
}

-(void)loactionChange {
    
    NSString *str = kCurrentLocationCity;
    
    if (str.length > 0) {

        [self.leftBtn setTitle:str forState:UIControlStateNormal];
        /*
        CGSize locationSize = [str sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 20)];
        
        self.leftBtn.width = ((float)locationSize.width+10)*4/3;
         */
        
        CGSize locationSize = [str sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 20)];
        
        self.leftBtn.width = ((float)locationSize.width+10)*4/3;
        
        [self.leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.leftBtn.frame.size.width/1.5+5/2.0, 0, -self.leftBtn.frame.size.width/1.5-5/2.0)];
    }

    [self sendrequest];
}

-(void)loadData {

    NSString *url = self.interfaceManager.mainUrl;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/main/index" time:time];
    param[@"cityId"] = @([HttpParamManager getCurrentCityID]);

    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray *arr = [dict[@"info"] objectForKey:@"banners"];
                self.bannerArray = [BannerImageModel mj_objectArrayWithKeyValuesArray:arr];
                NSArray *arrImg = [dict[@"info"] objectForKey:@"showImgs"];
                NSArray *arrTop = [dict[@"info"] objectForKey:@"studentTop"];
                NSDictionary *recommendDic = dict[@"info"][@"customised"];
                NSDictionary *adDic = dict[@"info"][@"popad"];
                self.popADItem = [BannerImageModel mj_objectWithKeyValues:adDic];
                self.recommendPackage = [KZRecommendPackage mj_objectWithKeyValues:recommendDic];
                self.showImagesArray = arrImg.mutableCopy;
                self.studentTopArray = arrTop.mutableCopy;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    if (self.popADItem && self.popADItem.imgUrl.length > 0) {
                        self.shouldPopADView = YES;
                        [self showPopAD];
                    }
                });
            });
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //验证失败，去登录
                LoginGuideController *loginVC = [[LoginGuideController alloc]init];
                JTNavigationController *loginnavC = [[JTNavigationController alloc] initWithRootViewController:loginVC];
                loginnavC.fullScreenPopGestureEnabled = YES;
                [UIApplication sharedApplication].keyWindow.rootViewController = loginnavC;
            });
        }
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
        //验证失败，去登录
        LoginGuideController *loginVC = [[LoginGuideController alloc]init];
        JTNavigationController *loginnavC = [[JTNavigationController alloc] initWithRootViewController:loginVC];
        loginnavC.fullScreenPopGestureEnabled = YES;
        [UIApplication sharedApplication].keyWindow.rootViewController = loginnavC;
    }];
}

-(void)createUI {
    //创建UITableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-kNavHeight-kTabBarHeight) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setExtraCellLineHidden];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"EnrollCell" bundle:nil] forCellReuseIdentifier:@"EnrollCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendPackageCell" bundle:nil] forCellReuseIdentifier:kRecommendPackageCellID];
}

-(void)topLineCell:(TopLineCell *)cell didClickCircleLabelWithDict:(NSDictionary *)dict {
    NSString *url = dict[@"communityUrl"];
    CircleDetailWebController *circleDetail  =[[CircleDetailWebController alloc]init];
    circleDetail.hidesBottomBarWhenPushed = YES;
    circleDetail.urlString = [NSString stringWithFormat:@"%@?app=1&uid=%@",url,kUid];
    CircleJSManager *js_Manager = [[CircleJSManager alloc] init];
    circleDetail.js_Manager = js_Manager;
    circleDetail.object = @(1);
    [self.navigationController pushViewController:circleDetail animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        CircleTopLineController *vc = [[CircleTopLineController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.url = @"https://www.kangzhuangxueche.com/index.php/wap/circle?circleId=1&app=1";
        vc.url2 = @"https://www.kangzhuangxueche.com/index.php/wap/topic?circleId=1&app=1";
        vc.object = @"1";
        CircleJSManager *js_Manager = [[CircleJSManager alloc] init];
        vc.js_Manager = js_Manager;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    } else if (section == 1) {
        return CGFLOAT_MIN;
    } else if (section == 4) {
        return CGFLOAT_MIN;
    } else if (section == 5) {
        return CGFLOAT_MIN;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0.283*kScreenWidth+20+18+8+16+(kScreenWidth-28)/4;
    } else if (indexPath.section == 1) {
        if (self.recommendPackage && self.recommendPackage.name) {
            return 200;
        }
        return 0;
    } else if (indexPath.section == 2) {
        return 49;
    } else if (indexPath.section == 3) {
        StudyCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"StudyCell" owner:nil options:nil]lastObject];
        return cell.cellHeight;
    } else if (indexPath.section == 4) {
        TestCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"TestCell" owner:nil options:nil]lastObject];
        return cell.cellHeight;
    } else if (indexPath.section == 5) {
        PhotoCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"PhotoCell" owner:nil options:nil]lastObject];
        return cell.cellHeight;
    } else if (indexPath.section == 6) {
        NewWalfCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"NewWalfCell" owner:nil options:nil]lastObject];
        return cell.cellHeight;
    }
    
    return 0;
}
/**
 返回每一行的估计高度（IOS7以及以后）
 只返回了估计高度，那么就会先调用tableView:cellForRowIndexPath:方法创建cell，在调
 用tableView heightForRowAtIndexPath:方法获取cell的真实高度。
 */
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString *identify = @"EnrollCell";
        EnrollCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"EnrollCell" owner:nil options:nil]lastObject];
        }
        cell.delegate = self;
        cell.imagesModel = self.bannerArray;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1) {
        if (self.recommendPackage && self.recommendPackage.name) {
            RecommendPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecommendPackageCellID forIndexPath:indexPath];
            [cell configForRecommendPackage:self.recommendPackage];
            cell.cellClickedHandle = ^(RecommendPackageCell *cell) {
                KZWebController *webCtl = [[KZWebController alloc] initWithNibName:@"KZWebController" bundle:nil];
                webCtl.hidesBottomBarWhenPushed = YES;
                webCtl.withOrderInteration = YES;
                NSString *address = [NSString stringWithFormat:@"%@,%@",[HttpParamManager getLongitude],[HttpParamManager getLatitude]];
                if ([self.recommendPackage.url containsString:@"?"]) {
                    webCtl.webURL = [self.recommendPackage.url stringByAppendingFormat:@"&address=%@&uid=%@&cityId=%zd&app=1",address,kUid,[HttpParamManager getCurrentCityID]];
                } else {
                    webCtl.webURL = [self.recommendPackage.url stringByAppendingFormat:@"?address=%@&uid=%@&cityId=%zd&app=1",address,kUid,[HttpParamManager getCurrentCityID]];
                }
                webCtl.title = self.recommendPackage.name;
                [self.navigationController pushViewController:webCtl animated:YES];
            };

            return cell;
        } else {
            ZeroNoneCell *cell = [[ZeroNoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kZeroNoneCellID];
            return cell;
        }
    } else if (indexPath.section == 2) {
        
        static NSString *identify = @"TopLineCell";
        
        TopLineCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"TopLineCell" owner:nil options:nil]lastObject];
        }
        if (self.studentTopArray.count != 0) {
            
            cell.studentTopArray = self.studentTopArray;

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    } else if (indexPath.section == 3) {
        
        static NSString *identify = @"StudyCell";
        
        StudyCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"StudyCell" owner:nil options:nil]lastObject];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    } else if (indexPath.section == 4) {
        
        static NSString *identify = @"TestCell";
        
        TestCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"TestCell" owner:nil options:nil]lastObject];
        }
        cell.delegate =self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    } else if (indexPath.section == 5) {
        
        static NSString *identify = @"PhotoCell";
        
        PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PhotoCell" owner:nil options:nil]lastObject];
        }
        cell.delegate = self;
        cell.photoArray = self.showImagesArray;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    } else if (indexPath.section == 6) {
        
        static NSString *identify = @"NewWalfCell";
        
        NewWalfCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"NewWalfCell" owner:nil options:nil]lastObject];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    
    return nil;
}

-(void)photoCell:(PhotoCell *)cell didClickBtnWithUrl:(NSString *)url {
    CircleDetailWebController *circleDetail  =[[CircleDetailWebController alloc]init];
    
    circleDetail.hidesBottomBarWhenPushed = YES;
    
    circleDetail.urlString = [NSString stringWithFormat:@"%@?app=1&uid=%@&cityId=%zd&address=%@,%@",url,kUid,[HttpParamManager getCurrentCityID],[HttpParamManager getLongitude],[HttpParamManager getLatitude]];
    CircleJSManager *js_Manager = [[CircleJSManager alloc] init];
    circleDetail.js_Manager = js_Manager;
    circleDetail.object = @(1);
    
    [self.navigationController pushViewController:circleDetail animated:YES];
}

#pragma mark - 福利按钮点击
-(void)newWalfCell:(NewWalfCell *)cell didClickBtnWithBtnType:(NewWalfCellBtnType)type {
    switch (type) {
        case NewWalfCellBtnWeiMingPian://微名片
        {
            if (kLoginStatus) {
                WeiMingPianWebController *vc =[[WeiMingPianWebController alloc]init];
                vc.urlString = [NSString stringWithFormat:self.interfaceManager.weiMingPianUrl,kUid,kUid,[HttpParamManager getCurrentCityID]];
                vc.titleString = @"微名片";
                vc.hidesBottomBarWhenPushed  = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                LoginGuideController *loginVC = [[LoginGuideController alloc]init];
                JTNavigationController *loginnavC = [[JTNavigationController alloc] initWithRootViewController:loginVC];
                loginnavC.fullScreenPopGestureEnabled = YES;
                [self presentViewController:loginnavC animated:YES completion:nil];

            }
        }
            break;
        case NewWalfCellBtnZhuanXueFei://赚学费
        {
            ZhuanXueFeiController *vc = [[ZhuanXueFeiController alloc]init];
            NSString *time = [HttpParamManager getTime];
            vc.urlString = [NSString stringWithFormat:@"%@?app=1&uid=%@&sign=%@&time=%@",self.interfaceManager.xueFeiTaskUrl,kUid,[HttpParamManager getSignWithIdentify:@"/task" time:time],time];
            vc.titleString = @"赚学费";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case NewWalfCellBtnDaiJingQuan://代金券
        {
            VoucherViewController *vouchVC = [[VoucherViewController alloc]init];
            vouchVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vouchVC animated:YES];
        }
            break;

        case NewWalfCellBtnDebitredit:
        {
            DebitCreditController *debitCreditCtl = [[DebitCreditController alloc] initWithNibName:@"DebitCreditController" bundle:nil];
            debitCreditCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:debitCreditCtl animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 学习按钮点击
-(void)testCell:(TestCell *)cell didClickSubjectButtonWithType:(SubjectButtonType)btnType
{
    switch (btnType) {
        case SubjectBtn1:
        {
            SubjectOneExamHomeVC *subject1 = [[SubjectOneExamHomeVC alloc]init];
            subject1.subjectNum = @"一";
            subject1.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:subject1 animated:YES];
        
        }
            break;
            
        case SubjectBtn4:
        {
            SubjectOneExamHomeVC *subject1 = [[SubjectOneExamHomeVC alloc]init];
            subject1.subjectNum = @"四";
            subject1.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:subject1 animated:YES];
            
        }
            break;
            
        case KanTestBtn:
        {
            
            LookExamAreaVC * vc = [[LookExamAreaVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
      
        }
            break;

        default:
            break;
    }
}

#pragma mark -- 报名按钮点击
- (void)enrollCellDidClickBtnWithBtnType:(EnrollCellBtnType)btnType {
    
    switch (btnType) {
        case EnrollCellBtnfindDriverSchool:
        {
            FindDriverSchoolVC * vc = [[FindDriverSchoolVC alloc] init];
            
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
         
        case EnrollCellBtnfindCoachBtn:
        {
            FindCoachVC *findeCoachVC = [[FindCoachVC alloc] init];
            findeCoachVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:findeCoachVC animated:YES];
        }
            break;
            
        case EnrollCellBtnpersonalBtn:
        {

            StudentPersonalController *vc = [[StudentPersonalController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            NSString *address = [NSString stringWithFormat:@"%@,%@",[HttpParamManager getLongitude],[HttpParamManager getLatitude]];
            vc.urlString = [NSString stringWithFormat:@"%@?uid=%@&app=1&cityId=%zd&address=%@",self.interfaceManager.personalUrl,kUid,[HttpParamManager getCurrentCityID],address];;

            vc.titleString = @"私人订制";
            vc.dynamicTitle = YES;
            [self.navigationController pushViewController:vc animated:YES];

            
        }
            break;
            
        case EnrollCellBtnselfTestBtn:
        {
           
            BaseWebController *baseVC = [[BaseWebController alloc]init];
            NSString *urlStr = [NSString stringWithFormat:@"%@?city_id=%zd",self.interfaceManager.zixueUrl,[HttpParamManager getCurrentCityID]];
            baseVC.urlString = urlStr;
            baseVC.titleString = @"自学直考";
            baseVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:baseVC animated:YES];
            
            
            
        }
            break;
        case EnrollCellBtnBaoMingBtn:
        {
            
            BaseWebController *baseVC = [[BaseWebController alloc]init];
            NSString *urlStr =self.interfaceManager.enlistnoticUrl;
            baseVC.urlString = urlStr;
            baseVC.titleString = @"报名须知";
            baseVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:baseVC animated:YES];
            
            
        }
            break;
            
        default:
            break;
    }
}

-(void)enrollCell:(EnrollCell *)cell didSelectBannerItemAtIndex:(NSInteger)index {
    /*
     BannerImageModel * banners = self.bannerArray[index];
     BaseWebController *vc = [[BaseWebController alloc]init];
     vc.urlString = banners.pageUrl;
     vc.titleString = banners.pageTag;
     vc.hidesBottomBarWhenPushed = YES;
     [self.navigationController pushViewController:vc animated:YES];
     */
}


#pragma mark - 学习按钮点击
-(void)studyCellDidClickBtnWithButtonType:(StudyCellButtonType)btnType {
    switch (btnType) {
        case StudyCellButtonSubjectOne://科目一
        {
            SubjectOneHomeVC * vc = [[SubjectOneHomeVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case StudyCellButtonSubjectTwo://科目二
        {
            SubjectTwoHomeVC * vc = [[SubjectTwoHomeVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case StudyCellButtonSubjectThree://科目三
        {
            SubjectThreeHomeVC * vc = [[SubjectThreeHomeVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case StudyCellButtonSubjectFour://科目四
        {
            SubjectFourHomeVC * vc = [[SubjectFourHomeVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        case StudyCellButtonSubjectOrder://预约练车
        {
            StagesApplyResultController *vc = [[StagesApplyResultController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
            
        case StudyCellButtonSubjectStudy://学时陪练
        {
            PartnerTrainingVC * vc = [[PartnerTrainingVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
            
        default:
            break;
    }

}

-(void)configNav
{
    NSArray *navBtns = [self createMainNavWithLeftBtnImageName:@"iconfont-jiantou" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:@"康庄学车" andRightBtnImageName:@"图层-110" rightHighlightImageName:nil rightBtnSelector:@selector(rightBtnClick)];
    
    self.leftBtn = navBtns[0];
    
    self.rightBtn = navBtns[1];
    
    [RACObserve(self.locationManager, placeMark) subscribeNext:^(CLPlacemark *x) {
        
        NSString *str = self.locationManager.placeMark.locality;
        
        if (str.length > 0) {
            
            NSString *city = [self.locationManager.placeMark.locality substringToIndex:self.locationManager.placeMark.locality.length];
            
            [self.leftBtn setTitle:city forState:UIControlStateNormal];
            /*
            CGSize locationSize = [city sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, 20)];
            
            self.leftBtn.width = ((float)locationSize.width+10)*4/3;
            */
        
            [USER_DEFAULT setObject:city forKey:@"locationCity"];

        }

    }];
    
    [self.leftBtn setTitle:kCurrentLocationCity forState:UIControlStateNormal];

    
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
        self.badgeView.badgeText = [NSString stringWithFormat:@"%zd",[[MessageDataBase shareInstance] queryAllUnRead].count];
    } else {
        self.badgeView.badgeText = nil;
    }
    //当更新数字时，最好刷新，不然由于frame固定的，数字为2位时，红圈变形
    [self.badgeView setNeedsLayout];
}


-(void)leftBtnClick {
    CitySelectController  *citySelect = [[CitySelectController alloc]init];
    JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:citySelect];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)rightBtnClick {
    if (kLoginStatus) {
        SystemMsgController *msgVC = [[SystemMsgController alloc]init];
        msgVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:msgVC animated:YES];
    } else {
        LoginGuideController * vc = [[LoginGuideController alloc]init];
        JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark -- 弹屏广告
- (void)showPopAD {
    BOOL hasPopedADView = [[USER_DEFAULT objectForKey:@"hasPopedADView"] boolValue];
    if (hasPopedADView) {
        return;
    }

    if (self.view.window && self.shouldPopADView) {

        BOOL hasCachedADImage = [[SDImageCache sharedImageCache] diskImageExistsWithKey:self.popADItem.imgUrl];
        if (hasCachedADImage) {
            [self.popADView setContainerView:[self createPopADView]];

            [self.popADView show];
            self.shouldPopADView = NO;
            [USER_DEFAULT setObject:@(YES) forKey:@"hasPopedADView"];
            [USER_DEFAULT synchronize];
        } else {
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.popADItem.imgUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {

            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [self.popADView setContainerView:[self createPopADView]];

                [self.popADView show];
                self.shouldPopADView = NO;
                [USER_DEFAULT setObject:@(YES) forKey:@"hasPopedADView"];
                [USER_DEFAULT synchronize];
            }];
        }
    }
}

- (UIView *)createPopADView {
    CGFloat imageWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 40;
    CGFloat imageHeight = imageWidth * 805 / 702;

    UIView *adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
    adView.backgroundColor = [UIColor clearColor];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:adView.bounds];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.popADItem.imgUrl]];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adClickedHandle)];
    [imageView addGestureRecognizer:tap];

    [adView addSubview:imageView];
    imageView.center = adView.center;

    return adView;
}

- (void)adClickedHandle {
    [self.popADView close];

    KZWebController *webCtl = [[KZWebController alloc] initWithNibName:@"KZWebController" bundle:nil];
    webCtl.hidesBottomBarWhenPushed = YES;
    webCtl.withOrderInteration = YES;
    NSString *address = [NSString stringWithFormat:@"%@,%@",[HttpParamManager getLongitude],[HttpParamManager getLatitude]];
    if ([self.popADItem.pageUrl containsString:@"?"]) {
        webCtl.webURL = [self.popADItem.pageUrl stringByAppendingFormat:@"&address=%@&uid=%@&cityId=%zd&app=1",address,kUid,[HttpParamManager getCurrentCityID]];
    } else {
        webCtl.webURL = [self.popADItem.pageUrl stringByAppendingFormat:@"?address=%@&uid=%@&cityId=%zd&app=1",address,kUid,[HttpParamManager getCurrentCityID]];
    }

    webCtl.dynamicTitle = YES;
    [self.navigationController pushViewController:webCtl animated:YES];
}

#pragma mark -- getters and setters
- (KZADLunchView *)popADView {
    if (!_popADView) {
        _popADView = [[KZADLunchView alloc] init];
    }
    return _popADView;
}

@end
