//
//  StagingBillVC.m
//  学员端
//
//  Created by gaobin on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "StagingBillVC.h"
#import "RepaymentRecordCell.h"
#import "CurrentRepaymentCell.h"
#import "Utilities.h"
#import "StagingBillModel.h"
#import "STRecordModel.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "PaySuccessController.h"
#import "PayFailController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface StagingBillVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CurrentRepaymentCellDelegate>

@property (nonatomic, strong) UISegmentedControl * segment;
@property (nonatomic, strong) UIScrollView * bgScrollView;
@property (nonatomic, strong) UITableView * currentTableView;
@property (nonatomic, strong) UITableView * recordTableView;
@property (nonatomic, strong)StagingBillModel * stagingModel;

@property (nonatomic, strong) NSMutableArray * recordArray;

@property(nonatomic,assign)int pageId;

//灰色背景
@property (nonatomic, strong) UIButton *grayBackBtn;

@property(nonatomic,strong)NSString *currentZhuanDouNum;

@property(nonatomic,assign)long  long orderId;

@property(nonatomic,assign)CGFloat  currentPayMoney;

@end

@implementation StagingBillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_COLOR;
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:nil andRightBtnImageName:@"iconfont-money-txing" rightHighlightImageName:nil rightBtnSelector:@selector(rightBtnClick)];
    self.pageId = 1;
    [self createUI];
    [self createSegment];
    _recordArray = [NSMutableArray array];
    [self initWithCurrentData];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(weiXinPayFail) name:kWeiXinPayFailNotification object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(weiXinPaySuccess) name:kWeiXinPaySuccessNotification object:nil];
}
-(void)dealloc
{
    [NOTIFICATION_CENTER removeObserver:self];
}
-(void)weiXinPayFail
{
    PayFailController *PayFail = [[PayFailController alloc]init];
    [self.navigationController pushViewController:PayFail animated:YES];
}
-(void)weiXinPaySuccess
{
    //支付结果回写
    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    NSString * url = self.interfaceManager.payResultUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"orderId"] = @(self.orderId);
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/payResult" time:time addExtraStr:[NSString stringWithFormat:@"%lld",self.orderId]];
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    paramDict[@"totalMoney"] = self.stagingModel.totalMoney;
    paramDict[@"result"] = @"success";
    
    paramDict[@"payType"] = @(3);
    paramDict[@"beansConsumption"] = _currentZhuanDouNum;
    paramDict[@"orderType"] = self.stagingModel.orderType;
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@">>>%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        
        if (code == 1) {
            
            
            NSDictionary *resultDict = dict[@"info"];
            
            [self.hudManager showSuccessSVHudWithTitle:msg hideAfterDelay:1.0 animaton:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                PaySuccessController *paySuccess = [[PaySuccessController alloc]init];
                paySuccess.resultDict = resultDict;
                if ([self.stagingModel.orderType isEqualToString:@"3"]) {
                    paySuccess.type = @"1";
                }
                else
                {
                    paySuccess.type = @"2";
                }
                paySuccess.orderId =self.orderId;
                [self.navigationController pushViewController:paySuccess animated:YES];
            });
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
    }];
}


#pragma mark -- 创建segment
- (void)createSegment {
    
    NSArray * segmentArray = @[@"当前还款",@"还款记录"];
    _segment = [[UISegmentedControl alloc] initWithItems:segmentArray];
    _segment.selectedSegmentIndex = 0;
    //设置segment的选中背景颜色
    _segment.tintColor = [UIColor whiteColor];
    _segment.frame = CGRectMake(100, 0, kScreenWidth - 200, 30);
    [_segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segment;
    
    
}



#pragma mark -- segment绑定的方法
- (void)segmentValueChanged:(UISegmentedControl *)segment {
    
    NSInteger index = segment.selectedSegmentIndex;
    
    if (index == 0) {
        
        [_bgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }else {
        
        [_bgScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
        
        //还款记录数据请求
        [self initWithRecordData];
    }
    
}



#pragma mark -- scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _bgScrollView) {
        
        if (scrollView.contentOffset.x == kScreenWidth) {
            
            _segment.selectedSegmentIndex = 1;
            
        }if (scrollView.contentOffset.x == 0) {
            
            _segment.selectedSegmentIndex = 0;
        }
        
    }
    
    
    
    
}
- (void)createUI {
    
    //创建scrollView作为两张表的载体
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight)];
    _bgScrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - kNavHeight);
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.alwaysBounceVertical = NO;
    _bgScrollView.delegate = self;
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];
    
    //当月还款
    _currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStylePlain];
    _currentTableView.contentSize = CGSizeMake(kScreenWidth, 1000);
    _currentTableView.delegate = self;
    _currentTableView.dataSource = self;
    _currentTableView.backgroundColor = BG_COLOR;
    _currentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_bgScrollView addSubview:_currentTableView];
    [_currentTableView registerNib:[UINib nibWithNibName:@"CurrentRepaymentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CurrentRepaymentCell"];
    
    //还款记录
    _recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    _recordTableView.delegate = self;
    _recordTableView.dataSource = self;
    _recordTableView.backgroundColor = BG_COLOR;
    _recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_bgScrollView addSubview:_recordTableView];
    [_recordTableView registerNib:[UINib nibWithNibName:@"RepaymentRecordCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RepaymentRecordCell"];
    
    
    __weak typeof (self) weakSelf = self;
    
    _recordTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.pageId = 1;
        
        [weakSelf initWithRecordData];
        
    }];
    
    
    _recordTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageId ++;
        
        [weakSelf loadMoreRecordData];
        
    }];
    
    self.recordTableView.mj_footer.automaticallyHidden = YES;
    
    [self.recordTableView.mj_header beginRefreshing];
    
}

//当前还款
- (void)initWithCurrentData
{
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
    NSString *url = self.interfaceManager.getOrderinfo;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/reimbursement" time:time addExtraStr:_installmentBIllidStr];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    param[@"installmentBIllid"] = _installmentBIllidStr;
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1)
        {
            self.stagingModel = [StagingBillModel mj_objectWithKeyValues:dict[@"info"][@"detail"]] ;
            CGFloat _curroffsetMoneyStr = self.stagingModel.installmentMoney.floatValue-(self.stagingModel.remainingBeans.floatValue)*[_stagingModel.proportion floatValue];
            _currentPayMoney = _curroffsetMoneyStr;
            _currentZhuanDouNum = self.stagingModel.remainingBeans;
            [self.currentTableView reloadData];
            [self.hudManager dismissSVHud];
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
        }
    
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
    }];
}

//分期还款记录
- (void)initWithRecordData
{
    NSString *url = self.interfaceManager.getRepayment;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/repayment" time:time];
    param[@"pageId"] = @(self.pageId);
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1)
        {
            self.recordArray = [STRecordModel mj_objectArrayWithKeyValuesArray:dict[@"info"][@"detail"]] ;
            
            [self.recordTableView reloadData];
            [self.hudManager dismissSVHud];
            [_recordTableView.mj_header endRefreshing];
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            [_recordTableView.mj_header endRefreshing];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        [_recordTableView.mj_header endRefreshing];
    }];
}

//分期还款记录跟多数据
- (void)loadMoreRecordData
{
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
    NSString *url = self.interfaceManager.getRepayment;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/repayment" time:time];
    param[@"pageId"] = @(self.pageId);
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1)
        {
            NSArray * dataArr= [STRecordModel mj_objectArrayWithKeyValuesArray:dict[@"info"][@"detail"]] ;
            [self.recordArray addObjectsFromArray:dataArr];
            
            [self.recordTableView reloadData];
            [self.hudManager dismissSVHud];
            [_recordTableView.mj_footer endRefreshing];
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            [_recordTableView.mj_footer endRefreshing];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        [_recordTableView.mj_footer endRefreshing];
    }];
}

#pragma mark --CurrentRepaymentCellDelegate 
- (void)pressCurrentCellrepaymentBtn
{
    
    if (_currentPayMoney<=0) {
        [self.hudManager showErrorSVHudWithTitle:@"支付金额不能小于零" hideAfterDelay:1.0];
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;//支付蒙版
    UIButton *grayBackBtn = [[UIButton alloc] init];
    grayBackBtn.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    grayBackBtn.backgroundColor = [UIColor colorWithRed:25/255.0 green: 25/255.0 blue:25/255.0 alpha:0.5];
    [window addSubview:grayBackBtn];
    [grayBackBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.grayBackBtn = grayBackBtn;
    
    UIImageView *  backView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-285)/2, (kScreenHeight-165)/2, 285, 165)];
    backView.layer.cornerRadius = 5.0;
    backView.backgroundColor = [UIColor whiteColor];
    backView.userInteractionEnabled = YES;
    [grayBackBtn addSubview:backView];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(backView.frame)-150)/2, (43-22)/2, 150, 22)];
    titleLabel.text = @"请选择支付方式";
    titleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    titleLabel.font = Font15;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    
    UILabel * hLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 43,CGRectGetWidth(backView.frame), 0.5)];
    hLine.backgroundColor = rgb(218, 218, 218);
    [backView addSubview:hLine];
    
    UILabel * vLine = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(backView.frame)/2, 43.5, 0.5,CGRectGetHeight(backView.frame)-43.5)];
    vLine.backgroundColor = rgb(218, 218, 218);
    [backView addSubview:vLine];
    
    UIButton * weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame = CGRectMake((CGRectGetWidth(backView.frame)/2-90)/2, 43+(CGRectGetHeight(backView.frame)-43-90)/2, 90, 90);
    weixinBtn.tag = 1000;
    [weixinBtn addTarget:self action:@selector(pressPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [weixinBtn setImage:[UIImage imageNamed:@"iconfont-weixinzhifu"] forState:UIControlStateNormal];
    [backView addSubview:weixinBtn];
    
    UIButton * alipayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    alipayBtn.frame = CGRectMake((CGRectGetWidth(backView.frame)/2-90)/2+CGRectGetWidth(backView.frame)/2, (CGRectGetHeight(backView.frame)-43-90)/2+43, 90, 90);
    alipayBtn.tag = 2000;
    [alipayBtn addTarget:self action:@selector(pressPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [alipayBtn setImage:[UIImage imageNamed:@"iconfont-zhifubao"] forState:UIControlStateNormal];
    [backView addSubview:alipayBtn];
    
}
- (void)cancelBtnClick
{
    [self.grayBackBtn removeFromSuperview];
}
- (void)pressPayBtn:(UIButton *)sender
{
    NSInteger payType = 0;
    switch (sender.tag) {
        case 1000:
        {
           NSLog(@"点击了微信");
            payType = 3;
            
            //向服务器验证支付金额
            [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
            NSString *url = self.interfaceManager.fenqiSubmitOrder;
            NSString *time = [HttpParamManager getTime];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"Billid"] = _installmentBIllidStr;
            param[@"uid"] = kUid;
            param[@"time"] = time;
            param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/FenqiSubmitOrder" time:time];
            param[@"Paytype"] = @(payType);
            param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
            param[@"Beans"] = _currentZhuanDouNum;

            [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                HJLog(@"%@",dict);
                NSInteger code = [dict[@"code"] integerValue];
                NSString *msg = dict[@"msg"];
                if (code == 1)
                {
                    NSLog(@"实付：%@",dict[@"info"]);
                    [self.grayBackBtn removeFromSuperview];
                    [self.hudManager dismissSVHud];
                    
                    NSDictionary * infoDict = [dict objectForKey:@"info"];
                    self.orderId = [infoDict[@"orderId"] longLongValue];
                    NSString *jsonStringDec = infoDict[@"content"];
                    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:jsonStringDec options:0];
                    NSString *jsonString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
                    
                    NSDictionary *subDict = jsonString.mj_JSONObject;
                    
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [subDict objectForKey:@"partnerId"];
                    req.prepayId            = [subDict objectForKey:@"prepayId"];
                    req.nonceStr            = [subDict objectForKey:@"nonceStr"];
                    req.timeStamp           = [[subDict objectForKey:@"timeStamp"] intValue];
                    req.package             = [subDict objectForKey:@"packageValue"];
                    req.sign                = [subDict objectForKey:@"sign"];
                    [WXApi sendReq:req];
                    //日志输出
                    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appId"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                    
                }
                else
                {
                    [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
                }
                
            } failed:^(NSError *error) {
                [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
            }];
            
            
        }
            break;
        case 2000:
        {
            NSLog(@"点击了支付宝");
            payType = 1;
            
            //向服务器验证支付金额
            [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
            NSString *url = self.interfaceManager.fenqiSubmitOrder;
            NSString *time = [HttpParamManager getTime];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            param[@"Billid"] = _installmentBIllidStr;
            param[@"uid"] = kUid;
            param[@"time"] = time;
            param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/FenqiSubmitOrder" time:time];
            param[@"Paytype"] = @(payType);
            param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
            param[@"Beans"] = _currentZhuanDouNum;
            
            [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                HJLog(@"%@",dict);
                NSInteger code = [dict[@"code"] integerValue];
                NSString *msg = dict[@"msg"];
                if (code == 1)
                {
                    NSLog(@"实付：%@",dict[@"info"]);
                    [self.grayBackBtn removeFromSuperview];
                    [self.hudManager dismissSVHud];
                    
                    NSDictionary * infoDict = [dict objectForKey:@"info"];
                    
                    NSString *jsonString = infoDict[@"content"];
                    
                    self.orderId = [infoDict[@"orderId"] longLongValue];
                    
                    [[AlipaySDK defaultService] payOrder:jsonString fromScheme:@"alipaySDK" callback:^(NSDictionary *resultDic) {
                        
                        NSLog(@"开始确认支付状态 %@",resultDic[@"resultStatus"]);
                        if ([resultDic[@"resultStatus"]isEqualToString:@"9000"])//成功
                        {
                            //支付结果回写
                            [self.hudManager showNormalStateSVHUDWithTitle:nil];
                            NSString * url = self.interfaceManager.payResultUrl;
                            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
                            paramDict[@"orderId"] = @(self.orderId);
                            paramDict[@"uid"] = kUid;
                            NSString * time = [HttpParamManager getTime];
                            paramDict[@"time"] = time;
                            paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/payResult" time:time addExtraStr:[NSString stringWithFormat:@"%lld",self.orderId]];
                            paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
                            paramDict[@"totalMoney"] = self.stagingModel.totalMoney;
                            paramDict[@"result"] = @"success";
                            paramDict[@"payType"] = @(payType);
                            paramDict[@"beansConsumption"] = _currentZhuanDouNum;
                            paramDict[@"orderType"] = self.stagingModel.orderType;
                            
                            [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
                                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                HJLog(@">>>%@",dict);
                                NSInteger code = [dict[@"code"] integerValue];
                                NSString * msg = dict[@"msg"];
                                
                                if (code == 1) {
                                    
                                    
                                    NSDictionary *resultDict = dict[@"info"];
                                    
                                    [self.hudManager showSuccessSVHudWithTitle:msg hideAfterDelay:1.0 animaton:YES];
                                    
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        PaySuccessController *paySuccess = [[PaySuccessController alloc]init];
                                        paySuccess.resultDict = resultDict;
                                        if ([self.stagingModel.orderType isEqualToString:@"3"])
                                        {
                                            paySuccess.type = @"1";
                                        }
                                        else
                                        {
                                            paySuccess.type = @"2";
                                        }
                                        paySuccess.orderId =self.orderId;
                                        [self.navigationController pushViewController:paySuccess animated:YES];
                                    });
                                    
                                }
                                else
                                {
                                    [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
                                }
                                
                            } failed:^(NSError *error) {
                                [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
                            }];
                            
                        }
                        else
                        {
                            
                            NSLog(@"用户主动取消支付");
                            //支付结果回写
                            //                            [self.hudManager showNormalStateSVHUDWithTitle:nil];
                            //                            NSString * url = self.interfaceManager.payResultUrl;
                            //                            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
                            //                            paramDict[@"orderId"] = @(self.orderid);
                            //                            paramDict[@"uid"] = kUid;
                            //                            NSString * time = [HttpParamManager getTime];
                            //                            paramDict[@"time"] = time;
                            //                            paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/payResult" time:time];
                            //                            paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
                            //                            paramDict[@"totalMoney"] = self.orderInfoModel.totalMoney;
                            //                            paramDict[@"result"] = @"fiald";
                            //                            paramDict[@"payType"] = @(payType);
                            //                            paramDict[@"beansConsumption"] = _currentZhuanDouNum;
                            //                            paramDict[@"orderType"] = @(self.orderType);
                            //
                            //                            [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
                            //                                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                            //                                HJLog(@">>>%@",dict);
                            //                                NSInteger code = [dict[@"code"] integerValue];
                            //                                NSString * msg = dict[@"msg"];
                            
                            //                                if (code == 1) {
                            
                            //                                    NSDictionary *resultDict = dict[@"info"];
                            PayFailController *PayFail = [[PayFailController alloc]init];
                            [self.navigationController pushViewController:PayFail animated:YES];
                            //                                }
                            //                                else
                            //                                {
                            //                                    [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
                            //                                }
                            
                            //                            } failed:^(NSError *error) {
                            //                                [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
                            //                            }];
                        }
                        
                    }];

                    
                }
                else
                {
                    [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
                }
                
            } failed:^(NSError *error) {
                [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
            }];
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    

    
    
}






#pragma mark -- tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == _currentTableView) {
        
        return 1;
    }else {
        
        return _recordArray.count;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _currentTableView) {
        
        return 1;
    }else {
        
        return 1;
    }

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _currentTableView) {
        
        return 670;
    }else {
        
        return 135;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _currentTableView) {
        //当前还款
        static NSString * identifer = @"CurrentRepaymentCell";
        CurrentRepaymentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
        cell.backgroundColor = BG_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.studyExpensesLab1.text = [NSString stringWithFormat:@"¥%@",_stagingModel.totalMoney];
        cell.totalInterestLab1.text = [NSString stringWithFormat:@"¥%@",_stagingModel.interest];
        cell.monthSupplyLab1.text = [NSString stringWithFormat:@"¥%@",_stagingModel.installmentMoney];
        cell.timeLimitLab1.text = [NSString stringWithFormat:@"%@个月",_stagingModel.installmentCount];
        cell.alreadyRepayLab1.text = [NSString stringWithFormat:@"%@个月",_stagingModel.completeCount];
        cell.repayDayLab1.text = self.stagingModel.reimbursement;
        NSMutableAttributedString * attStr = nil;
        attStr = [[NSMutableAttributedString alloc]initWithString:@"本月应还" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        NSString * att = _stagingModel.thisMonthMoney == nil ? @"": _stagingModel.thisMonthMoney;
        [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:att attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#5eb4fa"],NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}]];
        [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"元" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:14]}]];
        cell.currentMonthShouldLab.attributedText = attStr;

        cell.delegate = self;
        cell.billModel = _stagingModel;
        [cell.numberBeanTextView setCustomDoneTarget:self action:@selector(done:)];
        
        
        cell.numberBeanTextView.attributedText = [cell getAttrStringWithZhuanDouNum:_currentZhuanDouNum];
        
        CGFloat _curroffsetMoneyStr = [_currentZhuanDouNum integerValue] * [_stagingModel.proportion floatValue];
        
        cell.offsetMoneyLab.text = [NSString stringWithFormat:@"抵%.2f元",_curroffsetMoneyStr];
        cell.actrulRepayLab.text = [NSString stringWithFormat:@"(应还%.2f) - (赚豆%.2f) = 实付%.2f元",self.stagingModel.installmentMoney.floatValue,[_currentZhuanDouNum floatValue],self.stagingModel.installmentMoney.floatValue-_curroffsetMoneyStr];
      
        
        NSMutableAttributedString * payStr = nil;
        payStr = [[NSMutableAttributedString alloc]initWithString:@"支付" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%.2f",_currentPayMoney] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#bbe0ff"],NSFontAttributeName:[UIFont systemFontOfSize:16]}]];
        [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"元" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}]];
        [cell.repaymentBtn setAttributedTitle:payStr forState:UIControlStateNormal];
        
        return cell;
        
    }else {
        
        static NSString * identifier = @"RepaymentRecordCell";
        //还款记录
        RepaymentRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_recordArray.count>0) {
            cell.model = _recordArray[indexPath.section];
        }
        return cell;
        
    }
    
    

    
}
-(void)done:(UITextView *)textView
{

    _currentZhuanDouNum = textView.text;
    
    if (textView.text.longValue > self.stagingModel.remainingBeans.longValue) {
        [self.hudManager showErrorSVHudWithTitle:@"赚豆不足" hideAfterDelay:1.0];
        return;
    }
    //更改应支付金额
    CGFloat money = 0.0;
    
    money =  self.stagingModel.installmentMoney.floatValue -_currentZhuanDouNum.floatValue*self.stagingModel.proportion.floatValue;
    
    _currentPayMoney = money;
    
    if (money<=0) {
        [self.hudManager showErrorSVHudWithTitle:@"应付金额不能小于零" hideAfterDelay:1.0];
    }
    
    [_currentTableView reloadData];

    
    
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView == _recordTableView) {
        
        return CGFLOAT_MIN;
    }else {
        return 0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (tableView == _recordTableView) {
        
        return 10;
    }else {
        
        return 0;
    }
    
}
- (void)rightBtnClick {
    
    
    
    
}
- (void)leftBtnClick {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.grayBackBtn removeFromSuperview];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
