//
//  PartnerTrainingVC.m
//  学员端
//
//  Created by gaobin on 16/7/14.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LoginGuideController.h"
#import "PartnerTrainingVC.h"
#import "LocationButton.h"
#import "MyTrainerCell.h"
#import "FullImgViewCell.h"
#import "NoneReleaseCell.h"
#import "OtherTrainerCell.h"
#import "ImmediateBinglingCell.h"
#import "AlreadyReleaseCell.h"
#import "PartnerTrainingDetailVC.h"
#import "ZHPickView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "PartnerTrainModel.h"
#import "BindingTeacherModel.h"
#import "TeachingTimesModel.h"
#import "CitySelectController.h"
#import "BindCoachController.h"
@interface PartnerTrainingVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ZHPickViewDelegate>

@property (nonatomic, strong) LocationButton * rightBtn;
@property (nonatomic, strong) UIButton * leftBtn;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UITableView * subTwoTableView;
@property (nonatomic, strong) UITableView * subThreeTableView;
@property (nonatomic, strong) UIButton * subTwoBtn;
@property (nonatomic, strong) UIButton * subThreeBtn;
@property (nonatomic, strong) UIView * lineView;
/**
 *  第一个tableview
 */
@property (nonatomic, strong) PartnerTrainModel * partnerTrainModel1;
@property (nonatomic, strong) ZHPickView * fromPickView;
@property (nonatomic, strong) ZHPickView * toPickView;
@property (nonatomic, strong) ZHPickView * carTypePickView;
@property (nonatomic, assign) NSInteger startMin;
@property (nonatomic, assign) NSInteger toMin;
@property (nonatomic, strong) UIButton * fromTimeBtn;
@property (nonatomic, strong) UIButton * toTimeBtn;
@property (nonatomic, strong) UIButton * carTypeBtn;
@property (nonatomic, strong) NSString * startTimeStr;
@property (nonatomic, strong) NSString * endTimeStr;
@property (nonatomic, strong) NSString * catTypeId;

/**
 *  第二个tableview
 */
@property (nonatomic, strong) PartnerTrainModel * partnerTrainModel2;
@property (nonatomic, strong) ZHPickView * fromPickView1;
@property (nonatomic, strong) ZHPickView * toPickView1;
@property (nonatomic, strong) ZHPickView * carTypePickView1;
@property (nonatomic, assign) NSInteger startMin1;
@property (nonatomic, assign) NSInteger toMin1;
@property (nonatomic, strong) UIButton * fromTimeBtn1;
@property (nonatomic, strong) UIButton * toTimeBtn1;
@property (nonatomic, strong) UIButton * carTypeBtn1;
@property (nonatomic, strong) NSString * startTimeStr1;
@property (nonatomic, strong) NSString * endTimeStr1;
@property (nonatomic, strong) NSString * catTypeId1;


@property (nonatomic, copy) NSString * myTrainerState; // 0--未绑定,1--绑定了未发布,2--绑定了已发布

@property (nonatomic, assign) BOOL isSubjectTwo;
@property (nonatomic, assign) BOOL isSubjectThree;
@property (nonatomic, assign) BOOL isSelectTime;


@property(nonatomic,assign)int currentPage1;
@property(nonatomic,assign)int currentPage2;
@property(nonatomic,strong)NSMutableArray * carTypeDictArray;


@end

@implementation PartnerTrainingVC

#pragma mark -- lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentPage1 = 1;
    self.currentPage2 = 1;

    _myTrainerState = @"0";
    
    self.startTimeStr = @"00:00";
    
    self.endTimeStr = @"23:59";
    
    self.catTypeId = nil;
    
    self.startTimeStr1 = @"00:00";
    
    self.endTimeStr1 = @"23:59";
    
    self.catTypeId1 = nil;
    
    _isSubjectTwo = YES;
    
    self.carTypeDictArray = [NSMutableArray array];

    [self createNavigationBar];
    
    [self createScrollView];
    
    [self createTopView];
    
    [self getCarData];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(loactionChange) name:kLocationChangeNotification object:nil];

    [NOTIFICATION_CENTER addObserver:self selector:@selector(loactionChange) name:kRefreshMyCoachStateNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_fromPickView remove];
    [_toPickView remove];
    [_carTypePickView remove];
    [_fromPickView1 remove];
    [_toPickView1 remove];
    [_carTypePickView1 remove];
}

-(void)getCarData {

    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    NSString * url = self.interfaceManager.getCarUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/getCar"time:time];
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@">>>%@",dict);
        [self.hudManager dismissSVHud];
        self.carTypeDictArray = dict[@"info"][@"carType"];

    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];
}

-(void)loactionChange {
    [self createNavigationBar];
    if (_isSubjectTwo) {
        [_subTwoTableView.mj_header beginRefreshing];
    }
    if (_isSubjectThree) {
        [_subThreeTableView.mj_header beginRefreshing];
    }
}



- (void)requestMoreData {
    NSString * url = self.interfaceManager.partnerTrainUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/search/Teachings"time:time];
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    if (_isSubjectTwo) {
        paramDict[@"subject"] = @"second";
    } else {
        paramDict[@"subject"] = @"thred";
    }
    paramDict[@"lng"] = [NSString stringWithFormat:@"%f",self.locationManager.longitude];
    paramDict[@"lat"] = [NSString stringWithFormat:@"%f",self.locationManager.latitude];
    if (_isSubjectTwo) {
        paramDict[@"pageId"] = @(self.currentPage1);
        paramDict[@"carType"] = self.catTypeId;
        paramDict[@"startTime"] = self.startTimeStr;
        paramDict[@"endTime"] = self.endTimeStr;

    } else {
        paramDict[@"pageId"] = @(self.currentPage2);
        paramDict[@"carType"] = self.catTypeId1;
        paramDict[@"startTime"] = self.startTimeStr1;
        paramDict[@"endTime"] = self.endTimeStr1;
    }
    paramDict[@"city_id"] = @([HttpParamManager getCurrentCityID]);

    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@">>>%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            NSDictionary * infoDict = [dict objectForKey:@"info"];
           
            if (_isSubjectTwo)
            {

                PartnerTrainModel *model = [PartnerTrainModel mj_objectWithKeyValues:infoDict];
                [self.partnerTrainModel1.teachingTimes addObjectsFromArray:model.teachingTimes];
                
                if ([self.partnerTrainModel1.bindingTeacher.uid isEqualToString:@""]||self.partnerTrainModel1.bindingTeacher.uid ==nil) {
                    _myTrainerState = @"0";
                }
                else
                {
                    if (self.partnerTrainModel1.bindingTeacher.teachingRemarknum == 0)
                    {
                        _myTrainerState = @"1";
                    }
                    else
                    {
                        _myTrainerState = @"2";
                    }
                }
                [_subTwoTableView reloadData];
                [_subTwoTableView.mj_footer endRefreshing];
                
            }
            if (_isSubjectThree)
            {
                
                PartnerTrainModel *model = [PartnerTrainModel mj_objectWithKeyValues:infoDict];
                [self.partnerTrainModel2.teachingTimes addObjectsFromArray:model.teachingTimes];
                
                if ([self.partnerTrainModel2.bindingTeacher.uid isEqualToString:@""]||self.partnerTrainModel1.bindingTeacher.uid ==nil)
                {
                    _myTrainerState = @"0";
                }
                else
                {
                    if (self.partnerTrainModel2.bindingTeacher.teachingRemarknum == 0) {
                        _myTrainerState = @"1";
                    }else {
                        _myTrainerState = @"2";
                    }
                }
                [_subThreeTableView reloadData];
                [_subThreeTableView.mj_footer endRefreshing];

            }
            
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
            [_subTwoTableView.mj_footer endRefreshing];
            [_subThreeTableView.mj_footer endRefreshing];

        }
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
        [_subTwoTableView.mj_footer endRefreshing];
        [_subThreeTableView.mj_footer endRefreshing];
        
    }];
    
}

- (void)requestData {
    NSString * url = self.interfaceManager.partnerTrainUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/search/Teachings"time:time];
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    if (_isSubjectTwo)
    {
        paramDict[@"subject"] = @"second";
    }
    else
    {
        paramDict[@"subject"] = @"thred";
    }
    paramDict[@"lng"] = [NSString stringWithFormat:@"%f",self.locationManager.longitude];
    paramDict[@"lat"] = [NSString stringWithFormat:@"%f",self.locationManager.latitude];
    if (_isSubjectTwo)
    {
        paramDict[@"pageId"] = @(self.currentPage1);
        paramDict[@"carType"] = self.catTypeId;
        paramDict[@"startTime"] = self.startTimeStr;
        paramDict[@"endTime"] = self.endTimeStr;
        
    }
    else
    {
        paramDict[@"pageId"] = @(self.currentPage2);
        paramDict[@"carType"] = self.catTypeId1;
        paramDict[@"startTime"] = self.startTimeStr1;
        paramDict[@"endTime"] = self.endTimeStr1;
    }
    paramDict[@"city_id"] = @([HttpParamManager getCurrentCityID]);

    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@">>>%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            NSDictionary * infoDict = [dict objectForKey:@"info"];
            if (_isSubjectTwo)
            {
                self.partnerTrainModel1 = [PartnerTrainModel mj_objectWithKeyValues:infoDict];

                if ([self.partnerTrainModel1.bindingTeacher.uid isEqualToString:@""]||self.partnerTrainModel1.bindingTeacher.uid ==nil) {
                    _myTrainerState = @"0";
                }
                else
                {
                    if (self.partnerTrainModel1.bindingTeacher.teachingRemarknum == 0)
                    {
                        _myTrainerState = @"1";
                    }
                    else
                    {
                        _myTrainerState = @"2";
                    }
                }
                [_subTwoTableView reloadData];
                [_subTwoTableView.mj_header endRefreshing];

            }
            if (_isSubjectThree)
            {
                
                self.partnerTrainModel2 = [PartnerTrainModel mj_objectWithKeyValues:infoDict];

                if ([self.partnerTrainModel2.bindingTeacher.uid isEqualToString:@""]||self.partnerTrainModel1.bindingTeacher.uid ==nil)
                {
                    _myTrainerState = @"0";
                }
                else
                {
                    if (self.partnerTrainModel2.bindingTeacher.teachingRemarknum == 0) {
                        _myTrainerState = @"1";
                    }else {
                        _myTrainerState = @"2";
                    }
                }
                [_subThreeTableView reloadData];
                [_subThreeTableView.mj_header endRefreshing];

            }
            

        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
            [_subTwoTableView.mj_header endRefreshing];
            [_subThreeTableView.mj_header endRefreshing];
        }
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
        [_subTwoTableView.mj_header endRefreshing];
        [_subThreeTableView.mj_header endRefreshing];
    }];
 
}

#pragma mark -- 创建顶部按钮
- (void)createTopView {
    
    UIView * baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 42)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    _subTwoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _subTwoBtn.center = CGPointMake(kScreenWidth * 0.25, baseView.centerY);
    _subTwoBtn.bounds = CGRectMake(0, 0, 100, 30);
    [_subTwoBtn setTitle:@"科目二" forState:UIControlStateNormal];
    [_subTwoBtn addTarget:self action:@selector(subTwoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_subTwoBtn setTitleColor:[UIColor colorWithHexString:@"#64baff"] forState:UIControlStateNormal];
    _subTwoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [baseView addSubview:_subTwoBtn];

    
    _subThreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _subThreeBtn.center = CGPointMake(kScreenWidth * 0.75, baseView.centerY);
    _subThreeBtn.bounds = CGRectMake(0, 0, 100, 30);
    [_subThreeBtn setTitle:@"科目三" forState:UIControlStateNormal];
    [_subThreeBtn addTarget:self action:@selector(subThreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_subThreeBtn setTitleColor:[UIColor colorWithHexString:@"#c7c7c7"] forState:UIControlStateNormal];
    _subThreeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [baseView addSubview:_subThreeBtn];

    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#64baff"];
    _lineView.bounds = CGRectMake(0, 0, kScreenWidth/2, 1);
    _lineView.center = CGPointMake(_subTwoBtn.center.x, 41);
    [baseView addSubview:_lineView];
}

- (void)subTwoBtnClick {
    _isSubjectTwo = YES;
    _isSubjectThree = NO;
    [_subTwoTableView.mj_header beginRefreshing];
    
    [_subTwoBtn setTitleColor:[UIColor colorWithHexString:@"#64baff"] forState:UIControlStateNormal];
    [_subThreeBtn setTitleColor:[UIColor colorWithHexString:@"#c7c7c7"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.1 animations:^{
        _lineView.bounds = CGRectMake(0, 0, kScreenWidth/2, 1);
        _lineView.center = CGPointMake(_subTwoBtn.center.x, 41);
    }];
    
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

- (void)subThreeBtnClick {
    
    _isSubjectTwo = NO;
    _isSubjectThree = YES;
    [_subThreeTableView.mj_header beginRefreshing];
    
    [_subThreeBtn setTitleColor:[UIColor colorWithHexString:@"#64baff"] forState:UIControlStateNormal];
    [_subTwoBtn setTitleColor:[UIColor colorWithHexString:@"#c7c7c7"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.1 animations:^{
        _lineView.bounds = CGRectMake(0, 0, kScreenWidth/2, 1);
        _lineView.center = CGPointMake(_subThreeBtn.center.x, 41);
    }];
    
    [_scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
}

#pragma mark -- 创建scrollView作为两张表的载体
- (void)createScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 41, kScreenWidth, kScreenHeight - kNavHeight - 41)];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - kNavHeight - 41);
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    _subTwoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight - 41) style:UITableViewStyleGrouped];
    _subTwoTableView.backgroundColor = BG_COLOR;
    [_subTwoTableView registerClass:[MyTrainerCell class] forCellReuseIdentifier:@"MyTrainerCell"];
    [_subTwoTableView registerClass:[FullImgViewCell class] forCellReuseIdentifier:@"FullImgViewCell"];
    [_subTwoTableView registerClass:[NoneReleaseCell class] forCellReuseIdentifier:@"NoneReleaseCell"];
    [_subTwoTableView registerNib:[UINib nibWithNibName:@"OtherTrainerCell" bundle:nil] forCellReuseIdentifier:@"OtherTrainerCell"];
    [_subTwoTableView registerNib:[UINib nibWithNibName:@"ImmediateBinglingCell" bundle:nil] forCellReuseIdentifier:@"ImmediateBinglingCell"];
    [_subTwoTableView registerNib:[UINib nibWithNibName:@"AlreadyReleaseCell" bundle:nil] forCellReuseIdentifier:@"AlreadyReleaseCell"];
    _subTwoTableView.delegate = self;
    _subTwoTableView.dataSource = self;
    [_subTwoTableView setExtraCellLineHidden];
    _subTwoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_subTwoTableView];

    
    __weak typeof(self) weakSelf = self;
    _subTwoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage1 = 1;
        
        [weakSelf requestData];
        
    }];
    
    _subTwoTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage1 ++;
        
        [weakSelf requestMoreData];
        
    }];
    
    self.subTwoTableView.mj_footer.automaticallyHidden = YES;
    
    [self.subTwoTableView.mj_header beginRefreshing];

    
    _subThreeTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kNavHeight - 41) style:UITableViewStyleGrouped];
    [_subThreeTableView registerClass:[MyTrainerCell class] forCellReuseIdentifier:@"MyTrainerCell"];
    [_subThreeTableView registerClass:[FullImgViewCell class] forCellReuseIdentifier:@"FullImgViewCell"];
    [_subThreeTableView registerClass:[NoneReleaseCell class] forCellReuseIdentifier:@"NoneReleaseCell"];
    [_subThreeTableView registerNib:[UINib nibWithNibName:@"OtherTrainerCell" bundle:nil] forCellReuseIdentifier:@"OtherTrainerCell"];
    [_subThreeTableView registerNib:[UINib nibWithNibName:@"ImmediateBinglingCell" bundle:nil] forCellReuseIdentifier:@"ImmediateBinglingCell"];
    [_subThreeTableView registerNib:[UINib nibWithNibName:@"AlreadyReleaseCell" bundle:nil] forCellReuseIdentifier:@"AlreadyReleaseCell"];
    _subThreeTableView.backgroundColor = BG_COLOR;
    _subThreeTableView.delegate = self;
    _subThreeTableView.dataSource = self;
    [_subThreeTableView setExtraCellLineHidden];
    _subThreeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_subThreeTableView];

    _subThreeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage2 = 1;
        
        [weakSelf requestData];
        
    }];
    
    _subThreeTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage2 ++;
        
        [weakSelf requestMoreData];
        
    }];
    
    self.subThreeTableView.mj_footer.automaticallyHidden = YES;
}

#pragma mark -- 滚动视图的代理 --
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //加上判断,防止scrollView上的tableView也调用此方法导致混乱
    if (scrollView == _scrollView) {
        
        _lineView.frame = CGRectMake(scrollView.contentOffset.x/2, 41, kScreenWidth/2, 1);
        // 获取滚动视图x轴偏移量
        float contentOffsetX = scrollView.contentOffset.x;
        // 计算当前在第几页
        int currentPage = contentOffsetX/kScreenWidth+0.5;
        
        if (currentPage == 1)
        {
            
            [_subThreeTableView.mj_header beginRefreshing];
            
        }
        else
        {
            [_subTwoTableView.mj_header beginRefreshing];
            
        }
    }
}
//此scrollView的代理方法获取scrollView的实时偏移量
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    //加上判断,防止scrollView上的tableView也调用此方法导致混乱
    if (scrollView == _scrollView) {
        
         _lineView.frame = CGRectMake(scrollView.contentOffset.x/2, 41, kScreenWidth/2, 1);
        // 获取滚动视图x轴偏移量
        float contentOffsetX = scrollView.contentOffset.x;
        // 计算当前在第几页
        int currentPage = contentOffsetX/kScreenWidth+0.5;
        
        if (currentPage == 1) {
            [_subThreeBtn setTitleColor:[UIColor colorWithHexString:@"#64baff"] forState:UIControlStateNormal];
            
            [_subTwoBtn setTitleColor:[UIColor colorWithHexString:@"#c7c7c7"] forState:UIControlStateNormal];
            
            _isSubjectTwo = NO;
            
            _isSubjectThree = YES;
            
            
        }else {
            
            [_subTwoBtn setTitleColor:[UIColor colorWithHexString:@"#64baff"] forState:UIControlStateNormal];
            
            [_subThreeBtn setTitleColor:[UIColor colorWithHexString:@"#c7c7c7"] forState:UIControlStateNormal];
            
            _isSubjectTwo = YES;
            
            _isSubjectThree = NO;



        }
        
    }
    
}

#pragma mark -- tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([tableView isEqual:_subTwoTableView]) {
        return 2;
    }else {
        return 2;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_subTwoTableView]) {
        
        if (indexPath.section == 0  ) {
            
            if (indexPath.row == 0) {
                
                return 91 * AutoSizeScaleX;
                
            }if (indexPath.row == 1) {
                
                return 53;
            }
            else {
                
                AlreadyReleaseCell* cell = (AlreadyReleaseCell *)[self tableView:_subTwoTableView cellForRowAtIndexPath:indexPath];
                
                return cell.frame.size.height;
            }
            
        }else {

            OtherTrainerCell * cell = (OtherTrainerCell *)[self tableView:_subTwoTableView cellForRowAtIndexPath:indexPath];
            
            return cell.frame.size.height + 10;
            
        }
    }else {
       
        if (indexPath.section == 0  ) {
            
            if (indexPath.row == 0) {
                
                return 91;
                
            }if (indexPath.row == 1) {
                
                return 53;
            }
            else {
                
                AlreadyReleaseCell* cell = (AlreadyReleaseCell *)[self tableView:_subThreeTableView cellForRowAtIndexPath:indexPath];
                
                return cell.frame.size.height;
            }
            
        }else {
            
            OtherTrainerCell * cell = (OtherTrainerCell *)[self tableView:_subThreeTableView cellForRowAtIndexPath:indexPath];
            
            return cell.frame.size.height + 10;
            
        }
        
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_subTwoTableView]) {
        if (section == 0)
        {
            return 3;
        }
        else
        {
            return _partnerTrainModel1.teachingTimes.count;
        }
    } else {
        if (section == 0)
        {
            return 3;
        }
        else
        {
            return _partnerTrainModel2.teachingTimes.count;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_subTwoTableView]) {
        
        
        if (indexPath.section == 0 ) {
            if (indexPath.row == 0)  {
                
                static NSString * identifier = @"FullImgViewCell";
                FullImgViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.imgView.image = [UIImage imageNamed:@"学时陪练"];
                return cell;
            }
            if (indexPath.row == 1) {
                
                static NSString * identifier = @"MyTrainerCell";
                MyTrainerCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else {
              
                if ([_myTrainerState isEqualToString:@"0"]) {//未绑定教练
                
                    static NSString * identifier = @"ImmediateBinglingCell";
                    ImmediateBinglingCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (cell == nil) {
                        
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"ImmediateBinglingCell" owner:nil options:nil]lastObject];
                    }
                    cell.stateImgView.image = [UIImage imageNamed:@"您未绑定科目二教练，请先绑定"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = BG_COLOR;
                    [cell.bindingBtn addTarget:self action:@selector(bindingBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                    
                }
                if ([_myTrainerState isEqualToString:@"1"]) {//绑定教练未发布了学时
                    
                    static NSString * identifier = @"NoneReleaseCell";
                    NoneReleaseCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        
                        cell = [[[NSBundle mainBundle]loadNibNamed:@"NoneReleaseCell" owner:nil options:nil]lastObject];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = BG_COLOR;
                    cell.noneReleaseImgView.image = [UIImage imageNamed:@"您绑定的教练暂未发布学时陪练!"];
                    return cell;

                }else {//绑定教练发布了学时
                    
                    static NSString * identifier = @"AlreadyReleaseCell";
                    AlreadyReleaseCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"AlreadyReleaseCell" owner:nil options:nil] lastObject];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = BG_COLOR;
                    
                    BindingTeacherModel * bindingModel = _partnerTrainModel1.bindingTeacher;
                    BindingTeacherModel * bindingTeacher = bindingModel;
                    
                    [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:bindingTeacher.face]placeholderImage:[UIImage imageNamed:@"头像"]];
                    cell.headerImgView.clipsToBounds = YES;
                    cell.headerImgView.layer.cornerRadius = cell.headerImgView.width/2;
                    cell.nameLab.text = bindingTeacher.name;
                    //cell.nameLab.text = @"张小开";
                    cell.appointTimeLab.text = bindingTeacher.teachingRemark;
                    //cell.appointTimeLab.text = @"(15日内发布25个预约时段)";
                    cell.locationLab.text = bindingTeacher.address;
                    //cell.locationLab.text = @"合肥蜀山区临泉路与新蚌埠路交口";
                    [cell getCellHeightWithLabText:cell.locationLab.text];
                    
                    return cell;
                    
                }
             
                
            }
          
        }
        else{
            
            static NSString * identifier = @"OtherTrainerCell";

            OtherTrainerCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
            cell.backgroundColor = BG_COLOR;
            if (!cell) {
                
                cell = [[[NSBundle mainBundle]loadNibNamed:@"OtherTrainerCell" owner:nil options:nil]lastObject];
            }

            TeachingTimesModel * teachingTimes = _partnerTrainModel1.teachingTimes[indexPath.row];
           
            [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:teachingTimes.imgUrl] placeholderImage:[UIImage imageNamed:@"头像"]];

            cell.nameLab.text = teachingTimes.name;
            cell.priceLable.text = [NSString stringWithFormat:@"¥%@/小时",teachingTimes.charge];
            cell.carTypeLab.text = teachingTimes.carType;

            cell.appointTimeLab.text = teachingTimes.remark;

            cell.locationLab.text = teachingTimes.address;

            cell.distanceLab.text =  [NSString stringWithFormat:@"%@km",teachingTimes.distance];

            [cell setNeedsLayout];
            
            [cell layoutIfNeeded];
            
            [cell getCellHeightWithLab:cell.locationLab.text];
            
            return cell;
            
        }

    }else {
        
        
        if (indexPath.section == 0 ) {
            if (indexPath.row == 0)  {
                
                static NSString * identifier = @"FullImgViewCell";
                FullImgViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.imgView.image = [UIImage imageNamed:@"学时陪练"];
                return cell;
            }if (indexPath.row == 1) {
                
                static NSString * identifier = @"MyTrainerCell";
                MyTrainerCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
            else {
                if ([_myTrainerState isEqualToString:@"0"]) {
                    
                    static NSString * identifier = @"ImmediateBinglingCell";
                    ImmediateBinglingCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (cell == nil) {
                        
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"ImmediateBinglingCell" owner:nil options:nil]lastObject];
                    }
                    cell.stateImgView.image = [UIImage imageNamed:@"您未绑定科目三教练，请先绑定"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = BG_COLOR;
                    [cell.bindingBtn addTarget:self action:@selector(bindingBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                }
                if ([_myTrainerState isEqualToString:@"1"]) {
                    
                    static NSString * identifier = @"NoneReleaseCell";
                    NoneReleaseCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        
                        cell = [[[NSBundle mainBundle]loadNibNamed:@"NoneReleaseCell" owner:nil options:nil]lastObject];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = BG_COLOR;
                    cell.noneReleaseImgView.image = [UIImage imageNamed:@"您绑定的教练暂未发布学时陪练!"];
                    return cell;
                    
                }else {
                    
                    static NSString * identifier = @"AlreadyReleaseCell";
                    AlreadyReleaseCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"AlreadyReleaseCell" owner:nil options:nil] lastObject];
                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = BG_COLOR;
                    
                    BindingTeacherModel * bindingTeacher = _partnerTrainModel2.bindingTeacher;
                    // cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:bindingTeacher.]
                    cell.headerImgView.image = [UIImage imageNamed:@"列表小头像"];
                    cell.nameLab.text = bindingTeacher.name;
                    //cell.nameLab.text = @"张小开";
                    cell.appointTimeLab.text = bindingTeacher.teachingRemark;
                    //cell.appointTimeLab.text = @"(15日内发布25个预约时段)";
                    cell.locationLab.text = bindingTeacher.address;
                    //cell.locationLab.text = @"合肥蜀山区临泉路与新蚌埠路交口";
                    [cell getCellHeightWithLabText:cell.locationLab.text];
                    
                    return cell;
                    
                }
                
                
            }
            
        }
        else{
            
            static NSString * identifier = @"OtherTrainerCell";
            
            OtherTrainerCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
            if (!cell) {
                
                cell = [[[NSBundle mainBundle]loadNibNamed:@"OtherTrainerCell" owner:nil options:nil]lastObject];
            }
            cell.backgroundColor = BG_COLOR;
            
            TeachingTimesModel * teachingTimes = _partnerTrainModel2.teachingTimes[indexPath.row];
            
            [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:teachingTimes.imgUrl] placeholderImage: [UIImage imageNamed:@"头像"]];
            //cell.headerImgView.image = [UIImage imageNamed:@"列表小头像"];
            cell.nameLab.text = teachingTimes.name;
            //cell.nameLab.text = @"张伟";
            cell.carTypeLab.text = teachingTimes.carType;
            //cell.carTypeLab.text = @"车型:新桑塔纳";
            cell.appointTimeLab.text = teachingTimes.remark;
            //cell.appointTimeLab.text = @"7日内10个预约时段";
            cell.locationLab.text = teachingTimes.address;
            //cell.locationLab.text = @"合肥临泉路与新蚌埠路交口长安驾校训练场";
            cell.distanceLab.text = teachingTimes.distance;
            //cell.distanceLab.text = @"0.9km";

            
            [cell setNeedsLayout];
            
            [cell layoutIfNeeded];
            
            [cell getCellHeightWithLab:cell.locationLab.text];
            
            
            return cell;
            
        }
        

    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([tableView isEqual:_subTwoTableView]) {
        if (section == 1) {
            return 112;
        }else {
            return CGFLOAT_MIN;
        }
    }else {
        if (section == 1) {
            return 112;
        }else {
            return CGFLOAT_MIN;
        }

    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView isEqual:_subTwoTableView]) {
        return CGFLOAT_MIN;
    }else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([tableView isEqual:_subTwoTableView]) {
        if (section == 1) {
            UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 112)];
            bgView.backgroundColor = BG_COLOR;
            
            UILabel * otherTrainerLab = [[UILabel alloc] initWithFrame:CGRectMake(11, 20, 200, 20)];
            otherTrainerLab.text = @"其他教练发布的陪练";
            otherTrainerLab.textColor = [UIColor colorWithHexString:@"#666666"];
            otherTrainerLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            [bgView addSubview:otherTrainerLab];
            
            UILabel * timeLab = [[UILabel alloc] initWithFrame:CGRectMake(11, 56, 30, 12)];
            timeLab.text = @"时段:";
            timeLab.userInteractionEnabled = YES;
            timeLab.font = [UIFont systemFontOfSize:12];
            timeLab.textColor = [UIColor colorWithHexString:@"#c7c7c7"];
            [bgView addSubview:timeLab];
            
            [bgView addSubview:self.fromTimeBtn];
            [_fromTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(timeLab);
                make.left.equalTo(timeLab.mas_right).offset(5);
                make.width.offset(60);
                make.height.offset(27);
            }];
            
            UILabel * carTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(11, 90, 30, 12)];
            carTypeLab.text = @"车型:";

            carTypeLab.font = [UIFont systemFontOfSize:12];
            carTypeLab.textColor = [UIColor colorWithHexString:@"#c7c7c7"];
            [bgView addSubview:carTypeLab];

            UILabel * zhiLab = [[UILabel alloc] init];
            zhiLab.text = @"至";
            zhiLab.userInteractionEnabled = YES;
            zhiLab.textColor = [UIColor colorWithHexString:@"#999999"];
            zhiLab.font = [UIFont systemFontOfSize:12];
            [bgView addSubview:zhiLab];
            [zhiLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_fromTimeBtn.mas_right).offset(5);
                make.centerY.equalTo(_fromTimeBtn);
            }];
            
            [bgView addSubview:self.toTimeBtn];
            [_toTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(zhiLab.mas_right).offset(5);
                make.centerY.equalTo(zhiLab);
                make.width.offset(60);
                make.height.offset(27);
            }];
            
            [bgView addSubview:self.carTypeBtn];
            [_carTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_fromTimeBtn.mas_left);
                make.centerY.equalTo(carTypeLab);
                make.width.offset(100);
                make.height.offset(27);
            }];
            
            UIImageView * triangleImgView = [[UIImageView alloc] init];
            triangleImgView.image = [UIImage imageNamed:@"iconfont-jiantou(1)"];
            [_carTypeBtn addSubview:triangleImgView];
            [triangleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-10);
                make.centerY.equalTo(_carTypeBtn);
            }];
            
            
            
            return bgView;
            

        }else {
            return nil;
        }
    } else {
        
        if (section == 1) {
            UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 112)];
            bgView.backgroundColor = BG_COLOR;
            
            UILabel * otherTrainerLab = [[UILabel alloc] initWithFrame:CGRectMake(11, 20, 200, 20)];
            otherTrainerLab.text = @"其他教练发布的陪练";
            otherTrainerLab.textColor = [UIColor colorWithHexString:@"#666666"];
            otherTrainerLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            [bgView addSubview:otherTrainerLab];
            
            UILabel * timeLab = [[UILabel alloc] initWithFrame:CGRectMake(11, 56, 30, 12)];
            timeLab.text = @"时段:";
            timeLab.userInteractionEnabled = YES;
            timeLab.font = [UIFont systemFontOfSize:12];
            timeLab.textColor = [UIColor colorWithHexString:@"#c7c7c7"];
            [bgView addSubview:timeLab];
            
            [bgView addSubview:self.fromTimeBtn1];
            [_fromTimeBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(timeLab);
                make.left.equalTo(timeLab.mas_right).offset(5);
                make.width.offset(60);
                make.height.offset(27);
            }];

            UILabel * carTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(11, 90, 30, 12)];
            carTypeLab.text = @"车型:";
            
            carTypeLab.font = [UIFont systemFontOfSize:12];
            carTypeLab.textColor = [UIColor colorWithHexString:@"#c7c7c7"];
            [bgView addSubview:carTypeLab];
            
            UILabel * zhiLab = [[UILabel alloc] init];
            zhiLab.text = @"至";
            zhiLab.userInteractionEnabled = YES;
            zhiLab.textColor = [UIColor colorWithHexString:@"#999999"];
            zhiLab.font = [UIFont systemFontOfSize:12];
            [bgView addSubview:zhiLab];
            [zhiLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_fromTimeBtn1.mas_right).offset(5);
                make.centerY.equalTo(_fromTimeBtn1);
            }];

            [bgView addSubview:self.toTimeBtn1];
            [_toTimeBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(zhiLab.mas_right).offset(5);
                make.centerY.equalTo(zhiLab);
                make.width.offset(60);
                make.height.offset(27);
            }];
            
            [bgView addSubview:self.carTypeBtn1];
            [_carTypeBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_fromTimeBtn1.mas_left);
                make.centerY.equalTo(carTypeLab);
                make.width.offset(100);
                make.height.offset(27);
            }];
            

            UIImageView * triangleImgView = [[UIImageView alloc] init];
            triangleImgView.image = [UIImage imageNamed:@"iconfont-jiantou(1)"];
            [_carTypeBtn1 addSubview:triangleImgView];
            [triangleImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.offset(-10);
                make.centerY.equalTo(_carTypeBtn1);
            }];
            
            
            
            return bgView;

            
 
        }else {
            return nil;
        }
    }
    
    
}
-(UIButton *)carTypeBtn
{
    if (!_carTypeBtn) {
        UIButton * carTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _carTypeBtn = carTypeBtn;
        carTypeBtn.backgroundColor = [UIColor whiteColor];
        [carTypeBtn setTitle:@"全部" forState:UIControlStateNormal];
        [carTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [carTypeBtn addTarget:self action:@selector(carTypeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        carTypeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        carTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        carTypeBtn.contentEdgeInsets = UIEdgeInsetsMake(0,15,0,0);
        [carTypeBtn.layer setBorderColor:[UIColor colorWithHexString:@"#cccfce"].CGColor];
        [carTypeBtn.layer setBorderWidth:.5];
        

    }
    return _carTypeBtn;


}
-(UIButton *)carTypeBtn1
{
    if (!_carTypeBtn1) {
        UIButton * carTypeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _carTypeBtn1 = carTypeBtn1;
        carTypeBtn1.backgroundColor = [UIColor whiteColor];
        [carTypeBtn1 setTitle:@"全部" forState:UIControlStateNormal];
        [carTypeBtn1 setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [carTypeBtn1 addTarget:self action:@selector(carTypeBtnClick1) forControlEvents:UIControlEventTouchUpInside];
        carTypeBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
        carTypeBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        carTypeBtn1.contentEdgeInsets = UIEdgeInsetsMake(0,15,0,0);
        [carTypeBtn1.layer setBorderColor:[UIColor colorWithHexString:@"#cccfce"].CGColor];
        [carTypeBtn1.layer setBorderWidth:.5];
        
        
    }
    return _carTypeBtn1;
    
    
}
-(UIButton *)toTimeBtn
{
    if (!_toTimeBtn) {
        _toTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _toTimeBtn.backgroundColor = [UIColor whiteColor];
        [_toTimeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _toTimeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_toTimeBtn setTitle:@"23:59" forState:UIControlStateNormal];
        [_toTimeBtn addTarget:self action:@selector(toTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_toTimeBtn.layer setBorderColor:[UIColor colorWithHexString:@"#cccfce"].CGColor];
        [_toTimeBtn.layer setBorderWidth:.5];
        

    }
    return _toTimeBtn;

}
-(UIButton *)toTimeBtn1
{
    if (!_toTimeBtn1) {
        _toTimeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _toTimeBtn1.backgroundColor = [UIColor whiteColor];
        [_toTimeBtn1 setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _toTimeBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
        [_toTimeBtn1 setTitle:@"23:59" forState:UIControlStateNormal];
        [_toTimeBtn1 addTarget:self action:@selector(toTimeBtnClick1) forControlEvents:UIControlEventTouchUpInside];
        [_toTimeBtn1.layer setBorderColor:[UIColor colorWithHexString:@"#cccfce"].CGColor];
        [_toTimeBtn1.layer setBorderWidth:.5];
        
        
    }
    return _toTimeBtn1;
    
}
-(UIButton *)fromTimeBtn
{
    if (!_fromTimeBtn) {
        
        _fromTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fromTimeBtn.backgroundColor = [UIColor whiteColor];
        [_fromTimeBtn setTitle:@"00:00" forState:UIControlStateNormal];
        [_fromTimeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _fromTimeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_fromTimeBtn addTarget:self action:@selector(fromTimeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_fromTimeBtn.layer setBorderColor:[UIColor colorWithHexString:@"#cccfce"].CGColor];
        [_fromTimeBtn.layer setBorderWidth:.5];
        
    }
    
    return _fromTimeBtn;

}
-(UIButton *)fromTimeBtn1
{
    if (!_fromTimeBtn1) {
        
        _fromTimeBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _fromTimeBtn1.backgroundColor = [UIColor whiteColor];
        [_fromTimeBtn1 setTitle:@"00:00" forState:UIControlStateNormal];
        [_fromTimeBtn1 setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        _fromTimeBtn1.titleLabel.font = [UIFont systemFontOfSize:12];
        [_fromTimeBtn1 addTarget:self action:@selector(fromTimeBtnClick1) forControlEvents:UIControlEventTouchUpInside];
        [_fromTimeBtn1.layer setBorderColor:[UIColor colorWithHexString:@"#cccfce"].CGColor];
        [_fromTimeBtn1.layer setBorderWidth:.5];
        
    }
    
    return _fromTimeBtn1;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([tableView isEqual:_subTwoTableView]) {
        return nil;
    }else {
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView isEqual:_subTwoTableView]) {
        
        if (indexPath.section == 0 && indexPath.row == 2) {
            if ([_myTrainerState isEqualToString:@"2"]) {//绑定的教练发布了学时
                PartnerTrainingDetailVC * vc = [[PartnerTrainingDetailVC alloc] init];
                vc.subjectNum = @"second";
                TeachingTimesModel *teachModel = [[TeachingTimesModel alloc]init];
                BindingTeacherModel *model = self.partnerTrainModel1.bindingTeacher;
                teachModel.uid = model.uid;
                teachModel.name = model.name;
                teachModel.remark = model.teachingRemark;
                teachModel.address = model.address;
                teachModel.driving_experience = model.driving_experience;
                teachModel.imgUrl = model.face;
                teachModel.carType = model.carType;
                vc.teachModel = teachModel;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
        if (indexPath.section == 1) {
            PartnerTrainingDetailVC * vc = [[PartnerTrainingDetailVC alloc] init];
            vc.subjectNum = @"second";
            vc.teachModel = self.partnerTrainModel1.teachingTimes[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        
        if (indexPath.section == 0 && indexPath.row == 2) {
            if ([_myTrainerState isEqualToString:@"2"]) {//绑定的教练发布了学时
                PartnerTrainingDetailVC * vc = [[PartnerTrainingDetailVC alloc] init];
                vc.subjectNum = @"thred";
                TeachingTimesModel *teachModel = [[TeachingTimesModel alloc]init];
                BindingTeacherModel *model = self.partnerTrainModel1.bindingTeacher;
                teachModel.uid = model.uid;
                teachModel.name = model.name;
                teachModel.remark = model.teachingRemark;
                teachModel.address = model.address;
                teachModel.driving_experience = model.driving_experience;
                teachModel.imgUrl = model.face;
                teachModel.carType = model.carType;
                vc.teachModel = teachModel;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        if (indexPath.section == 1) {
            PartnerTrainingDetailVC * vc = [[PartnerTrainingDetailVC alloc] init];
            vc.subjectNum = @"thred";
            vc.teachModel = self.partnerTrainModel2.teachingTimes[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    
    }
    
    
}
- (void)createNavigationBar {
    
    NSArray * naviBtn = [self createRightLocationNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"学时陪练" andRightBtnImageName:@"iconfont-jiantou" rightHighlightImageName:nil rightBtnSelector:@selector(rightBtnClick)];

    _leftBtn = naviBtn[0];
    _rightBtn = naviBtn[1];
    
    [self.rightBtn setTitle:kCurrentLocationCity forState:UIControlStateNormal];
    
}
- (void)rightBtnClick
{
    CitySelectController  *citySelect = [[CitySelectController alloc]init];
    JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:citySelect];
    [self presentViewController:nav animated:YES completion:nil];
 
}
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)carTypeBtnClick1 {
    [_fromPickView1 remove];
    [_toPickView1 remove];
    [_carTypePickView1 remove];
    NSMutableArray *temp = [NSMutableArray array];
    [temp addObject:@"全部"];
    for (int i = 0; i<self.carTypeDictArray.count; i++) {
        NSDictionary *dict = self.carTypeDictArray[i];
        [temp addObject:dict[@"carName"]];
    }
    NSArray *arr = [NSArray arrayWithArray:temp];
    ZHPickView *pickView = [[ZHPickView alloc]initPickviewWithArray:arr isHaveNavControler:NO];
    pickView.tag = 407;
    _carTypePickView1 = pickView;
    [pickView setPickViewColer:[UIColor whiteColor]];
    pickView.delegate = self;
    [pickView show];

}
-(void)carTypeBtnClick
{
    [_fromPickView remove];
    [_toPickView remove];
    [_carTypePickView remove];
    NSMutableArray *temp = [NSMutableArray array];
    [temp addObject:@"全部"];
    for (int i = 0; i<self.carTypeDictArray.count; i++) {
        NSDictionary *dict = self.carTypeDictArray[i];
        [temp addObject:dict[@"carName"]];
    }
    NSArray *arr = [NSArray arrayWithArray:temp];
    ZHPickView *pickView = [[ZHPickView alloc]initPickviewWithArray:arr isHaveNavControler:NO];
    pickView.tag = 407;
    _carTypePickView = pickView;
    [pickView setPickViewColer:[UIColor whiteColor]];
    pickView.delegate = self;
    [pickView show];
 
}
- (void)fromTimeBtnClick1 {
    [_fromPickView1 remove];
    [_toPickView1 remove];
    [_carTypePickView1 remove];
    NSMutableArray *arr1 = [NSMutableArray array];
    for (int i = 0; i<24; i++) {
        [arr1 addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    NSMutableArray *arr2 = [NSMutableArray array];
    for (int i = 0; i<60; i++) {
        [arr2 addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    
    NSArray *arr = [NSArray arrayWithObjects:arr1,arr2, nil];
    ZHPickView *pickView = [[ZHPickView alloc]initPickviewWithArray:arr isHaveNavControler:NO];
    pickView.tag = 4051;
    _fromPickView1 = pickView;
    [pickView setPickViewColer:[UIColor whiteColor]];
    pickView.delegate = self;
    [pickView show];

}
- (void)fromTimeBtnClick
{
    [_fromPickView remove];
    [_toPickView remove];
    [_carTypePickView remove];
    NSMutableArray *arr1 = [NSMutableArray array];
    for (int i = 0; i<24; i++) {
        [arr1 addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    NSMutableArray *arr2 = [NSMutableArray array];
    for (int i = 0; i<60; i++) {
        [arr2 addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    NSArray *arr = [NSArray arrayWithObjects:arr1,arr2, nil];
    ZHPickView *pickView = [[ZHPickView alloc]initPickviewWithArray:arr isHaveNavControler:NO];
    pickView.tag = 405;
    _fromPickView = pickView;
    [pickView setPickViewColer:[UIColor whiteColor]];
    pickView.delegate = self;
    [pickView show];
    
}
- (void)toTimeBtnClick1 {
    [_fromPickView1 remove];
    [_toPickView1 remove];
    [_carTypePickView1 remove];
    NSMutableArray *arr1 = [NSMutableArray array];
    for (int i = 0; i<24; i++) {
        [arr1 addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    NSMutableArray *arr2 = [NSMutableArray array];
    for (int i = 0; i<60; i++) {
        [arr2 addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    NSArray *arr = [NSArray arrayWithObjects:arr1,arr2, nil];
    ZHPickView *pickView = [[ZHPickView alloc]initPickviewWithArray:arr isHaveNavControler:NO];
    pickView.tag = 4061;
    _toPickView1 = pickView;
    [pickView setPickViewColer:[UIColor whiteColor]];
    pickView.delegate = self;
    [pickView show];

}
- (void)toTimeBtnClick
{
    [_fromPickView remove];
    [_toPickView remove];
    [_carTypePickView remove];
    NSMutableArray *arr1 = [NSMutableArray array];
    for (int i = 0; i<24; i++) {
        [arr1 addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    NSMutableArray *arr2 = [NSMutableArray array];
    for (int i = 0; i<60; i++) {
        [arr2 addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    NSArray *arr = [NSArray arrayWithObjects:arr1,arr2, nil];
    ZHPickView *pickView = [[ZHPickView alloc]initPickviewWithArray:arr isHaveNavControler:NO];
    pickView.tag = 406;
    _toPickView = pickView;
    [pickView setPickViewColer:[UIColor whiteColor]];
    pickView.delegate = self;
    [pickView show];
    
}
#pragma mark -- 绑定教练
- (void)bindingBtnClick {
    
    if ([kLoginStatus intValue]!=1) {
        //未登陆，跳转到登录引导窗口
        LoginGuideController *loginVC = [[LoginGuideController alloc]init];
        JTNavigationController *loginnavC = [[JTNavigationController alloc] initWithRootViewController:loginVC];
        loginnavC.fullScreenPopGestureEnabled = YES;
        [self presentViewController:loginnavC animated:YES completion:nil];
        return;
    }
    
    BindCoachController *bindVC = [[BindCoachController alloc]init];
    
    if (_isSubjectThree) {
        bindVC.sub = @"thred";
    }
    else
    {
        bindVC.sub = @"second";
    }
    [self.navigationController pushViewController:bindVC animated:YES];
    
    
    
}
#pragma mark - ZHPickViewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    if (pickView.tag == 405) {//第一个table
        
        NSMutableArray *strArr = [[resultString componentsSeparatedByString:@"-"] mutableCopy];
        
        [strArr removeFirstObject];
        
        NSInteger hour = [strArr[0] integerValue];
        NSInteger min = [strArr[1] integerValue];
        NSInteger fromMin = hour *60 + min;
        if (fromMin>=_toMin&&_toMin!= 0) {
            [self.hudManager showErrorSVHudWithTitle:@"不能大于结束时间!" hideAfterDelay:1.0];
            return;
        }
        else
        {
            [self.fromTimeBtn setTitle:[NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]] forState:UIControlStateNormal];
            
            self.startMin = hour *60 + min;
            
            //参数发送请求
            self.startTimeStr = [NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]];
            
            
            
        }
        
    }
    
    if (pickView.tag == 406) {//第一个table
        
        NSMutableArray *strArr = [[resultString componentsSeparatedByString:@"-"] mutableCopy];
        [strArr removeFirstObject];
        NSInteger hour = [strArr[0] integerValue];
        NSInteger min = [strArr[1] integerValue];
        NSInteger toMin = hour *60 + min;
        if (toMin<=_startMin) {
            [self.hudManager showErrorSVHudWithTitle:@"不能小于开始时间!" hideAfterDelay:1.0];
            return;
        }else
        {
            self.toMin = hour *60 + min;
            [self.toTimeBtn setTitle:[NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]] forState:UIControlStateNormal];
            //参数发送请求
            self.endTimeStr = [NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]];

        }
        
    }
    
    if (pickView.tag == 407) {//第一个table
        
        [self.carTypeBtn setTitle:resultString forState:UIControlStateNormal];
        NSString *idNum = @"0";
        for (int i = 0; i<self.carTypeDictArray.count; i++) {
            NSDictionary *dict = self.carTypeDictArray[i];
            if ([dict[@"carName"] isEqualToString:resultString]) {
                idNum = dict[@"carId"];
                break;
            }
        }
        self.catTypeId = idNum;
        
    }
    if (pickView.tag == 4051) {//第二个table
        
        NSMutableArray *strArr = [[resultString componentsSeparatedByString:@"-"] mutableCopy];
        [strArr removeFirstObject];
        
        NSInteger hour = [strArr[0] integerValue];
        NSInteger min = [strArr[1] integerValue];
        NSInteger fromMin = hour *60 + min;
        if (fromMin>=_toMin1&&_toMin1!= 0) {
            [self.hudManager showErrorSVHudWithTitle:@"不能大于结束时间!" hideAfterDelay:1.0];
            return;
        }
        else
        {
            [self.fromTimeBtn1 setTitle:[NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]] forState:UIControlStateNormal];
            
            self.startMin1 = hour *60 + min;
            
            //参数发送请求
            self.startTimeStr1 = [NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]];
        }
        
    }
    
    if (pickView.tag == 4061) {//第二个table
        
        NSMutableArray *strArr = [[resultString componentsSeparatedByString:@"-"] mutableCopy];
        [strArr removeFirstObject];
        NSInteger hour = [strArr[0] integerValue];
        NSInteger min = [strArr[1] integerValue];
        NSInteger toMin = hour *60 + min;
        if (toMin<=_startMin1) {
            [self.hudManager showErrorSVHudWithTitle:@"不能小于开始时间!" hideAfterDelay:1.0];
            return;
        }else
        {
            self.toMin1 = hour *60 + min;
            [self.toTimeBtn1 setTitle:[NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]] forState:UIControlStateNormal];
            //参数发送请求
            self.endTimeStr1 = [NSString stringWithFormat:@"%@:%@",strArr[0],strArr[1]];
        }
        
    }
    
    if (pickView.tag == 407) {//第二个table
        
        [self.carTypeBtn1 setTitle:resultString forState:UIControlStateNormal];
        NSString *idNum = @"0";
        for (int i = 0; i<self.carTypeDictArray.count; i++) {
            NSDictionary *dict = self.carTypeDictArray[i];
            if ([dict[@"carName"] isEqualToString:resultString]) {
                idNum = dict[@"carId"];
                break;
            }
        }
        self.catTypeId1 = idNum;
    }
    
    if (_isSubjectTwo)
    {
        [_subTwoTableView.mj_header beginRefreshing];
        
    }
    else
    {
        [_subThreeTableView.mj_header beginRefreshing];

    }

    
}


@end
