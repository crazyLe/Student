//
//  FindCoachVC.m
//  学员端
//
//  Created by gaobin on 16/7/19.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "NSMutableAttributedString+LLExtension.h"
#import "LLCoachCardCell.h"
#import "LLBannerCell.h"
#import "LLPackupOrOpenCell.h"
#import "OneCenterBtnCell.h"
#import "LLMoreFilterCell.h"
#import "LLLicenceTypeCell.h"
#import "LLThreeSelectBtnCell.h"
#import "LLPromptCell.h"
#import "FindCoachVC.h"
#import "SearchTagsModel.h"
#import "ADModel.h"
#import "FindCoachModel.h"
#import "CoachDetailWebController.h"
#import "StudentPersonalController.h"
#import "CitySelectController.h"
#define filterSelectKey(i) [NSString stringWithFormat:@"filterSelect_%d",i]

@interface FindCoachVC () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray * dataArray;
/**
 *  是否推荐
 */
@property(nonatomic,assign)BOOL isRecommended;
/**
 *  距离优先
 */
@property(nonatomic,assign)BOOL isDistance;
/**
 *  男女
 */
@property(nonatomic,assign)int male;
/**
 *  是否考虑私人订制
 */
@property(nonatomic,assign)BOOL customized;
/**
 *  搜索条件集合接口中自定义的搜索条件，拿证时间
 */
@property(nonatomic,copy)NSString * wanted;
/**
 *  搜索条件集合搜索条件，学习时间
 */
@property(nonatomic,copy)NSString * learnTime;

/**
 *  车型
 */
@property(nonatomic,copy)NSString * certname;
//广告模型
@property(nonatomic,strong)ADModel *banner;
//教练集合
@property(strong,nonatomic)NSMutableArray *coachs;


@property(nonatomic,strong)UIButton * openBtn;


@end


@implementation FindCoachVC
{
    NSArray *numOfRowsArr;
    NSMutableArray *heightForRowArr;
    NSArray *registerCellArr;
    NSArray *threeSelectBtnImgArr;
    NSArray *licenceTypeArr;
    
    NSArray *filterCellTypeArr;
    NSMutableArray *filterTitleArr;
    NSMutableArray *helperBtnArr;
    NSMutableArray *filterBtnTitleArr;
    
    NSMutableDictionary *filterSelectDic;
    
    BOOL isOpenFilterSection;
    
    UITableView *bg_TableView;
    UIButton *_rightBtn;
    int curpage;
    
}

-(NSMutableArray *)coachs
{
    if (!_coachs) {
        _coachs = [NSMutableArray array];
    }
    return _coachs;
}

- (id)init
{
    if (self = [super init]) {
        
        self.dataArray = [NSMutableArray array];
        
        numOfRowsArr = @[@(3),@(4),@(2),@(self.coachs.count)];
        heightForRowArr = @[@[@(60),@(90),@(65)],@[@(60),@(90),@(90),@(65)],@[@(60),@(50),@(37+kScreenWidth*489/1180)],@(170)].mutableCopy;
        registerCellArr = @[@"LLPromptCell",@"LLThreeSelectBtnCell",@"LLLicenceTypeCell",@"LLMoreFilterCell",@"OneCenterBtnCell",@"LLPackupOrOpenCell",@"LLBannerCell",@"LLCoachCardCell"];
        threeSelectBtnImgArr = @[@[@"iconfont-teacher-juli-拷贝",@"iconfont-teacher-juli"],@[@"iconfont-teacher-nan",@"iconfont-teacher-nan-拷贝"],@[@"iconfont-teacher-nv",@"iconfont-teacher-nv-拷贝"]];
        licenceTypeArr = @[@"C1",@"C2"];
        
        filterCellTypeArr = @[@(LLMoreFilterCellTypeRadio),@(LLMoreFilterCellTypeRadio),@(LLMoreFilterCellTypeRadio),@(LLMoreFilterCellTypeRadio)];
        
        filterTitleArr = [NSMutableArray array];
        helperBtnArr = [NSMutableArray array];
        filterBtnTitleArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    curpage = 1;
    
    self.isDistance = NO;
    
    self.male = 0;
    
    self.isRecommended = YES;
    
    self.customized = NO;
    
    self.wanted = nil;
    
    self.learnTime = nil;
    
    self.certname = @"1";
    
    [self createNavigationBar];
    
    [self setUI];
    
    [self prepareData];
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
    
    [self loadCoachsSerachTag];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(loactionChange) name:kLocationChangeNotification object:nil];
}

-(void)loactionChange {
    NSString *locationCity = kCurrentLocationCity;
    
    if (locationCity.length>0) {
        [_rightBtn setTitle:locationCity forState:UIControlStateNormal];
        [_rightBtn sizeToFit];
    }
    
    [bg_TableView.mj_header beginRefreshing];
}

-(void)loadCoachsSerachTag {
    
    NSString *url = self.interfaceManager.coachsSerachTagUrl;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/search/CoachsSerachTag" time:time];
    
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1) {
            
            NSArray *arr = dict[@"info"][@"serachTags"];
            self.dataArray = [SearchTagsModel mj_objectArrayWithKeyValuesArray:arr];

            for (SearchTagsModel *model in self.dataArray) {
                [filterTitleArr addObject:model.title];
                [helperBtnArr addObject:@""];
                NSMutableArray *temp = [NSMutableArray array];
                for (ValueModel *valueModel in model.values) {
                    [temp addObject:valueModel.title];
                }
                [filterBtnTitleArr addObject:temp];
            }
            [filterTitleArr addObject:@"你是否考虑私人订制学车服务？"];
            [helperBtnArr addObject:@""];
            [filterBtnTitleArr addObject:@[@"考虑",@"不考虑"].mutableCopy];
            numOfRowsArr = @[@(3),@(filterTitleArr.count),@(2),@(4)];
            heightForRowArr = [NSMutableArray array];
            [heightForRowArr addObject:@[@(60),@(90),@(65)]];
            NSMutableArray *arr1 = [NSMutableArray array];
            for (int i = 0 ; i<filterBtnTitleArr.count; i++) {
                NSMutableArray *temp = filterBtnTitleArr[i];
                if (temp.count>=4) {
                    [arr1 addObject:@(100*kHeightScale)];
                } else {
                    [arr1 addObject:@(75*kHeightScale)];
                }
            }
            [heightForRowArr addObject:arr1];
            [heightForRowArr addObject:@[@(60),@(50),@(37+kScreenWidth*489/1180)]];
            [heightForRowArr addObject:@[@(170),@(170),@(170),@(170)]];

            [bg_TableView reloadData];

            [self.hudManager dismissSVHud];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];
}

-(void)loadData {
    
    NSString *url = self.interfaceManager.searchCoachs;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Search/SearchCoachs" time:time];
    param[@"distance"] = @(self.isDistance);
    if (self.male != 0) {
        param[@"male"] = @(self.male);
    }
    param[@"lng"] = [HttpParamManager getLongitude];
    param[@"lat"] = [HttpParamManager getLatitude];
    param[@"cityId"] = @([HttpParamManager getCurrentCityID]);
    param[@"recommended"] = @(self.isRecommended);
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    param[@"theLocal"] = @(1);
    param[@"customized"] = @(self.customized);
    param[@"wanted"] = self.wanted;
    param[@"learntime"] = self.learnTime;
    param[@"certname"] = self.certname;
    param[@"pageId"] = [NSString stringWithFormat:@"%d",curpage];
    NSLog(@"%@",param);

    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {
        
            [self.hudManager dismissSVHud];
            
            NSDictionary *info = dict[@"info"];
            if (0 == self.banner.imgUrl.length) {
                NSArray *arr = dict[@"info"][@"banner"];
                self.banner.imgUrl = arr[0][@"imgUrl"];
                self.banner.actionUrl = arr[1][@"actionUrl"];
            }
            
            if (0 != [info[@"coachs"] count]) {
                if (1 == curpage) {
                    self.coachs = [FindCoachModel mj_objectArrayWithKeyValuesArray:info[@"coachs"]];
                } else {
                    NSArray *temp = info[@"coachs"];
                    for (int i=0; i<temp.count; i++) {
                        
                        FindCoachModel *model = [FindCoachModel mj_objectWithKeyValues:temp[i]];
                        [self.coachs addObject:model];
                    }
                }
            } else {
                if (curpage != 1) {
                    return;
                }
                [self.coachs removeAllObjects];
            }
            [bg_TableView reloadData];
        } else {
            if (curpage == 1) {
                self.coachs = [NSMutableArray array];
                [bg_TableView reloadData];
                
            }
            
            [self.hudManager dismissSVHud];
        }
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];
}

- (void)createNavigationBar {
    [self createRightLocationNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:@"找教练" andRightBtnImageName:nil rightHighlightImageName:nil rightBtnSelector:@selector(rightBtnClick)];
    
    //创建右边的按钮
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.frame = CGRectMake(0,10, 60, 20);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    NSString *currentCitys = kCurrentLocationCity;
    [rightBtn setTitle:currentCitys forState:UIControlStateNormal];

    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _rightBtn =  rightBtn;
    _rightBtn.width = 55;
}

- (void)setUI {
    bg_TableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:bg_TableView];
    [bg_TableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    bg_TableView.delegate = self;
    bg_TableView.dataSource = self;
    bg_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    for (NSString *className in registerCellArr) {
        [bg_TableView registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
    }
    
    bg_TableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        curpage = 1;
        [self loadData];
        [bg_TableView.mj_header endRefreshing];
    }];
    [bg_TableView.mj_header beginRefreshing];
    bg_TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        curpage++;
        [self loadData];
        [bg_TableView.mj_footer endRefreshing ];
    }];
}

- (void)prepareData
{
    filterSelectDic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < 7; i++) {
        if (i==0) {
            //BOOL类型选择
            [filterSelectDic setObject:@(NO) forKey:filterSelectKey(i)];
        } else if(i==1||i==2||i==3||i==4||i==5||i==6) {
            //单选
            [filterSelectDic setObject:i==2?@(1):@(0) forKey:filterSelectKey(i)];
        } else {
            //多选
            [filterSelectDic setObject:[[NSMutableArray alloc] init] forKey:filterSelectKey(i)];
        }
    }
}

#pragma mark - UITableViewDelegate && UITableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (0 == self.coachs.count) {
        return 3;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ((section==1) && !isOpenFilterSection) {
        return 0;
    }
    if (3 == section) {
        return self.coachs.count;
    }
    return [numOfRowsArr[section] longValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (3 == indexPath.section) {
        return 170;
    }
    return [heightForRowArr[indexPath.section][indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    LLPromptCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLPromptCell"];
                    cell.promptLbl.text = @"回答几个问题给您匹配最合适的教练！";
                    return cell;
                }
                    break;
                case 1:
                {
                    LLThreeSelectBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLThreeSelectBtnCell"];
                    cell.filterSelectDic = filterSelectDic;
                    NSArray *btnTitle = @[@"距我最近",@"男教练",@"女教练"];
                    for (int i = 0; i < 3; i++) {
                        LLButton *btn = cell.btnArr[i];
                        [btn setTitle:btnTitle[i] forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                        [btn setTitleColor:[UIColor colorWithHexString:@"0X999999"] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:threeSelectBtnImgArr[i][0]] forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:threeSelectBtnImgArr[i][1]] forState:UIControlStateSelected];
                        [btn setBackgroundImage:[UIImage imageNamed:@"iconfont-teacher-yuan-gray"] forState:UIControlStateNormal];
                        [btn setBackgroundImage:[UIImage imageNamed:@"iconfont-teacher-yuan-blue"] forState:UIControlStateSelected];
                        
                        if (i==0) {
                            btn.selected =  [filterSelectDic[filterSelectKey(0)] boolValue];
                        } else {
                            if ([filterSelectDic[filterSelectKey(1)] intValue]==0) {
                                btn.selected = NO;
                            } else {
                                if ([filterSelectDic[filterSelectKey(1)] intValue]==i) {
                                    btn.selected = YES;
                                } else {
                                    btn.selected = NO;
                                }
                            }
                        }
                    }
                    
                    return cell;
                }
                    break;
                case 2:
                {
                    LLLicenceTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLLicenceTypeCell"];
                    cell.filterSelectDic = filterSelectDic;
                    cell.titleLbl.text = @"您希望考何种准驾车型？";
                    for (int i = 0; i < 2; i++) {
                        [cell.btnArr[i] setTitle:licenceTypeArr[i] forState:UIControlStateNormal];
                        [cell.btnArr[i] setBackgroundImage:[UIImage imageNamed:@"iconfont-teacher-zhengjian2"] forState:UIControlStateNormal];
                        [cell.btnArr[i] setBackgroundImage:[UIImage imageNamed:@"iconfont-teacher-zhengjian"] forState:UIControlStateSelected];
                        if ([filterSelectDic[filterSelectKey(2)] intValue]==0) {
                            ((UIButton *)cell.btnArr[i]).selected = NO;
                        }
                        else
                        {
                            if ([filterSelectDic[filterSelectKey(2)] intValue]-1==i) {
                                ((UIButton *)cell.btnArr[i]).selected = YES;
                            }
                            else
                            {
                                ((UIButton *)cell.btnArr[i]).selected = NO;
                            }
                        }
                    }
                    return cell;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            LLMoreFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLMoreFilterCell"];
            cell.filterSelectDic = filterSelectDic;
            cell.indexPath = indexPath;
            cell.titleLbl.text = filterTitleArr[indexPath.row];
            cell.helpBtn.hidden = [helperBtnArr[indexPath.row] isEqualToString:@""] ? YES : NO;
            [cell.helpBtn setTitle:helperBtnArr[indexPath.row] forState:UIControlStateNormal];
            NSLog(@"=============%d,%@",(int)indexPath.row,filterBtnTitleArr);
            for (int i = 0; i < 5; i++) {
                UIButton *filterBtn = cell.filterBtnArr[i];
                if (((NSArray *)filterBtnTitleArr[indexPath.row]).count<=i) {
                    filterBtn.hidden = YES;
                } else {
                    filterBtn.hidden = NO;
                    [filterBtn setTitle:filterBtnTitleArr[indexPath.row][i] forState:UIControlStateNormal];
                    
                    if ([filterCellTypeArr[indexPath.row] longValue] == LLMoreFilterCellTypeRadio) {
                        
                        
                        //单选情况
                        if ([filterSelectDic[filterSelectKey((int)(3+indexPath.row))] intValue]==0) {
                            filterBtn.selected = NO;
                        } else {
                            if ([filterSelectDic[filterSelectKey((int)(3+indexPath.row))] intValue]-1==i) {
                                filterBtn.selected = YES;
                            } else {
                                filterBtn.selected = NO;
                            }
                        }
                    } else {
                        //多选情况
                        NSMutableArray *mutArr = filterSelectDic[filterSelectKey((int)(3+indexPath.row))];
                        if ([mutArr containsObject:@(i+1)]) {
                            filterBtn.selected = YES;
                        } else {
                            filterBtn.selected = NO;
                        }
                    }
                }
            }
            [cell setContentWithType:(LLMoreFilterCellType)[filterCellTypeArr[indexPath.row] longValue]];
            return cell;
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    OneCenterBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OneCenterBtnCell"];
                    [cell.centerBtn setTitle:@"匹配教练" forState:UIControlStateNormal];
                    [cell.centerBtn removeAllTargets];
                    [cell.centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    return cell;
                }
                    break;
                case 1:
                {
                    LLPackupOrOpenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLPackupOrOpenCell"];
                    cell.delegate = self;
                    self.openBtn = cell.packOrOpenBtn;
                    return cell;
                }
                    break;
                case 2:
                {
                    LLBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLBannerCell"];
                    cell.titleLbl.text = @"推荐";
                    [cell.rightBtn setTitle:@"查看当地全部教练" forState:UIControlStateNormal];
                    [cell.rightBtn addTarget:self action:@selector(showAooCoachs) forControlEvents:UIControlEventTouchUpInside];
                    cell.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:246/255.0 blue:245/255.0 alpha:1];
                    [cell.bannerBtn setImageWithURL:[NSURL URLWithString:self.banner.imgUrl] placeholder:[UIImage imageNamed:@"img-teacher-ad"]];
                    cell.gestureRecognizers = [NSArray array];
                    cell.bannerBtn.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellClick)];
                    [cell.bannerBtn addGestureRecognizer:tap];
                    
                    return cell;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            LLCoachCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLCoachCardCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.model = _coachs[indexPath.row];
            [cell setNeedsLayout];
            [cell layoutIfNeeded];
            cell.headBtn.clipsToBounds = YES;
            cell.headBtn.layer.cornerRadius = cell.headBtn.width/2;
            return cell;
        }
            break;
            
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}

-(void)centerBtnClick:(UIButton *)btn
{
    if (self.openBtn.selected == NO) {
        
        HJLog(@"%@",filterSelectDic);
        self.isDistance = [filterSelectDic[@"filterSelect_0"] boolValue];
        self.male = [filterSelectDic[@"filterSelect_1"] intValue];
        self.certname = filterSelectDic[@"filterSelect_2"];
//        NSArray *arr = filterSelectDic[@"filterSelect_3"];
//        NSString *temp = @"";
//        if (0 != arr.count) {
//            for (NSString *str in arr) {
//                SearchTagsModel *model = self.dataArray[0];
//                ValueModel *valueModel = model.values[str.intValue-1];
//                NSString *idNum = [valueModel.idNum substringWithRange:NSMakeRange(9, valueModel.idNum.length-9)];
//                temp = [NSString stringWithFormat:@"%@,%@",temp,idNum];
//            }
//            temp = [temp substringFromIndex:1];
//        }
//        NSLog(@"%@",temp);
        self.learnTime = filterSelectDic[@"filterSelect_3"];
        if ([filterSelectDic[@"filterSelect_4"] intValue]!=0) {
            self.wanted = filterSelectDic[@"filterSelect_4"];
        } else {
            self.wanted = nil;
        }
        if ([filterSelectDic[@"filterSelect_5"] longValue]==0) {
            self.customized = NO;
        } else {
            if ([filterSelectDic[@"filterSelect_5"] longValue]==1) {
                self.customized = YES;
            } else {
                self.customized = NO;
            }
        }
        if (self.customized == YES) {
            numOfRowsArr = @[@(3),@(filterTitleArr.count),@(3),@(4)];
        } else {
            numOfRowsArr = @[@(3),@(filterTitleArr.count),@(2),@(4)];
        }
        curpage = 1;
        
        [self.hudManager showNormalStateSVHUDWithTitle:nil];

        [self loadData];
        
        return;
    }
    
    self.openBtn.selected = !self.openBtn.selected;
    
    isOpenFilterSection = self.openBtn.selected;
    
    [bg_TableView reloadSection:1 withRowAnimation:UITableViewRowAnimationFade];
    
    HJLog(@"%@",filterSelectDic);
    self.isDistance = [filterSelectDic[@"filterSelect_0"] boolValue];
    self.male = [filterSelectDic[@"filterSelect_1"] intValue];
    self.certname = filterSelectDic[@"filterSelect_2"];
//    NSArray *arr = filterSelectDic[@"filterSelect_3"];
//    NSString *temp = @"";
//    if (0 != arr.count) {
//        for (NSString *str in arr) {
//            SearchTagsModel *model = self.dataArray[0];
//            ValueModel *valueModel = model.values[str.intValue-1];
//            NSString *idNum = [valueModel.idNum substringWithRange:NSMakeRange(9, valueModel.idNum.length-9)];
//            temp = [NSString stringWithFormat:@"%@,%@",temp,idNum];
//        }
//        temp = [temp substringFromIndex:1];
//    }
//    NSLog(@"%@",temp);
    self.learnTime = filterSelectDic[@"filterSelect_3"];;
    if ([filterSelectDic[@"filterSelect_4"] intValue]!=0) {
        self.wanted = filterSelectDic[@"filterSelect_4"];
    } else {
        self.wanted = nil;
    }
    if ([filterSelectDic[@"filterSelect_5"] longValue]==0) {
        self.customized = NO;
    } else {
        if ([filterSelectDic[@"filterSelect_5"] longValue]==1) {
            self.customized = YES;
        } else {
            self.customized = NO;
        }
    }
    if (self.customized == YES) {
        numOfRowsArr = @[@(3),@(filterTitleArr.count),@(3),@(4)];
    } else {
        numOfRowsArr = @[@(3),@(filterTitleArr.count),@(2),@(4)];
    }
    curpage = 1;
    
    [self.hudManager showNormalStateSVHUDWithTitle:nil];

    [self loadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 3) {
        FindCoachModel *model = _coachs[indexPath.row];
        CoachDetailWebController *vc  =[[CoachDetailWebController alloc]init];
        NSString *url = [NSString stringWithFormat:@"%@?app=1&uid=%@",model.weburl,kUid];
        vc.urlString =url;
        vc.titleString = model.coachsName;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)leftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick
{
    CitySelectController  *citySelect = [[CitySelectController alloc]init];
    JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:citySelect];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - LLPackupOrOpenCellDelegate 

- (void)LLPackupOrOpenCell:(LLPackupOrOpenCell *)cell clickBtn:(LLButton *)btn
{

    isOpenFilterSection = btn.selected;
    
    [bg_TableView reloadSection:1 withRowAnimation:UITableViewRowAnimationFade];
    
}

//查看当地全部教练
- (void)showAooCoachs {
    [self prepareData];
    [bg_TableView reloadSection:0 withRowAnimation:UITableViewRowAnimationFade];
    [bg_TableView reloadSection:1 withRowAnimation:UITableViewRowAnimationFade];
    
    curpage = 1;
    
    self.isDistance = YES;
    
    self.male = 0;
    
    self.isRecommended = YES;
    
    self.customized = NO;
    
    self.wanted = nil;
    
    self.certname = @"1";
    
    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    
    [self loadData];
}

- (void)cellClick {
    StudentPersonalController *vc = [[StudentPersonalController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.urlString = [NSString stringWithFormat:@"%@?uid=%@&app=1&cityId=%ld&address=%@,%@",self.interfaceManager.personalUrl,kUid,[HttpParamManager getCurrentCityID],[HttpParamManager getLongitude],[HttpParamManager getLatitude]];;
    vc.titleString = @"私人订制";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
