//
//  VoucherViewController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "VoucherViewController.h"
#import "VoucherCell.h"
#import "UIView+Cover.h"
#import "VoucherViewController.h"
#import "VouchPopView.h"
#import "VouchersListModel.h"
#import "VoucherWarningIndicatorHeader.h"
#import "UIScrollView+EmptyDataSet.h"


@interface VoucherViewController ()<UITableViewDelegate,UITableViewDataSource,VoucherCellDelegate,VouchPopViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)VouchPopView *popView;

@property(nonatomic,strong)UIView * coverView;

@property(nonatomic,strong)NSMutableArray * vouchersArray;

@property(nonatomic,assign)int currentPage;


@end

@implementation VoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BG_COLOR;
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:@"代金券"];
    
    self.currentPage = 1;
    
    [self createUI];
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
}

-(void)requestMoreData {
    
    NSString * url = self.interfaceManager.vouchersList;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/coupon/index" time:time];
    paramDict[@"pageId"] = @(self.currentPage);
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"+++%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            
            NSArray * array = dict[@"info"][@"coupons"];
            NSArray *tempArr = [VouchersListModel mj_objectArrayWithKeyValuesArray:array];
            NSEnumerator *enumerator = [tempArr reverseObjectEnumerator];
            NSMutableArray *tempArray = (NSMutableArray*)[enumerator allObjects];
            [_vouchersArray addObjectsFromArray:tempArray];
            
            [_tableView reloadData];
            [_tableView.mj_footer endRefreshing];
            [self.hudManager dismissSVHud];
            
        } else {
            
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            [_tableView.mj_footer endRefreshing];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        [_tableView.mj_footer endRefreshing];
    }];
}

- (void)requestData {
    
    NSString * url = self.interfaceManager.vouchersList;
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/coupon/index" time:time];
    paramDict[@"pageId"] = @(self.currentPage);
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
       
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"+++%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            
            NSArray * array = dict[@"info"][@"coupons"];
            _vouchersArray = [VouchersListModel mj_objectArrayWithKeyValuesArray:array];
            
            NSEnumerator *enumerator = [_vouchersArray reverseObjectEnumerator];
            _vouchersArray = (NSMutableArray*)[enumerator allObjects];
            
            [_tableView reloadData];
            [_tableView.mj_header endRefreshing];
            [self.hudManager dismissSVHud];
            
        } else {
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
    [_tableView registerNib:[UINib nibWithNibName:@"VoucherCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"VoucherCell"];
    [_tableView registerClass:[VoucherWarningIndicatorHeader class] forHeaderFooterViewReuseIdentifier:kVoucherWarningIndicatorHeader];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BG_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

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
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [_tableView.mj_header beginRefreshing];
}

#pragma mark -- tableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return autoScaleH(125);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu",(unsigned long)_vouchersArray.count);
    return _vouchersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"VoucherCell";
    VoucherCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.usedImgView.hidden = YES;
    cell.immediateUseBtn.hidden = NO;
    cell.immediateUseBtn.enabled = YES;
    [cell.immediateUseBtn setTitle:@"立即领取" forState:UIControlStateNormal];
    [cell.immediateUseBtn setTitleColor:[UIColor colorWithHexString:@"#fe5e5b"] forState:UIControlStateNormal];
    [cell.immediateUseBtn.layer setBorderWidth:1];
    [cell.immediateUseBtn.layer setBorderColor:[UIColor colorWithHexString:@"#fe5e5b"].CGColor];
    cell.immediateUseBtn.layer.cornerRadius = 3;
    cell.immediateUseBtn.clipsToBounds = YES;
        
    VouchersListModel * vouchersList = _vouchersArray[indexPath.row];
    cell.valueLab.text = [NSString stringWithFormat:@"%d",vouchersList.money];
    cell.nameLab.text = vouchersList.title;
    NSString * dateString = [Utilities calculateTimeWithDay:[NSString stringWithFormat:@"%d",vouchersList.endTime]];
    cell.dateLab.text = [NSString stringWithFormat:@"有效期至:%@",dateString];
    //判断小于500面值的代金券背景显示蓝骰的
    if (vouchersList.money < 500) {
        
        cell.bgImgView.image = [UIImage imageNamed:@"iconfont-money-youhuibg-blue"];
        cell.introduceLab.text = [NSString stringWithFormat:@"%@%d元代金券",vouchersList.title,vouchersList.money];
    } else {
        
        cell.bgImgView.image = [UIImage imageNamed:@"iconfont-money-youhuibg-red"];
        cell.introduceLab.text = [NSString stringWithFormat:@"%@%d元代金券",vouchersList.title,vouchersList.money];
    }
    cell.nameLabel.text = [NSString stringWithFormat:@"发布者:%@",vouchersList.sendname];
    cell.delegate = self;

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VoucherWarningIndicatorHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kVoucherWarningIndicatorHeader];

    return header;
}



-(void)voucherCellDidClickLingQuBtn:(VoucherCell *)cell {

    if (kLoginStatus) {
        
        __weak typeof(self) weakSelf = self;
        
        //领取代金券
        [self.hudManager showNormalStateSVHUDWithTitle:@"领取中..."];
        
        NSString * url = self.interfaceManager.reveiveVouchers;
        
        NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
        paramDict[@"uid"] = kUid;
        NSString * time = [HttpParamManager getTime];
        paramDict[@"time"] = time;
        
        NSIndexPath * idIndexPath = [_tableView indexPathForCell:cell];
        VouchersListModel * vouchesList = _vouchersArray[idIndexPath.row];
        paramDict[@"couponsId"] = [NSNumber numberWithInt:vouchesList.idNum];
        
        paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/coupon/ReceiveVouchers" time:time couponsId:vouchesList.idNum];
        
        [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            HJLog(@"++++%@",dict);
            NSInteger code = [dict[@"code"] integerValue];
            NSString * msg = dict[@"msg"];
            if (code == 1) {
                self.view.touchCoverHandler = ^(UIView *cover){
                    
                    [weakSelf.coverView removeFromSuperview];
                    
                    [weakSelf.popView removeFromSuperview];
                };
                self.coverView = self.view.translucentCoverView;
                //添加蒙版
                [self.view addSubview:self.coverView];
                //添加
                VouchPopView *popView = [[[NSBundle mainBundle]loadNibNamed:@"VouchPopView" owner:nil options:nil]lastObject];
                self.popView = popView;
                
                NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
                VouchersListModel * vouchersList = _vouchersArray[indexPath.row];
                //复制给View
                self.popView.vouchers = vouchersList;
                self.popView.delegate = self;
                popView.frame = CGRectMake(20*AutoSizeScaleX, 0, kScreenWidth-40*AutoSizeScaleX,  (kScreenWidth-40*AutoSizeScaleX)*1.3);
                popView.center = CGPointMake(self.view.centerX, self.view.centerY-100);
                CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
                k.values = @[@(0.1),@(1.0),@(1.1)];
                k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(0.9),@(1.0)];
                k.calculationMode = kCAAnimationLinear;
                [_popView.layer addAnimation:k forKey:@"SHOW"];
                [self.view addSubview:_popView];
                
                //领取成功后删除点击的那行
                [_vouchersArray removeObjectAtIndex:idIndexPath.row];
                
                
                [self.hudManager dismissSVHud];
            } else {
                [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            }
            
        } failed:^(NSError *error) {
            [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        }];

    } else {
        LoginGuideController *loginVC = [[LoginGuideController alloc]init];
        JTNavigationController *loginnavC = [[JTNavigationController alloc] initWithRootViewController:loginVC];
        loginnavC.fullScreenPopGestureEnabled = YES;
        [self presentViewController:loginnavC animated:YES completion:nil];
    }
}

-(void)vouchPopViewDidClickKnowBtn:(VouchPopView *)popView {
    self.view.touchCoverHandler(self.coverView);
    //领取成功后删除点击的那行
    [_tableView reloadData];
}

- (void)leftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"noCoupon"];
}

#pragma mark -- DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

@end
