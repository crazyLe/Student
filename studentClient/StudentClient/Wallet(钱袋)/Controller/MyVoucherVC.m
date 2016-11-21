//
//  MyVoucherVC.m
//  学员端
//
//  Created by gaobin on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIScrollView+EmptyDataSet.h>
#import "MyVoucherVC.h"
#import "MyVoucherCell.h"
#import "MyVoucherModel.h"
#import "VoucherWarningIndicatorHeader.h"

@interface MyVoucherVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) BOOL isHaveUsed;
@property (nonatomic, strong) NSMutableArray * voucherArray;

@property (nonatomic, strong) NSMutableArray * noUsedArray;
@property (nonatomic, strong) NSMutableArray * yesUsedArray;
@property(nonatomic,assign)int currentPage;

@end

@implementation MyVoucherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPage = 1;
    
    _isHaveUsed = NO;
    _noUsedArray = [NSMutableArray array];
    _yesUsedArray = [NSMutableArray array];
    
    self.view.backgroundColor = BG_COLOR;
    
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:nil];
    
    [self createSegment];
    
    [self createUI];
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
    
    
}
-(void)requestMoreData
{
    
    NSString * url = self.interfaceManager.myVoucher;
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/coupon/Mycoupon" time:time];
    if (_isHaveUsed) {
        
        paramDict[@"state"] = @(1);
    }else {
        
        paramDict[@"state"] = @(0);
    }
    paramDict[@"pageId"] = @(self.currentPage);
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"+++%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            
            [_noUsedArray removeAllObjects];
            [_yesUsedArray removeAllObjects];
            
            NSArray * array = dict[@"info"][@"coupons"];
            NSArray * temparray = [MyVoucherModel mj_objectArrayWithKeyValuesArray:array];//字典转模型
            [_voucherArray addObjectsFromArray:temparray];
            for (MyVoucherModel * myVouchers in _voucherArray) {
                
                if (myVouchers.state == 0) {
                    
                    [_noUsedArray addObject:myVouchers];//未使用
                }else {
                    
                    [_yesUsedArray addObject:myVouchers];//使用
                }
                
            }
            
            
            [_tableView reloadData];
            [_tableView.mj_footer endRefreshing];
            [self.hudManager dismissSVHud];
            
        }else {
            
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            [_tableView.mj_footer endRefreshing];
            
            
        }
        
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        [_tableView.mj_footer endRefreshing];
        
        
    }];
    
    


}
- (void)requestData {
    
    
    NSString * url = self.interfaceManager.myVoucher;
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/coupon/Mycoupon" time:time];
    if (_isHaveUsed) {
        
        paramDict[@"state"] = @(1);
    }else {
        
        paramDict[@"state"] = @(0);
    }
    paramDict[@"pageId"] = @(self.currentPage);

    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"+++%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            
            [_noUsedArray removeAllObjects];
            [_yesUsedArray removeAllObjects];
            
            NSArray * array = dict[@"info"][@"coupons"];
            _voucherArray = [MyVoucherModel mj_objectArrayWithKeyValuesArray:array];
            for (MyVoucherModel * myVouchers in _voucherArray) {
                
                if (myVouchers.state == 0) {
                    
                    [_noUsedArray addObject:myVouchers];
                }else {
                    
                    [_yesUsedArray addObject:myVouchers];
                }
                
            }
            
            
            [_tableView reloadData];
            [_tableView.mj_header endRefreshing];
            [self.hudManager dismissSVHud];
            
        }else {
            
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            [_tableView.mj_header endRefreshing];

            
        }
        
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        [_tableView.mj_header endRefreshing];

        
    }];
    
    
    
}
- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:@"MyVoucherCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyVoucherCell"];
    [_tableView registerClass:[VoucherWarningIndicatorHeader class] forHeaderFooterViewReuseIdentifier:kVoucherWarningIndicatorHeader];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BG_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;

    __weak typeof(self) weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        
        [weakSelf requestData];
        
    }];
    
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage ++;
        
        [weakSelf requestMoreData];
        
    }];
    
    self.tableView.mj_footer.automaticallyHidden = YES;
    
    [_tableView.mj_header beginRefreshing];
    
    
}
#pragma mark -- tableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return autoScaleH(125) ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_isHaveUsed) {
        return 0;
    } else {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_isHaveUsed == NO) {
        
        return _noUsedArray.count;
        
    } else {
        
        return _yesUsedArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"MyVoucherCell";
    MyVoucherCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
   
    
    if (_isHaveUsed == NO) {
     
        cell.usedImgView.hidden = YES;
        cell.immediateUseBtn.hidden = NO;
        cell.immediateUseBtn.enabled = YES;
        [cell.immediateUseBtn.layer setBorderWidth:1];
        [cell.immediateUseBtn.layer setBorderColor:[UIColor colorWithHexString:@"#e6e6e6"].CGColor];
        cell.immediateUseBtn.layer.cornerRadius = 3;
        cell.immediateUseBtn.clipsToBounds = YES;
    
        MyVoucherModel * myVoucher = _noUsedArray[indexPath.row];
        cell.valueLab.text = [NSString stringWithFormat:@"%d",myVoucher.money];
        cell.nameLab.text = myVoucher.title;
        cell.introduceLab.text = [NSString stringWithFormat:@"%@%d元代金券",myVoucher.title,myVoucher.money];
        NSString * dateString = [Utilities calculateTimeWithDay:[NSString stringWithFormat:@"%lld",myVoucher.end_time]];
        cell.dateLab.text = [NSString stringWithFormat:@"有效期至:%@",dateString];
        if (myVoucher.money < 500) {
            
            cell.bgImgView.image = [UIImage imageNamed:@"iconfont-money-youhuibg-blue"];
        } else {
            
            cell.bgImgView.image = [UIImage imageNamed:@"iconfont-money-youhuibg-red"];
        }
        
        //后来添加的
        cell.immediateUseBtn.hidden = YES;
        cell.nameLabel.text = [NSString stringWithFormat:@"发布者:%@",myVoucher.sendname];


    } else {
     
        cell.usedImgView.hidden = NO;
        cell.immediateUseBtn.hidden = YES;
        cell.immediateUseBtn.enabled = NO;
        cell.usedImgView.image = [UIImage imageNamed:@"已使用"];
        
        MyVoucherModel * myVoucher = _yesUsedArray[indexPath.row];
        cell.valueLab.text = [NSString stringWithFormat:@"%d",myVoucher.money];
        cell.nameLab.text = myVoucher.title;
        cell.introduceLab.text = [NSString stringWithFormat:@"%@%d元代金券",myVoucher.title,myVoucher.money];
        NSString * dateString = [Utilities calculateTimeWithDay:[NSString stringWithFormat:@"%lld",myVoucher.end_time]];
        cell.dateLab.text = [NSString stringWithFormat:@"有效期至:%@",dateString];
        if (myVoucher.money < 500) {
            
            cell.bgImgView.image = [UIImage imageNamed:@"iconfont-money-youhuibg-blue"];
        } else {
            
            cell.bgImgView.image = [UIImage imageNamed:@"iconfont-money-youhuibg-red"];
        }
        
        //后来添加的
        cell.immediateUseBtn.hidden = YES;
        cell.nameLabel.text = [NSString stringWithFormat:@"发布者:%@",myVoucher.sendname];

    }

    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView numberOfRowsInSection:section]==0) {
        //无数据
        return [UIView new];
    }
    VoucherWarningIndicatorHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kVoucherWarningIndicatorHeader];

    return header;
}

#pragma mark - DZNEmptyDataSetSource
    
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"noCoupon"];
}

- (void)createSegment {
    
    NSArray * segmentArray = @[@"未使用",@"已使用"];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:segmentArray];
    _segmentControl.selectedSegmentIndex = 0;
    //设置segment的选中背景颜色
    _segmentControl.tintColor = [UIColor whiteColor];
    _segmentControl.frame = CGRectMake(100, 0, kScreenWidth -200, 30);
    [_segmentControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentControl;
    
}
- (void)segmentValueChanged:(UISegmentedControl *)segment {
    
    NSInteger index = segment.selectedSegmentIndex;
    if (index == 0) {
        
        _isHaveUsed = NO;
        
        [self requestData];

        
    }else {
        
        _isHaveUsed = YES;
        
        [self requestData];

    }
    
    
    
    
}
- (void)leftBtnClick {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
