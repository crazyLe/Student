//
//  ExtraMoneyVC.m
//  Coach
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLExtraMoneyCell.h"
#import "ExtraMoneyVC.h"
@interface ExtraMoneyVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,assign)int currentPage;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)NSMutableArray * data1Array;


@end

@implementation ExtraMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPage = 1;
    
    self.data1Array = [NSMutableArray array];
    
    self.dataArray = [NSMutableArray array];
    
    [self setNavigation];
    
    [self setUI];
    
    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    
    [self loadData];
}

-(void)loadData
{
    
    NSString * url = self.interfaceManager.mypurseBill;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Mypurse/bill" time:time];
    paramDict[@"pageId"] = @(self.currentPage);
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@">>>%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            
            NSDictionary  *subDict = dict[@"info"];
            
            NSArray *arr = subDict[@"order"];
            
            _data1Array = [BeansRecord mj_objectArrayWithKeyValuesArray:arr];
            
            [self getGroupDataArrayWithArray:_data1Array];
            
            [self.hudManager dismissSVHud];
            
            [self.tableView reloadData];
            
            [_tableView.mj_header endRefreshing];
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
            [_tableView.mj_header endRefreshing];
            
        }
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
        [_tableView.mj_header endRefreshing];
        
        
    }];
    
    
    
    
}
-(void)loadMoreData
{
    
    NSString * url = self.interfaceManager.mypurseBill;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Mypurse/bill" time:time];
    paramDict[@"pageId"] = @(self.currentPage);
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@">>>%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            
            NSDictionary  *subDict = dict[@"info"];
            
            NSArray *arr = subDict[@"order"];
            
            NSArray *arrModel = [BeansRecord mj_objectArrayWithKeyValuesArray:arr];
            
            [_data1Array addObjectsFromArray:arrModel];
            
            [self getGroupDataArrayWithArray:_data1Array];
            
            [self.hudManager dismissSVHud];
            
            [self.tableView reloadData];
            
            [_tableView.mj_footer endRefreshing];
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
            [_tableView.mj_footer endRefreshing];
            
        }
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
        [_tableView.mj_footer endRefreshing];
        
        
    }];
    
    
    
    
}
/**
 *  数据组装方法
 */
-(void)getGroupDataArrayWithArray:(NSArray *)arr
{
    
    //首先把原数组中数据的日期取出来放入timeArr
    NSMutableArray *timeArr=[NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(BeansRecord * obj, NSUInteger idx, BOOL *stop) {
        
        long long time1=obj.time;
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:time1];
        df.dateFormat = @"MM";
        NSString *month1 = [df stringFromDate:date1];
        [timeArr addObject:month1];
        
    }];
    //使用nsset把timeArr的日期去重
    NSSet *set = [NSSet setWithArray:timeArr];
    NSArray *userArray = [set allObjects];
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];//yes升序排列，no,降序排列
    //按日期降序排列的日期数组
    NSArray *myary = [userArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];
    //此时得到的myary就是按照时间降序排列拍好的数组
    _dataArray=[NSMutableArray array];
    //遍历myary把_dataArray按照myary里的时间分成几个组每个组都是空的数组
    [myary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSMutableArray *arr=[NSMutableArray array];
        [_dataArray addObject:arr];
        
    }];
    //遍历arr取其中每个数据的日期看看与myary里的那个日期匹配就把这个数据装到_dataArray 对应的组中
    [arr enumerateObjectsUsingBlock:^(BeansRecord *  obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        long long time1=obj.time;
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:time1];
        df.dateFormat = @"MM";
        NSString *month1 = [df stringFromDate:date1];
        obj.month = month1;
        for (NSString *str in myary)
        {
            if([str isEqualToString:month1])
            {
                NSMutableArray *arr=[_dataArray objectAtIndex:[myary indexOfObject:str]];
                [arr addObject:obj];
            }
        }
        
    }];
    NSMutableArray *subArr = [NSMutableArray array];
    for (int i = 0; i<self.dataArray.count; i++) {
        NSMutableArray *arr = self.dataArray[i];
        BeansRecordGroup *model = [[BeansRecordGroup alloc]init];
        model.records = arr;
        BeansRecord *subModel = arr[0];
        model.month = subModel.month;
        [subArr addObject:model];
    }
    [self.dataArray removeAllObjects];
    
    self.dataArray = subArr;
    
    
}

#pragma mark - Setup

- (void)setNavigation
{
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftClick) andCenterTitle:@"流通记录"];
}
-(void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setUI
{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BG_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[LLExtraMoneyCell class] forCellReuseIdentifier:@"LLExtraMoneyCell"];
    _tableView.sectionHeaderHeight = 37.0f;
    _tableView.backgroundColor = BG_COLOR;
    [_tableView setSeparatorColor:[UIColor colorWithHexString:@"f0f0f0"]];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        
        [weakSelf loadData];
        
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage ++;
        
        [weakSelf loadMoreData];
        
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((BeansRecordGroup *)self.dataArray[section]).records.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 37.0f)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(18*kWidthScale, 0, kScreenWidth-18*kWidthScale, 37.0f)];
    [bgView addSubview:titleLbl];
    
    BeansRecordGroup *model=self.dataArray[section];
    NSInteger mon = [GHDateTools month:[NSDate date]];
    if ( mon == model.month.integerValue) {
        titleLbl.text = @"本月";
    }
    else
    {
        titleLbl.text = model.month;
    }
    titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
    titleLbl.font = kFont18;
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLExtraMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLExtraMoneyCell"];
    BeansRecordGroup *groupModel = self.dataArray[indexPath.section];
    BeansRecord *model = groupModel.records[indexPath.row];
    NSArray *arr = [model.timeStr componentsSeparatedByString:@" "];
    if (arr.count >= 2) {
        cell.dateLbl.text = arr[0];
        cell.timeLbl.text = arr[1];
    }
    cell.headBtn.clipsToBounds = YES;
    cell.headBtn.layer.cornerRadius = cell.headBtn.width/2;
    [cell.headBtn sd_setImageWithURL:[NSURL URLWithString:self.currentUserInfo.face] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像"]];
    cell.beansNumLbl.text = [NSString stringWithFormat:@"%@赚豆",model.beans];
    cell.classLbl.text = model.className;
    return cell;
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end


@implementation BeansRecord



@end

@implementation BeansRecordGroup

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"records":[BeansRecord class]};
}


@end
