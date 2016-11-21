//
//  PartnerTrainOrderController.m
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "NSMutableAttributedString+LLExtension.h"
#import "PartnerTrainOrderController.h"
#import "PToderFirstTableCell.h"
#import "PToderSecondTableCell.h"
#import "PersonThirdTableCell.h"
#import "PersonFourthTableCell.h"
#import "PersonFifthTableCell.h"
#import "PartnerTrainResultController.h"
#import "ZHPickView.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "AliPayModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiObject.h"
#import "WXApi.h"
#import "PaySuccessController.h"
#import "PayFailController.h"
static BOOL FifthCellHidden = YES;
@interface PartnerTrainOrderController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,PersonFourthTableCellDelegete,ZHPickViewDelegate>
{
    UIScrollView * _backScrollView;
    UIImageView * _topImageView;
    UITableView * _orderTableView;
    UIButton * _paymentBtn;
    ZHPickView *_pickView;
    NSString *_currentDaiJingQuanStr;
    NSString *_currentZhuanDouNum;
//    UITextView *_textView;
    UITextField *_textView;
    CashCouponInfo *_currentCouponInfoModel;
    NSInteger _zhifuType;
    
}
@property(nonatomic,strong)UIButton * grayBackBtn;

@property(nonatomic,strong)NSString * orderId;


@end

@implementation PartnerTrainOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _zhifuType = 1;
    
    _currentZhuanDouNum = @"0";
    //学士陪练进入的订单界面
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"订单"];
    [self createUI];
    
    [NOTIFICATION_CENTER addObserver:self selector:@selector(textViewChange:) name:UITextViewTextDidChangeNotification object:nil];
    
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
    paramDict[@"orderId"] = self.orderId;
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/payResult" time:time addExtraStr:self.orderId];
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
                paySuccess.orderId =self.orderId.longLongValue;
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

-(void)textViewChange:(NSNotification *)textView
{
    
    if (_textView.text.length > 6) {
        [self.hudManager showErrorSVHudWithTitle:@"不能输入大于6位数" hideAfterDelay:1.0];
        _textView.text = [_textView.text substringToIndex:6];
        return;
    }
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_pickView remove];
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
            paramDict[@"orderType"] = @(5);
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
                    NSString *jsonStringDec = infoDict[@"content"];
                    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:jsonStringDec options:0];
                    NSString *jsonString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
                    
                    self.orderId = infoDict[@"orderId"];
                    
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
            paramDict[@"orderType"] = @(5);
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

                    self.orderId = infoDict[@"orderId"];
                    
                    [[AlipaySDK defaultService] payOrder:jsonString fromScheme:@"alipaySDK" callback:^(NSDictionary *resultDic) {
                        
                        NSLog(@"开始确认支付状态 %@",resultDic[@"resultStatus"]);
                        
                        NSString *memo = resultDic[@"memo"];
                        
                        if ([resultDic[@"resultStatus"]isEqualToString:@"9000"])//成功
                        {
                            //支付结果回写
                            [self.hudManager showNormalStateSVHUDWithTitle:nil];
                            NSString * url = self.interfaceManager.payResultUrl;
                            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
                            paramDict[@"orderId"] = self.orderId;
                            paramDict[@"uid"] = kUid;
                            NSString * time = [HttpParamManager getTime];
                            paramDict[@"time"] = time;
                            paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/payResult" time:time addExtraStr:self.orderId];
                            paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
                            paramDict[@"totalMoney"] = self.orderInfoModel.totalMoney;
                            paramDict[@"result"] = @"success";
                            
                            paramDict[@"payType"] = @(payType);
                            paramDict[@"beansConsumption"] = _currentZhuanDouNum;
                            paramDict[@"orderType"] = @(5);
                            
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
                                        paySuccess.type = @"2";
                                        paySuccess.orderId =self.orderId.longLongValue;
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
                            //支付结果回写
//                            [self.hudManager showNormalStateSVHUDWithTitle:nil];
//                            NSString * url = self.interfaceManager.payResultUrl;
//                            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
//                            paramDict[@"orderId"] = self.orderId;
//                            paramDict[@"uid"] = kUid;
//                            NSString * time = [HttpParamManager getTime];
//                            paramDict[@"time"] = time;
//                            paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/payResult" time:time];
//                            paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
//                            paramDict[@"totalMoney"] = self.orderInfoModel.totalMoney;
//                            paramDict[@"result"] = @"fiald";
//                            paramDict[@"payType"] = @(payType);
//                            paramDict[@"beansConsumption"] = _currentZhuanDouNum;
//                            paramDict[@"orderType"] = @(5);
//                            
//                            [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
//                                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                HJLog(@">>>%@",dict);
//                                NSInteger code = [dict[@"code"] integerValue];
//                                NSString * msg = dict[@"msg"];
//                                
//                                if (code == 1) {
//                                    
//                                    NSDictionary *resultDict = dict[@"info"];

                                        PayFailController *PayFail = [[PayFailController alloc]init];
                                        [self.navigationController pushViewController:PayFail animated:YES];
//                                }
//                                else
//                                {
//                                    [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
//                                }
//                                
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
            paramDict[@"orderType"] = @(5);
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
                    
                    self.orderId = infoDict[@"orderId"];
                    
                    //支付结果回写
                    [self.hudManager showNormalStateSVHUDWithTitle:nil];
                    NSString * url = self.interfaceManager.payResultUrl;
                    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
                    paramDict[@"orderId"] = self.orderId;
                    paramDict[@"uid"] = kUid;
                    NSString * time = [HttpParamManager getTime];
                    paramDict[@"time"] = time;
                    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/payResult" time:time addExtraStr:self.orderId];
                    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
                    paramDict[@"totalMoney"] = self.orderInfoModel.totalMoney;
                    paramDict[@"result"] = @"success";
                    
                    paramDict[@"payType"] = @(payType);
                    paramDict[@"beansConsumption"] = _currentZhuanDouNum;
                    paramDict[@"orderType"] = @(5);
                    
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
                                paySuccess.orderId = [self.orderId longLongValue];
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

- (void)createUI
{
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _backScrollView.backgroundColor = rgb(239, 245, 244);
    _backScrollView.delegate = self;
    _backScrollView.showsVerticalScrollIndicator =  NO;
    _backScrollView.contentSize = CGSizeMake(kScreenWidth,  476+105+80+45*(self.orderInfoModel.productinfo.count-1));
    [self.view addSubview:_backScrollView];
    
    [self createTopImageView];

}

- (void)createTopImageView
{
    
    
    _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 476+105-60+45*(self.orderInfoModel.productinfo.count-1)-40)];
    _topImageView.backgroundColor = [UIColor colorWithHexString:@"#f2f7f6"];
    _topImageView.contentMode = UIViewContentModeScaleToFill;
    _topImageView.image = [UIImage imageNamed:@"icon-dingdan-bg"];
    _topImageView.userInteractionEnabled = YES;
    [_backScrollView addSubview:_topImageView];
    
    _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 15, kScreenWidth-15*2, 397+104+9-60+45*(self.orderInfoModel.productinfo.count-1)-40) style:UITableViewStylePlain];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.separatorColor = [UIColor colorWithHexString:@"f0f0f0"];
    _orderTableView.showsVerticalScrollIndicator = NO;
    _orderTableView.backgroundColor = [UIColor clearColor];
    _orderTableView.scrollEnabled = NO;
    [_topImageView addSubview:_orderTableView];
    
    _paymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _paymentBtn.frame = CGRectMake(64, CGRectGetMaxY(_topImageView.frame), kScreenWidth-64*2, 40);
    
    _paymentBtn.backgroundColor = [UIColor colorWithHexString:@"#352c3f"];
    _paymentBtn.layer.cornerRadius = 20.0;
    NSMutableAttributedString * payStr = nil;
    payStr = [[NSMutableAttributedString alloc]initWithString:@"支付" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%.2f",self.orderInfoModel.totalMoney.floatValue] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#bbe0ff"],NSFontAttributeName:[UIFont systemFontOfSize:16]}]];
    [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"元" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}]];
    [_paymentBtn setAttributedTitle:payStr forState:UIControlStateNormal];
    [_paymentBtn addTarget:self action:@selector(clickPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_backScrollView addSubview:_paymentBtn];
    
}

- (void)clickPayBtn:(UIButton *)sender
{
    //更改应支付金额
    CGFloat money = 0;
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

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//第四个cell的代理方法
#pragma mark PersonFourthTableCellDelegete
- (void)clickPersonFourthCellPayBtn:(NSInteger)markTag
{
    if (markTag == 100) {
        NSLog(@"全额付款");
        _zhifuType = 1;

//        FifthCellHidden = YES;
//        _backScrollView.contentSize = CGSizeMake(kScreenWidth, 664+105);
//        _topImageView.frame =CGRectMake(0, 20, kScreenWidth, 476+105);
//        _orderTableView.frame = CGRectMake(15, 15, kScreenWidth-15*2, 397+104+9);
//        _paymentBtn.frame = CGRectMake(64, CGRectGetMaxY(_topImageView.frame), kScreenWidth-64*2, 40);
        [_orderTableView reloadData];
    }else{
        NSLog(@"分期支付");
        _zhifuType = 2;

//        FifthCellHidden = NO;
//        _backScrollView.contentSize = CGSizeMake(kScreenWidth, 664+105+134+20-60);
//        _topImageView.frame =CGRectMake(0, 20, kScreenWidth, 476+105+134+20-60);
//        _orderTableView.frame = CGRectMake(15, 15, kScreenWidth-15*2, 397+104+134+9-60);
//        _paymentBtn.frame = CGRectMake(64, CGRectGetMaxY(_topImageView.frame), kScreenWidth-64*2, 40);
        [_orderTableView reloadData];
    }
}

- (void)personFourthCellsecondField
{
    NSLog(@"textfield键入");
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 20, 0, 20)];
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 198-35;
    }else if(indexPath.row == 1){
//        return 124;
        return 45*(self.orderInfoModel.productinfo.count+1);
    }else if(indexPath.row == 3){
        return 134;
    }else if(indexPath.row == 4){
        return 138;
    }else if(indexPath.row == 2){
        return 55;
    }else{
        return 46;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(FifthCellHidden == NO){
        return 5;
    }else{
       return 4;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"sdcds");
    
    if (indexPath.row == 2 && indexPath.section == 0) {
        
        
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString * string = @"cellOne";
        PToderFirstTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[PToderFirstTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        cell.orderIdLabel.text = [NSString stringWithFormat:@"订单编号：%ld",self.orderInfoModel.beans];
        cell.orderIdLabel.hidden = YES;
        //教练
        NSMutableAttributedString * attStr = nil;
        attStr = [[NSMutableAttributedString alloc]initWithString:@"教练:" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#c8c8c8"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        OrderProfiles *profiles = self.orderInfoModel.orderProfiles[0];
        [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:profiles.content attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
        cell.coachLabel.attributedText = attStr;
        //驾龄
        OrderProfiles *profiles1 = self.orderInfoModel.orderProfiles[1];
        [cell.jiaLingBtn setTitle:self.jiaLing forState:UIControlStateNormal];

        //科目
        NSMutableAttributedString * subjectsStr = nil;
        subjectsStr = [[NSMutableAttributedString alloc]initWithString:@"科目:" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#c8c8c8"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        NSString *subjectNum = nil;
        if ([self.subjectNum isEqualToString:@"second"]) {
            subjectNum = [NSString stringWithFormat:@"科目二"];
        }else
        {
            subjectNum = [NSString stringWithFormat:@"科目三"];
        }
        [subjectsStr appendAttributedString:[[NSAttributedString alloc]initWithString:subjectNum attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
        cell.subjectLabel.attributedText = subjectsStr;
        
        //地址
        NSMutableAttributedString * addressStr = nil;
        addressStr = [[NSMutableAttributedString alloc]initWithString:@"地址:" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#c8c8c8"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        OrderProfiles *profiles2 = self.orderInfoModel.orderProfiles[2];
        [addressStr appendAttributedString:[[NSAttributedString alloc]initWithString:profiles2.content attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
        cell.addressLabel.attributedText = addressStr;
        
        //车辆
        NSMutableAttributedString * carsStr = nil;
        carsStr = [[NSMutableAttributedString alloc]initWithString:@"车辆:" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#c8c8c8"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        [carsStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"捷达" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
        cell.carLabel.attributedText = carsStr;


        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1){
        static NSString * string = @"cellTwo";
        PToderSecondTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[PToderSecondTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        cell.infoModel = self.orderInfoModel;
        cell.timeArray = self.orderInfoModel.productinfo.mutableCopy;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 2){
        static NSString * string = @"cellThree";
        PersonThirdTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[PersonThirdTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        if (_currentDaiJingQuanStr.length > 0) {
            cell.thirdLabel.text = _currentDaiJingQuanStr;
        }
        else
        {
//            if (self.orderInfoModel.cashCouponInfo.count>=1) {
//                CashCouponInfo *info = self.orderInfoModel.cashCouponInfo[0];
//                _currentCouponInfoModel = info;
//                cell.thirdLabel.text  = [NSString stringWithFormat:@"%@元%@",info.money,info.name];
//            }
//            else
//            {
                _currentCouponInfoModel = nil;
                cell.thirdLabel.text  = @"请选择优惠券";
//            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.row == 3){
        static NSString * string = @"cellFour";
        PersonFourthTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[PersonFourthTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        cell.payFirstBtn.hidden = YES;
        cell.paySecondBtn.hidden = YES;
        cell.thirdLabel.text = [NSString stringWithFormat:@"抵%.2f元",_currentZhuanDouNum.intValue*self.orderInfoModel.beans_ratio];
//        cell.fourthLabel.text = [NSString stringWithFormat:@"共%@赚豆，最多可抵%.2f元",_currentZhuanDouNum,_currentZhuanDouNum.intValue*self.orderInfoModel.beans_ratio];
        cell.fourthLabel.text = [NSString stringWithFormat:@"共%ld赚豆，最多可抵%.2f元",self.orderInfoModel.beans,self.orderInfoModel.beans*self.orderInfoModel.beans_ratio];
        cell.secondTextView.attributedText = [self getAttrStringWithZhuanDouNum:_currentZhuanDouNum];
        cell.delegate = self;
        _textView = cell.secondTextView;
        [cell.secondTextView setCustomDoneTarget:self action:@selector(done:)];
        cell.warningLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 4){
        static NSString * string = @"cellFive";
        PersonFifthTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[PersonFifthTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        
        
        NSMutableAttributedString * attStr = nil;
        attStr = [[NSMutableAttributedString alloc]initWithString:@"首付:  " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        
        Payment *payment = nil;
        if (self.orderInfoModel.payment.count>0) {
            
            payment = self.orderInfoModel.payment.firstObject;
            
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:payment.name attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
            cell.firstLabel.attributedText = attStr;
            
        }
        if (self.orderInfoModel.installment.count > 0) {
            Installment *model = self.orderInfoModel.installment.firstObject;
            NSMutableAttributedString * secondStr = nil;
            secondStr = [[NSMutableAttributedString alloc]initWithString:@"时间:  " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
            [secondStr appendAttributedString:[[NSAttributedString alloc]initWithString:model.name attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
            cell.secondLabel.attributedText = secondStr;
            int a = self.orderInfoModel.totalMoney.intValue-_textView.text.intValue-_currentCouponInfoModel.money.intValue;
            int money = a*(model.ratio)+a;
            NSString *month = [model.name substringToIndex:model.name.length-2];
            if (money>=0) {
                NSMutableAttributedString * thirdStr = nil;
                thirdStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"首付还款：首付%.2f元+月供%.2f元 每月还款：",payment.ratio,(float)(money/month.intValue)] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:13]}];
                [thirdStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",(float)(money/month.intValue)] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#55afff"],NSFontAttributeName:[UIFont systemFontOfSize:13]}]];
                [thirdStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"元" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:13]}]];
                cell.thirdLabel.attributedText = thirdStr;
            }
            else
            {
                cell.thirdLabel.text = @"赚豆或代金券够用，无需分期";
                cell.thirdLabel.font = [UIFont systemFontOfSize:13];
                cell.thirdLabel.textColor = [UIColor colorWithHexString:@"#999999"];
                

            }
        
        }
        
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
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
    
    CGFloat money = 0.0;
    //更改应支付金额
    if (_currentCouponInfoModel) {
        money =  self.orderInfoModel.totalMoney.floatValue -_currentCouponInfoModel.money.floatValue-_currentZhuanDouNum.floatValue*self.orderInfoModel.beans_ratio;
    }
    else
    {
        money =  self.orderInfoModel.totalMoney.floatValue -_currentZhuanDouNum.floatValue*self.orderInfoModel.beans_ratio;
    }
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
-(NSMutableAttributedString *)getAttrStringWithZhuanDouNum:(NSString *)num
{
    
    NSMutableAttributedString * secondStr = [[NSMutableAttributedString alloc]initWithString:num attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    NSTextAttachment *attachment=[[NSTextAttachment alloc] initWithData:nil ofType:nil];
    UIImage *img=[UIImage imageNamed:@"充值iconfont-zhuandou2"];
    attachment.image=img;
    attachment.bounds=CGRectMake(10, -5, 20, 20);
    NSAttributedString *atr2 = [NSMutableAttributedString attributedStringWithAttachment:attachment];
    [secondStr appendAttributedString:atr2];
    
    return secondStr;
    
}



@end
