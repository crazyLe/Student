//
//  MyOderExtraVC.m
//  学员端
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "NSMutableAttributedString+LLExtension.h"
#import "MyOderExtraVC.h"
#import "SchoolAndAddressCell.h"
#import "ClassTypeCell.h"
#import "DiscountCell.h"
#import "RepayTypeCell.h"
#import "PartnerTrainSubmitCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "PartnerTrainWaitCell.h"
#import "PartnerTrainFailCell.h"
#import "OrderEarnBeanCell.h"
#import "RepaySuccessCell.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "MyOderExtraBottomCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ZHPickView.h"
#import "StagesApplyResultController.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "PaySuccessController.h"
#import "PayFailController.h"
#import "KZWebController.h"

@interface MyOderExtraVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,MyOderExtraBottomCellDelegete,ZHPickViewDelegate>

@property (nonatomic, strong) UIScrollView * bgScrollView;
@property (nonatomic, strong) UITableView * orderTableView;
@property (nonatomic, strong) UIImageView * topImageView;
@property (nonatomic, strong) UIButton * paymentBtn;
@property(nonatomic,strong)NSString * currentDaiJingQuanStr;
@property(nonatomic,strong)CashCouponInfo * currentCouponInfoModel;
@property(nonatomic,strong)NSString *currentZhuanDouNum;
//@property(nonatomic,strong)UITextView * textView;
@property(nonatomic,strong)UITextField * textView;
@property(nonatomic,assign)NSInteger zhifuType;//支付类型，微信，支付宝
@property(nonatomic,strong)UIButton * grayBackBtn;

@property(nonatomic,strong)ZHPickView * pickView;

@property(nonatomic,assign)long orderid;


@end

@implementation MyOderExtraVC

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_pickView remove];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.zhifuType = 1;//支付类型
    
    _currentZhuanDouNum = @"0";//赚豆数目0
    
    [self createNavigation];
    
    [self createUI];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(textViewChange:) name:UITextViewTextDidChangeNotification object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(weiXinPayFail) name:kWeiXinPayFailNotification object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(weiXinPaySuccess) name:kWeiXinPaySuccessNotification object:nil];
}

-(void)dealloc {
    [NOTIFICATION_CENTER removeObserver:self];
}

-(void)weiXinPayFail {
    PayFailController *PayFail = [[PayFailController alloc]init];
    [self.navigationController pushViewController:PayFail animated:YES];
}

-(void)weiXinPaySuccess {
    //支付结果回写
    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    NSString * url = self.interfaceManager.payResultUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"orderId"] = @(self.orderid);
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/payResult" time:time addExtraStr:[NSString stringWithFormat:@"%ld",self.orderid]];
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    paramDict[@"totalMoney"] = self.orderInfoModel.totalMoney;
    paramDict[@"result"] = @"success";
    
    paramDict[@"payType"] = @(3);
    paramDict[@"beansConsumption"] = _currentZhuanDouNum;
    paramDict[@"orderType"] = @(self.orderInfoModel.orderType);
    
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
                if (self.orderInfoModel.orderType == 3) {
                    paySuccess.type = @"1";
                }
                else
                {
                    paySuccess.type = @"2";
                }
                paySuccess.orderId =self.orderid;
                [self.navigationController pushViewController:paySuccess animated:YES];
            });
            
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
    }];
}

-(void)textViewChange:(NSNotification *)textView
{

    if (_textView.text.length > 6) {
        [self.hudManager showErrorSVHudWithTitle:@"不能输入大于6位数" hideAfterDelay:1.0];
        _textView.text = [_textView.text substringToIndex:6];
        return;
    }


}

#pragma mark --CurrentRepaymentCellDelegate
- (void)pressCurrentCellrepaymentBtn
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
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
    [self.grayBackBtn removeFromSuperview];
    
    NSInteger payType = 0;
    switch (sender.tag) {
        case 1000:
        {
            NSLog(@"点击了微信");
            payType = 3;
            [self.hudManager showNormalStateSVHUDWithTitle:nil];
            NSString * url = self.interfaceManager.submitOrder;
            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
            paramDict[@"uid"] = kUid;
            NSString * time = [HttpParamManager getTime];
            paramDict[@"time"] = time;
            paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/SubmitOrder" time:time];
            paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
            paramDict[@"payType"] = @(payType);
            paramDict[@"style"] = @(_zhifuType);
            paramDict[@"orderType"] = @(self.orderType);
            NSMutableString *str = [[NSMutableString alloc]init];
            for (int i = 0; i<self.orderInfoModel.productinfo.count; i++) {
                ProductInfo *model = self.orderInfoModel.productinfo[i];
                [str appendString:[NSString stringWithFormat:@",%d",model.idNum]];
            }
            paramDict[@"productId"] = [str substringFromIndex:1];
            if (_currentCouponInfoModel) {
                paramDict[@"cashCouponId"] = @(_currentCouponInfoModel.idNum);
            }
            paramDict[@"Beans"] = _currentZhuanDouNum;
            
            [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                HJLog(@">>>%@",dict);
                NSInteger code = [dict[@"code"] integerValue];
                NSString * msg = dict[@"msg"];
                if (code == 1) {

                    [self.hudManager dismissSVHud];
                    NSDictionary * infoDict = [dict objectForKey:@"info"];
                    self.orderid = [infoDict[@"orderId"] longLongValue];
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
                    [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
                }
            } failed:^(NSError *error) {
                
                [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
            }];
            
            
            
        }
            break;
        case 2000:
        {
            NSLog(@"点击了支付宝");
            payType = 1;
            
            [self.hudManager showNormalStateSVHUDWithTitle:nil];
            NSString * url = self.interfaceManager.submitOrder;
            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
            paramDict[@"uid"] = kUid;
            NSString * time = [HttpParamManager getTime];
            paramDict[@"time"] = time;
            paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/SubmitOrder" time:time];
            paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
            paramDict[@"payType"] = @(payType);
            paramDict[@"style"] = @(_zhifuType);
            paramDict[@"orderType"] = @(self.orderType);
            NSMutableString *str = [[NSMutableString alloc]init];
            for (int i = 0; i<self.orderInfoModel.productinfo.count; i++) {
                ProductInfo *model = self.orderInfoModel.productinfo[i];
                [str appendString:[NSString stringWithFormat:@",%d",model.idNum]];
            }
            paramDict[@"productId"] = [str substringFromIndex:1];
            if (_currentCouponInfoModel) {
                paramDict[@"cashCouponId"] = @(_currentCouponInfoModel.idNum);
            }
            paramDict[@"Beans"] = _currentZhuanDouNum;
            
            [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                HJLog(@">>>%@",dict);
                NSInteger code = [dict[@"code"] integerValue];
                NSString * msg = dict[@"msg"];
                if (code == 1) {
                    
                    [self.hudManager dismissSVHud];
                    
                    NSDictionary * infoDict = [dict objectForKey:@"info"];
                    
                    NSString *jsonString = infoDict[@"content"];
                    
                    self.orderid = [infoDict[@"orderId"] longLongValue];

                    [[AlipaySDK defaultService] payOrder:jsonString fromScheme:@"alipaySDK" callback:^(NSDictionary *resultDic) {
                        
                        NSLog(@"开始确认支付状态 %@",resultDic[@"resultStatus"]);
                        if ([resultDic[@"resultStatus"]isEqualToString:@"9000"])//成功
                        {
                            //支付结果回写
                            [self.hudManager showNormalStateSVHUDWithTitle:nil];
                            NSString * url = self.interfaceManager.payResultUrl;
                            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
                            paramDict[@"orderId"] = @(self.orderid);
                            paramDict[@"uid"] = kUid;
                            NSString * time = [HttpParamManager getTime];
                            paramDict[@"time"] = time;
                            paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/payResult" time:time addExtraStr:[NSString stringWithFormat:@"%ld",self.orderid]];
                            paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
                            paramDict[@"totalMoney"] = self.orderInfoModel.totalMoney;
                            paramDict[@"result"] = @"success";

                            paramDict[@"payType"] = @(payType);
                            paramDict[@"beansConsumption"] = _currentZhuanDouNum;
                            paramDict[@"orderType"] = @(self.orderType);

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
                                        if (self.orderInfoModel.orderType == 3) {
                                            paySuccess.type = @"1";
                                        }else
                                        {
                                            paySuccess.type = @"2";
                                        }
                                        paySuccess.orderId =self.orderid;
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
                    [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
                }
            } failed:^(NSError *error) {
                
                [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
            }];
            
            
            
            
            
        }
            break;
            
        case 3000:
        {
            NSLog(@"赚豆或优惠券全部抵完金额，无需额外支付");
            payType = 4;
            
            [self.hudManager showNormalStateSVHUDWithTitle:nil];
            NSString * url = self.interfaceManager.submitOrder;
            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
            paramDict[@"uid"] = kUid;
            NSString * time = [HttpParamManager getTime];
            paramDict[@"time"] = time;
            paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/SubmitOrder" time:time];
            paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
            paramDict[@"payType"] = @(payType);
            paramDict[@"style"] = @(_zhifuType);
            paramDict[@"orderType"] = @(self.orderType);
            NSMutableString *str = [[NSMutableString alloc]init];
            for (int i = 0; i<self.orderInfoModel.productinfo.count; i++) {
                ProductInfo *model = self.orderInfoModel.productinfo[i];
                [str appendString:[NSString stringWithFormat:@",%d",model.idNum]];
            }
            paramDict[@"productId"] = [str substringFromIndex:1];
            if (_currentCouponInfoModel) {
                paramDict[@"cashCouponId"] = @(_currentCouponInfoModel.idNum);
            }
            paramDict[@"Beans"] = _currentZhuanDouNum;
            
            [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                HJLog(@">>>%@",dict);
                NSInteger code = [dict[@"code"] integerValue];
                NSString * msg = dict[@"msg"];
                if (code == 1) {
                    
                    [self.hudManager dismissSVHud];
                    
                    NSDictionary * infoDict = [dict objectForKey:@"info"];
                    
                    NSString *jsonString = infoDict[@"content"];
                    
                    self.orderid = [infoDict[@"orderId"] longLongValue];
                    
                    //支付结果回写
                    [self.hudManager showNormalStateSVHUDWithTitle:nil];
                    NSString * url = self.interfaceManager.payResultUrl;
                    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
                    paramDict[@"orderId"] = @(self.orderid);
                    paramDict[@"uid"] = kUid;
                    NSString * time = [HttpParamManager getTime];
                    paramDict[@"time"] = time;
                    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/payResult" time:time addExtraStr:[NSString stringWithFormat:@"%ld",self.orderid]];
                    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
                    paramDict[@"totalMoney"] = self.orderInfoModel.totalMoney;
                    paramDict[@"result"] = @"success";
                    
                    paramDict[@"payType"] = @(payType);
                    paramDict[@"beansConsumption"] = _currentZhuanDouNum;
                    paramDict[@"orderType"] = @(self.orderType);
                    
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
                                if (self.orderInfoModel.orderType == 3) {
                                    paySuccess.type = @"1";
                                }else
                                {
                                    paySuccess.type = @"2";
                                }
                                paySuccess.orderId =self.orderid;
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
                    [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
                }
            } failed:^(NSError *error) {
                
                [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
            }];
            
            
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)createUI {
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight)];
    _bgScrollView.backgroundColor = BG_COLOR;
    _bgScrollView.delegate = self;
    _bgScrollView.contentSize = CGSizeMake(kScreenWidth, 667);
    _bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];
    
    [self createTopImageView];
    
}
- (void)createTopImageView {
    
    _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 500-60)];
    _topImageView.contentMode = UIViewContentModeScaleToFill;
    _topImageView.image = [UIImage imageNamed:@"icon-dingdan-bg"];
    _topImageView.userInteractionEnabled = YES;
    [_bgScrollView addSubview:_topImageView];
    
    _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, kScreenWidth, kScreenHeight - 20 -15 -kNavHeight +400 +120-60 ) style:UITableViewStylePlain];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.showsVerticalScrollIndicator = YES;
    _orderTableView.backgroundColor = [UIColor clearColor];
    _orderTableView.scrollEnabled = NO;
    _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _orderTableView.allowsSelection = NO;
    [_topImageView addSubview:_orderTableView];
    [_orderTableView registerNib:[UINib nibWithNibName:@"SchoolAndAddressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SchoolAndAddressCell"];
    [_orderTableView registerNib:[UINib nibWithNibName:@"ClassTypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ClassTypeCell"];
    [_orderTableView registerNib:[UINib nibWithNibName:@"DiscountCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DiscountCell"];
    [_orderTableView registerNib:[UINib nibWithNibName:@"RepayTypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RepayTypeCell"];
    [_orderTableView registerClass:[PartnerTrainSubmitCell class
                                    ] forCellReuseIdentifier:@"PartnerTrainSubmitCell"];
    [_orderTableView registerClass:[PartnerTrainWaitCell class] forCellReuseIdentifier:@"PartnerTrainWaitCell"];
    [_orderTableView registerClass:[PartnerTrainFailCell class] forCellReuseIdentifier:@"PartnerTrainFailCell"];
    [_orderTableView registerNib:[UINib nibWithNibName:@"OrderEarnBeanCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderEarnBeanCell"];
    [_orderTableView registerNib:[UINib nibWithNibName:@"RepaySuccessCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RepaySuccessCell"];
    
    
    _paymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];//支付按钮
    _paymentBtn.frame = CGRectMake(64, CGRectGetMaxY(_topImageView.frame), kScreenWidth-64*2, 40);
    
    _paymentBtn.backgroundColor = rgb(41, 45, 48);
    _paymentBtn.layer.cornerRadius = 20.0;
    NSMutableAttributedString * payStr = nil;
    payStr = [[NSMutableAttributedString alloc]initWithString:@"支付" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%.2f",self.orderInfoModel.totalMoney.floatValue] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#bbe0ff"],NSFontAttributeName:[UIFont systemFontOfSize:16]}]];
    [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"元" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}]];
    [_paymentBtn setAttributedTitle:payStr forState:UIControlStateNormal];
    [_paymentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_paymentBtn addTarget:self action:@selector(clickPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollView addSubview:_paymentBtn];
    
    
}

- (void)clickPayBtn:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"申请"]) {
        
        [self.hudManager showNormalStateSVHUDWithTitle:nil];
        NSString * url = self.interfaceManager.submitOrder;
        NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
        paramDict[@"uid"] = kUid;
        NSString * time = [HttpParamManager getTime];
        paramDict[@"time"] = time;
        paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/SubmitOrder" time:time];
        paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
        paramDict[@"payType"] = @(0);
        paramDict[@"style"] = @(_zhifuType);
        paramDict[@"orderType"] = @(self.orderType);
        NSMutableString *str = [[NSMutableString alloc]init];
        for (int i = 0; i<self.orderInfoModel.productinfo.count; i++) {
            ProductInfo *model = self.orderInfoModel.productinfo[i];
            [str appendString:[NSString stringWithFormat:@",%d",model.idNum]];
        }
        paramDict[@"productId"] = [str substringFromIndex:1];
        if (_currentCouponInfoModel) {
            paramDict[@"cashCouponId"] = @(_currentCouponInfoModel.idNum);
        }
        paramDict[@"Beans"] = _currentZhuanDouNum;
        
        [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            HJLog(@">>>%@",dict);
            NSInteger code = [dict[@"code"] integerValue];
            NSString *msg = dict[@"msg"];
            if (code == 1) {
                [self.hudManager dismissSVHud];
                NSString *stagingURL = dict[@"info"][@"content"];
                KZWebController *webCtl = [[KZWebController alloc] initWithNibName:@"KZWebController" bundle:nil];
                webCtl.hidesBottomBarWhenPushed = YES;
                webCtl.webURL = stagingURL;
                webCtl.dynamicTitle = YES;
                [self.navigationController pushViewController:webCtl animated:YES];
            } else {
                [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
            }
        } failed:^(NSError *error) {
            
            [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
        }];
 
    } else {
        
        //更改应支付金额
        CGFloat money = 0.0;
        if (_currentCouponInfoModel) {
            money =  self.orderInfoModel.totalMoney.floatValue -_currentCouponInfoModel.money.floatValue-_currentZhuanDouNum.floatValue*self.orderInfoModel.beans_ratio;
        }
        else
        {
            money =  self.orderInfoModel.totalMoney.floatValue -_currentZhuanDouNum.floatValue*self.orderInfoModel.beans_ratio;
        }
        if (money<=0) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 3000;
            [self pressPayBtn:btn];
//            [self.hudManager showErrorSVHudWithTitle:@"应付金额不能小于零" hideAfterDelay:1.0];
            return;
        }
        [self pressCurrentCellrepaymentBtn];
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        static NSString * identifier = @"SchoolAndAddressCell";
        SchoolAndAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.orderNumberLab.hidden = YES;
        cell.topConstraint.constant = 60;
        cell.schoolTitleLab.text = [NSString stringWithFormat:@"%@:",((OrderProfiles *)_orderInfoModel.orderProfiles[0]).title];
        cell.schoolLab.text = ((OrderProfiles *)_orderInfoModel.orderProfiles[0]).content;
        if(_orderInfoModel.orderProfiles.count == 2){
            cell.addressTitleLab.text = [NSString stringWithFormat:@"%@:",((OrderProfiles *)_orderInfoModel.orderProfiles[1]).title];
            cell.addressLab.text = ((OrderProfiles *)_orderInfoModel.orderProfiles[1]).content;
        }
        else
        {
            cell.addressTitleLab.text = @"";
            cell.addressLab.text = @"";
        }
        return cell;
        
    }if (indexPath.row == 1) {
        
        static NSString *  identifier = @"ClassTypeCell";
        ClassTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        ProductInfo *info =  self.orderInfoModel.productinfo[0];
        cell.classTypeLab.text = info.content;
        
        if (self.orderType == 3) {
            cell.classTypeTitleLab.text = @"套餐";
        }
        
        return cell;
        
    }if (indexPath.row == 2) {
        
        static NSString * identifier = @"DiscountCell";
        DiscountCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.detailVoucherLab.gestureRecognizers = [NSArray array];
        [cell.detailVoucherLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        if (_currentDaiJingQuanStr.length > 0) {
            cell.detailVoucherLab.text = _currentDaiJingQuanStr;
        }
        else
        {
            _currentCouponInfoModel = nil;
            cell.detailVoucherLab.text  = @"请选择优惠券";
        }

        
        return cell;
        
    }if (indexPath.row == 3) {
        
        static NSString * identifier = @"PersonFourthTableCell";
        MyOderExtraBottomCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyOderExtraBottomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.backgroundColor = [UIColor clearColor];
        
        
        cell.thirdLabel.text = [NSString stringWithFormat:@"抵%.2f元",_currentZhuanDouNum.intValue*self.orderInfoModel.beans_ratio];
//        cell.fourthLabel.text = [NSString stringWithFormat:@"共%@赚豆，最多可抵%.2f元",_currentZhuanDouNum,_currentZhuanDouNum.intValue*self.orderInfoModel.beans_ratio];
        cell.fourthLabel.text = [NSString stringWithFormat:@"共%ld赚豆，最多可抵%.2f元",self.orderInfoModel.beans,self.orderInfoModel.beans*self.orderInfoModel.beans_ratio];
        cell.secondTextView.attributedText = [cell getAttrStringWithZhuanDouNum:_currentZhuanDouNum];
        cell.delegate = self;
        _textView = cell.secondTextView;
        
        [cell.secondTextView setCustomDoneTarget:self action:@selector(done:)];
        cell.warningLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
//        if (self.orderInfoModel.totalMoney.floatValue < 1000.00) {//小于1000,不能分期
//            
//            cell.payFirstBtn.hidden = YES;
//            cell.paySecondBtn.hidden = YES;
//        }
//        else
//        {
            cell.payFirstBtn.hidden = NO;
            cell.paySecondBtn.hidden = NO;
//        }
        
        return cell;
        
    }

    return nil;
}
-(void)tap:(UITapGestureRecognizer *)tap
{
    if (self.orderInfoModel.cashCouponInfo.count >= 1) {
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (int i = 0; i<self.orderInfoModel.cashCouponInfo.count; i++) {
            CashCouponInfo *info = self.orderInfoModel.cashCouponInfo[i];
            [arr addObject:[NSString stringWithFormat:@"%@元%@",info.money,info.name]];
        }
        [arr addObject:@"不使用"];
        ZHPickView *pickView = [[ZHPickView alloc]initPickviewWithArray:arr isHaveNavControler:NO];
        pickView.tag = 4061;
        _pickView = pickView;
        [pickView setPickViewColer:[UIColor whiteColor]];
        pickView.delegate = self;
        [pickView show];
    }
    else
    {
        [self.hudManager showErrorSVHudWithTitle:@"没有代金券，快去领取吧！" hideAfterDelay:1.0];
        return;
    }


}
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    
    _currentDaiJingQuanStr = resultString;
    
    for (int i = 0; i<self.orderInfoModel.cashCouponInfo.count; i++) {
        CashCouponInfo *info = self.orderInfoModel.cashCouponInfo[i];
        NSString *str = [NSString stringWithFormat:@"%@元%@",info.money,info.name];
        if ([str isEqualToString:_currentDaiJingQuanStr]) {
            _currentCouponInfoModel = info;
            break;
        }
        else
        {
            _currentCouponInfoModel = nil;

        }
    }
    
    [_orderTableView reloadData];
    
    //更改应支付金额
    CGFloat money = 0.0;
    if (_currentCouponInfoModel) {
        money =  self.orderInfoModel.totalMoney.floatValue -_currentCouponInfoModel.money.floatValue-_currentZhuanDouNum.floatValue*self.orderInfoModel.beans_ratio;
    }
    else
    {
        money =  self.orderInfoModel.totalMoney.floatValue -_currentZhuanDouNum.floatValue*self.orderInfoModel.beans_ratio;
    }
//    if (money<=0) {
//        [self.hudManager showErrorSVHudWithTitle:@"应付金额不能小于零" hideAfterDelay:1.0];
//    }
    if (money<=0) {
        money = 0;
        [_paymentBtn setAttributedTitle:[NSMutableAttributedString attributeStringWithText:@"确认提交" attributes:@[[UIColor whiteColor],[UIFont systemFontOfSize:16]]] forState:UIControlStateNormal];
        return;
    }
    NSMutableAttributedString * payStr = nil;
    payStr = [[NSMutableAttributedString alloc]initWithString:@"支付" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%.2f",money] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#bbe0ff"],NSFontAttributeName:[UIFont systemFontOfSize:16]}]];
    [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"元" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}]];
    [_paymentBtn setAttributedTitle:payStr forState:UIControlStateNormal];
    
}

//第四个cell的代理方法
#pragma mark PersonFourthTableCellDelegete
- (void)clickPersonFourthCellPayBtn:(NSInteger)markTag
{
    if (markTag == 100) {
        NSLog(@"全额付款");
        _zhifuType = 1;
        
        NSMutableAttributedString * payStr = nil;
        payStr = [[NSMutableAttributedString alloc]initWithString:@"支付" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%.2f",self.orderInfoModel.totalMoney.floatValue] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#bbe0ff"],NSFontAttributeName:[UIFont systemFontOfSize:16]}]];
        [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"元" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}]];
        [_paymentBtn setAttributedTitle:payStr forState:UIControlStateNormal];
        
        
        [_orderTableView reloadData];
    }else{
        NSLog(@"分期支付");
        _zhifuType = 2;
        
        NSMutableAttributedString * payStr = nil;
        payStr = [[NSMutableAttributedString alloc]initWithString:@"申请" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        [_paymentBtn setAttributedTitle:payStr forState:UIControlStateNormal];
        
        
        [_orderTableView reloadData];
    }
}


-(void)done:(UITextView *)textView
{

    _currentZhuanDouNum = textView.text;
    
    [_orderTableView reloadData];
    
    if (textView.text.longValue > self.orderInfoModel.beans) {
        _currentZhuanDouNum = @"0";
        [self.hudManager showErrorSVHudWithTitle:@"赚豆不足" hideAfterDelay:1.0];
        return;
    }
    
    //更改应支付金额
    CGFloat money = 0.0;
    if (_currentCouponInfoModel) {
        money =  self.orderInfoModel.totalMoney.floatValue -_currentCouponInfoModel.money.floatValue-_currentZhuanDouNum.floatValue*self.orderInfoModel.beans_ratio;
    }
    else
    {
        money =  self.orderInfoModel.totalMoney.floatValue -_currentZhuanDouNum.floatValue*self.orderInfoModel.beans_ratio;
    }
//    if (money<=0) {
//        [self.hudManager showErrorSVHudWithTitle:@"应付金额不能小于零" hideAfterDelay:1.0];
//    }
    if (money<=0) {
        money = 0;
        [_paymentBtn setAttributedTitle:[NSMutableAttributedString attributeStringWithText:@"确认提交" attributes:@[[UIColor whiteColor],[UIFont systemFontOfSize:16]]] forState:UIControlStateNormal];
        return;
    }
    NSMutableAttributedString * payStr = nil;
    payStr = [[NSMutableAttributedString alloc]initWithString:@"支付" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%.2f",money] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#bbe0ff"],NSFontAttributeName:[UIFont systemFontOfSize:16]}]];
    [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"元" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}]];
    [_paymentBtn setAttributedTitle:payStr forState:UIControlStateNormal];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        if (self.orderType == 3) {
            return 90;
        }
        else
        {
            return 130;
        }
        
    }
    if (indexPath.row == 1 || indexPath.row == 2 ) {
        
        return 55;
    }
    if (indexPath.row == 3) {
        
        return 134;
    }
    return 0;
}
- (void)createNavigation {
    
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:@"订单详情"];
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
