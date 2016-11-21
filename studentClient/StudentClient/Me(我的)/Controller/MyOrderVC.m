//
//  MyOrderVC.m
//  学员端
//
//  Created by gaobin on 16/7/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MyOrderVC.h"
#import "PersonalCustomizeCell.h"
#import "DrivingSchoolCell.h"
#import "PartnerTrainingCell.h"
#import "MyOrderDetailVC.h"
#import "MyOrderModel.h"
#import "MyOderExtraVC.h"
#import "OrderDetailModel.h"
@interface MyOrderVC ()<UITableViewDelegate,UITableViewDataSource,DrivingSchoolCellDelegate,PersonalCustomizeCellDelegate,PartnerTrainingCellDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray *myOrderDataArray;

@property(nonatomic,assign)int pageId;

@property(nonatomic,assign)NSInteger currentIndex;


@end

@implementation MyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageId = 1;
    self.myOrderDataArray = [NSMutableArray array];
    [self createNavigation];
    [self createUI];
}

- (void)requestData {
    
    NSString * url = self.interfaceManager.myOrderList;
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * timeString = [HttpParamManager getTime];
    paramDict[@"time"] = timeString;
    paramDict[@"pageId"] = @(self.pageId);
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/orderList" time:timeString];
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            self.myOrderDataArray = [MyOrderModel mj_objectArrayWithKeyValuesArray:dict[@"info"][@"orderList"]];
            [_tableView reloadData];
            [_tableView.mj_header endRefreshing];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            [_tableView.mj_header endRefreshing];
        }
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        [_tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData {
    NSString * url = self.interfaceManager.myOrderList;
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * timeString = [HttpParamManager getTime];
    paramDict[@"time"] = timeString;
    paramDict[@"pageId"] = @(self.pageId);
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/orderList" time:timeString];
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            NSArray * dataArr = [MyOrderModel mj_objectArrayWithKeyValuesArray:dict[@"info"][@"orderList"]];
            [self.myOrderDataArray addObjectsFromArray:dataArr];
            [_tableView reloadData];
            [_tableView.mj_footer endRefreshing];
            
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            [_tableView.mj_footer endRefreshing];
        }
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        [_tableView.mj_footer endRefreshing];
    }];
}

- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"PersonalCustomizeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonalCustomizeCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"DrivingSchoolCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DrivingSchoolCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"PartnerTrainingCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PartnerTrainingCell"];

    __weak typeof (self) weakSelf = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageId = 1;
        [weakSelf requestData];
    }];

    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageId ++;
        [weakSelf loadMoreData];
    }];
    
    self.tableView.mj_footer.automaticallyHidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark -- DrivingSchoolCellDelegate
- (void)clickDrivingSchoolCellDeleteBtn:(NSInteger)index {
    NSLog(@"点击了删除订单按钮1");
    self.currentIndex = index;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认删除?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark -- PersonalCustomizeCellDelegate
- (void)clickPersonalCustomizeCellDeleteBtn:(NSInteger)index
{
    NSLog(@"点击了删除订单按钮2");
    self.currentIndex = index;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认删除?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
}

#pragma mark -- PartnerTrainingCellDelegate
- (void)clickPartnerTrainingCellDeleteBtn:(NSInteger)index {
    NSLog(@"点击了删除订单按钮3");
    self.currentIndex = index;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确认删除?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self deleteOderWithData:_currentIndex];
    }
}

- (void)deleteOderWithData:(NSInteger)index {
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在删除..."];

    MyOrderModel * orderModel = _myOrderDataArray[index];
    
    NSString * url = self.interfaceManager.getCancelorder;
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * timeString = [HttpParamManager getTime];
    paramDict[@"time"] = timeString;
    paramDict[@"orderId"] = orderModel.idStr;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/cancelorder" time:timeString];
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            [self.hudManager showSuccessSVHudWithTitle:@"删除成功" hideAfterDelay:1.0 animaton:YES];

            [self.myOrderDataArray removeObjectAtIndex:index];
            [_tableView reloadData];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
        }
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myOrderDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_myOrderDataArray.count <=0) {
        return nil;
    }
    MyOrderModel * orderModel = _myOrderDataArray[indexPath.row];
    if([orderModel.orderstyle isEqualToString:@"3"]){
        static NSString * identifier = @"PersonalCustomizeCell";
        
        PersonalCustomizeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.backgroundColor = BG_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderModel = orderModel;
        cell.delegate = self;
        cell.index = indexPath.row;
        return cell;
    } else if ([orderModel.orderstyle isEqualToString:@"1"]) {
        
        static NSString * identifier = @"DrivingSchoolCell";
        
        DrivingSchoolCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.backgroundColor = BG_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderModel = orderModel;
        cell.delegate = self;
        cell.index = indexPath.row;
        return cell;
        
    } else if([orderModel.orderstyle isEqualToString:@"5"]){
        
        static NSString * identifier = @"PartnerTrainingCell";
        PartnerTrainingCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.backgroundColor = BG_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderModel = orderModel;
        cell.index = indexPath.row;
        cell.delegate = self;
        return cell;
    } else {
        static NSString * identifier = @"DrivingSchoolCell";
        
        DrivingSchoolCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.backgroundColor = BG_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderModel = orderModel;
        cell.delegate = self;
        cell.index = indexPath.row;
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyOrderModel * orderModel = _myOrderDataArray[indexPath.row];

    if ([orderModel.orderstyle isEqualToString:@"5"]) {
        return 210;
    }else{
        return 185;
    }


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyOrderModel * orderModel = _myOrderDataArray[indexPath.row];

    [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
    NSString * url = self.interfaceManager.getOrderdetails;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"orderId"] = orderModel.idStr;
    paramDict[@"uid"] = kUid;
    NSString * timeString = [HttpParamManager getTime];
    paramDict[@"time"] = timeString;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/Orderdetails" time:timeString addExtraStr:orderModel.idStr];
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            [self.hudManager dismissSVHud];
            OrderDetailModel *info = [OrderDetailModel mj_objectWithKeyValues:dict[@"info"][@"orderInfo"]];
            MyOrderDetailVC * vc = [[MyOrderDetailVC alloc] init];
            vc.orderDetailInfo = info;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else {
            
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
        }
        
        
        
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        
    }];
    
    
    
  

}
- (void)createNavigation {
    
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:@"我的订单"];
    
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
