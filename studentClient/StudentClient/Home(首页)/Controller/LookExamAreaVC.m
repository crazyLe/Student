//
//  LookExamAreaVC.m
//  学员端
//
//  Created by gaobin on 16/8/8.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LookExamAreaVC.h"
#import "LocationButton.h"
#import "SubjectThreeVideoCell.h"
#import "MoviePlayerViewController.h"
#import "SubjectTwoVideoCell.h"
#import "SubjectDetailController.h"
#import "CitySelectController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface LookExamAreaVC ()<UITableViewDelegate,UITableViewDataSource,SubjectTwoVideoCellDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) LocationButton *rightBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) BOOL isEmptyData;

@end

@implementation LookExamAreaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BG_COLOR;
    
    self.dataArray = [NSMutableArray array];
    
    [self createNavgation];
    
    [self createUI];
    
    //暂时采用科三首页的请求及model,回头改换
    [self loadData];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(loactionChange) name:kLocationChangeNotification object:nil];
}

-(void)loactionChange {
    [self createNavgation];
    
    [self loadData];
}

-(void)loadData {
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
    
    NSString *url = self.interfaceManager.subjectThirdExamplace;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/subjectThird/examplace" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    param[@"cityid"] = @([HttpParamManager getCurrentCityID]);
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {
            NSArray *arr1 = dict[@"info"][@"arricles"];
            self.dataArray = [LookExamModel mj_objectArrayWithKeyValuesArray:arr1];
            self.isEmptyData = self.dataArray.count <= 0;
            [_tableView reloadData];
            [self.hudManager dismissSVHud];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];
}

- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark -- _tableView的代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LookExamModel *model = self.dataArray[indexPath.section];

    return [SubjectTwoVideoCell getCellHeightWithData:model.item.mutableCopy];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"SubjectTwoVideoCell";
    
    SubjectTwoVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[SubjectTwoVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    LookExamModel *model = self.dataArray[indexPath.section];
    [cell configCellUIWithVideoModelArray:model.item.mutableCopy];
    
    cell.videoModelArray = model.item.mutableCopy;
    cell.titleLabel.text = model.type_name;
    cell.delegate = self;
    
    return cell;
}

-(void)subjectTwoVideoCell:(SubjectTwoVideoCell *)cell didClickItemViewWithItemModel:(SubjectVideoModel*)itemModel {
    HJLog(@"%@",itemModel);
    
    SubjectDetailController *vc = [[SubjectDetailController alloc] init];
    
    vc.urlString = itemModel.url;
    
    vc.titleString = itemModel.title;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createNavgation {
    
    NSArray * naviBtn = [self createRightLocationNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:@"看考场" andRightBtnImageName:@"iconfont-jiantou" rightHighlightImageName:nil rightBtnSelector:@selector(rightBtnClick)];
    
    _leftBtn = naviBtn[0];
    _rightBtn = naviBtn[1];

    [self.rightBtn setTitle:kCurrentLocationCity forState:UIControlStateNormal];
}

- (void)leftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick {
    
    CitySelectController  *citySelect = [[CitySelectController alloc]init];
    JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:citySelect];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark -- DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"noVideo"];
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.isEmptyData;
}


@end


@implementation LookExamModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"item":[SubjectVideoModel class]};
}

@end
