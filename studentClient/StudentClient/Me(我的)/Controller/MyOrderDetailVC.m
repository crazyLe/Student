 //
//  MyOrderDetailVC.m
//  学员端
//
//  Created by gaobin on 16/7/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MyOrderDetailVC.h"
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
#import "MyOrderDetailsModel.h"
#import "MyOrderDetailPatnerTrainCell.h"
#import "FenQiOrderDetailCell.h"
#import "ZhuFuBtnCell.h"
#import "StagesApplySuccessCell.h"
#import "QRCodeGenerator.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiObject.h"
#import "WXApi.h"
#import "PaySuccessController.h"
#import "PayFailController.h"
@interface MyOrderDetailVC ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) UITableView *orderTableView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIButton *grayBackBtn;

@end

@implementation MyOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNavigation];
    
    [self createUI];
    
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
    paramDict[@"orderId"] = @(self.orderDetailInfo.orderId);
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/payResult" time:time addExtraStr:[NSString stringWithFormat:@"%lld",self.orderDetailInfo.orderId]];
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    paramDict[@"totalMoney"] = self.orderDetailInfo.totalMoney;
    paramDict[@"result"] = @"success";
    
    paramDict[@"payType"] = @(3);
    paramDict[@"beansConsumption"] = @(self.orderDetailInfo.mortgageBean);
    paramDict[@"orderType"] = @(self.orderDetailInfo.orderType);
    
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
                if (self.orderDetailInfo.orderType == 3) {
                    paySuccess.type = @"1";
                } else {
                    paySuccess.type = @"2";
                }
                paySuccess.orderId = self.orderDetailInfo.orderId;
                [self.navigationController pushViewController:paySuccess animated:YES];
            });
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
        }
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
    }];
}
- (void)createUI {
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight)];
    _bgScrollView.backgroundColor = BG_COLOR;
    _bgScrollView.delegate = self;
    _bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bgScrollView];
    
    [self createTopImageView];
}

- (void)createTopImageView {
    if (self.orderDetailInfo.orderType == 5) {//学时陪练
        if ([_orderDetailInfo.state isEqualToString:@"7"]||[_orderDetailInfo.state isEqualToString:@"1"]) {//审核通过
            if (self.orderDetailInfo.productInfo.count > 0) {
                _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 540+50*(self.orderDetailInfo.productInfo.count -1))];
                _bgScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight +400+50*(self.orderDetailInfo.productInfo.count -1));
            } else {
                _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 540)];
                _bgScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight +400);
            }
        } else {
            if (self.orderDetailInfo.productInfo.count > 0) {
                _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 540+50*(self.orderDetailInfo.productInfo.count -1))];
                _bgScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+50+50*(self.orderDetailInfo.productInfo.count -1));
            } else {
                _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 540)];
                _bgScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight +50);
            }
        }
    }
    else if(self.orderDetailInfo.orderType == 3)//私人定制
    {
        if (_orderDetailInfo.Style == 1) {
            _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 410)];
            _bgScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+50);
        } else {
            if ([_orderDetailInfo.state isEqualToString:@"1"]||[_orderDetailInfo.state isEqualToString:@"2"]||[_orderDetailInfo.state isEqualToString:@"3"]||[_orderDetailInfo.state isEqualToString:@"4"]) {
                _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 530)];
                _bgScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+80);

            } else {
                _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 410)];
                _bgScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+50);

            }
        }
    }
    else//其他订单
    {
        if (_orderDetailInfo.Style == 1) {
            _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 450)];
            _bgScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+160);
        } else {
            if ([_orderDetailInfo.state isEqualToString:@"1"]||[_orderDetailInfo.state isEqualToString:@"2"]||[_orderDetailInfo.state isEqualToString:@"3"]||[_orderDetailInfo.state isEqualToString:@"4"]) {
                _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 570)];
                _bgScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+150);

            } else {
                _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 450)];
                _bgScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+70);

            }
        }
    }
    _topImageView.contentMode = UIViewContentModeScaleToFill;
    _topImageView.image = [UIImage imageNamed:@"icon-dingdan-bg"];
    _topImageView.userInteractionEnabled = YES;
    [_bgScrollView addSubview:_topImageView];

    _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, kScreenWidth, kScreenHeight - kNavHeight+300) style:UITableViewStylePlain];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.showsVerticalScrollIndicator = YES;
    _orderTableView.backgroundColor = [UIColor clearColor];
    _orderTableView.scrollEnabled = NO;
    _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _orderTableView.allowsSelection = NO;
    _orderTableView.userInteractionEnabled = YES;
    [_bgScrollView addSubview:_orderTableView];
    [_orderTableView registerNib:[UINib nibWithNibName:@"SchoolAndAddressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SchoolAndAddressCell"];
    [_orderTableView registerNib:[UINib nibWithNibName:@"ClassTypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ClassTypeCell"];
    [_orderTableView registerNib:[UINib nibWithNibName:@"DiscountCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DiscountCell"];
    [_orderTableView registerNib:[UINib nibWithNibName:@"RepayTypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RepayTypeCell"];
    [_orderTableView registerClass:[PartnerTrainSubmitCell class] forCellReuseIdentifier:@"PartnerTrainSubmitCell"];
    [_orderTableView registerClass:[PartnerTrainWaitCell class] forCellReuseIdentifier:@"PartnerTrainWaitCell"];
    [_orderTableView registerClass:[PartnerTrainFailCell class] forCellReuseIdentifier:@"PartnerTrainFailCell"];
    [_orderTableView registerNib:[UINib nibWithNibName:@"OrderEarnBeanCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OrderEarnBeanCell"];
    [_orderTableView registerNib:[UINib nibWithNibName:@"RepaySuccessCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RepaySuccessCell"];
    [_orderTableView registerNib:[UINib nibWithNibName:@"StagesApplySuccessCell" bundle:nil] forCellReuseIdentifier:@"StagesApplySuccessCell"];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if(section == 1) {
        return self.orderDetailInfo.productInfo.count;
    } else {
        return 4;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
       
        if (self.orderDetailInfo.orderType == 5) {//是学时陪练订单
            MyOrderDetailPatnerTrainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderDetailPatnerTrainCell"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MyOrderDetailPatnerTrainCell" owner:nil options:nil]lastObject];
            }
            cell.titleLabel1.text = [NSString stringWithFormat:@"%@ :",((OrderProfiles *)_orderDetailInfo.orderProfiles[0]).title];
            cell.titleLabel2.text = [NSString stringWithFormat:@"%@ :",((OrderProfiles *)_orderDetailInfo.orderProfiles[1]).title];
            cell.titleLabel3.text = [NSString stringWithFormat:@"%@ :",((OrderProfiles *)_orderDetailInfo.orderProfiles[2]).title];
            cell.titleLabel4.text = [NSString stringWithFormat:@"%@ :",((OrderProfiles *)_orderDetailInfo.orderProfiles[3]).title];
            cell.titleLabel5.text = [NSString stringWithFormat:@"%@ :",((OrderProfiles *)_orderDetailInfo.orderProfiles[4]).title];
            cell.detailTitleLabel1.text = ((OrderProfiles *)_orderDetailInfo.orderProfiles[0]).content;
            cell.detailTitleLabel2.text = ((OrderProfiles *)_orderDetailInfo.orderProfiles[1]).content;
            cell.detailTitleLabel3.text = ((OrderProfiles *)_orderDetailInfo.orderProfiles[2]).content;
            cell.detailTitleLabel4.text = ((OrderProfiles *)_orderDetailInfo.orderProfiles[3]).content;
            cell.detailTitleLabel5.text = ((OrderProfiles *)_orderDetailInfo.orderProfiles[4]).content;
            cell.orderNumberLab.text = [NSString stringWithFormat:@"订单编号:%lld",self.orderDetailInfo.orderId];
            return cell;
            
        } else { //其他类型订单
            static NSString * identifier = @"SchoolAndAddressCell";
            SchoolAndAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            cell.orderNumberLab.text = [NSString stringWithFormat:@"订单编号:%lld",self.orderDetailInfo.orderId];
            cell.schoolTitleLab.text = [NSString stringWithFormat:@"%@:",((OrderProfiles *)_orderDetailInfo.orderProfiles[0]).title];
            cell.schoolLab.text = ((OrderProfiles *)_orderDetailInfo.orderProfiles[0]).content;
            if(_orderDetailInfo.orderProfiles.count == 2){
                cell.addressTitleLab.text = [NSString stringWithFormat:@"%@ :",((OrderProfiles *)_orderDetailInfo.orderProfiles[1]).title];
                cell.addressLab.text = ((OrderProfiles *)_orderDetailInfo.orderProfiles[1]).content;
            } else {
                cell.addressTitleLab.text = @"";
                cell.addressLab.text = @"";
            }
            return cell;
        }

    } else if (indexPath.section == 1) {
        static NSString *  identifier = @"ClassTypeCell";
        ClassTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        ProductInfo *info =  self.orderDetailInfo.productInfo[indexPath.row];
        cell.classTypeLab.text = info.content;
        cell.classTypeTitleLab.text = [NSString stringWithFormat:@"%@ :",info.title];
        cell.classTypeLab.font = [UIFont systemFontOfSize:15];
        return cell;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
          
            static NSString * identifier = @"DiscountCell";
            DiscountCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            cell.rightImageView.hidden = YES;
            if ([self.orderDetailInfo.cashCouponInfo.content isEqualToString:@""] ||self.orderDetailInfo.cashCouponInfo.content==nil) {
                cell.detailVoucherLab.text  = @"无";
            } else {
                cell.detailVoucherLab.text = self.orderDetailInfo.cashCouponInfo.content;
            }
            
            return cell;
        }
        if (indexPath.row == 1) {
            
            static NSString * identifier = @"OrderEarnBeanCell";
            OrderEarnBeanCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.backgroundColor = [UIColor clearColor];
            cell.textView.text = [NSString stringWithFormat:@"%lld",_orderDetailInfo.mortgageBean];
            cell.textView.textColor = [UIColor colorWithHexString:@"#666666"];
            cell.offsetMoneyLab.text = [NSString stringWithFormat:@"抵%@元",_orderDetailInfo.offsetMoney];
            cell.textFieldWidthConstraint.constant = [[NSString stringWithFormat:@"%lld",_orderDetailInfo.mortgageBean] sizeWithFont:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(100, MAXFLOAT)].width;
            return cell;
        }
        if (indexPath.row == 2) {
            if (_orderDetailInfo.Style == 1) {//全款支付
                static NSString * identifier = @"RepayTypeCell";
                RepayTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                cell.backgroundColor = [UIColor clearColor];
                cell.repayTypeLab.text = @"全款支付";
                cell.orderMoneyLab.text = _orderDetailInfo.totalMoney;
                if ([_orderDetailInfo.state isEqualToString:@"0"]) {
                    cell.orderStateLab.text =@"未付款";
                } else if ([_orderDetailInfo.state isEqualToString:@"1"]) {
                    cell.orderStateLab.text =@"已付款";
                } else if ([_orderDetailInfo.state isEqualToString:@"2"]) {
                    cell.orderStateLab.text =@"分期中";
                } else if ([_orderDetailInfo.state isEqualToString:@"3"]) {
                    cell.orderStateLab.text =@"已报道";
                } else if ([_orderDetailInfo.state isEqualToString:@"4"]) {
                    cell.orderStateLab.text =@"未付款";
                } else if ([_orderDetailInfo.state isEqualToString:@"5"]) {
                    cell.orderStateLab.text =@"审核中";
                } else if ([_orderDetailInfo.state isEqualToString:@"6"]) {
                    cell.orderStateLab.text =@"审核失败";
                } else if ([_orderDetailInfo.state isEqualToString:@"7"]) {
                    cell.orderStateLab.text =@"审核通过";
                } else if ([_orderDetailInfo.state isEqualToString:@"-1"]) {
                    cell.orderStateLab.text =@"已取消";
                } else if ([_orderDetailInfo.state isEqualToString:@"-2"]) {
                    cell.orderStateLab.text =@"支付失败";
                } else if ([_orderDetailInfo.state isEqualToString:@"-3"]) {
                    cell.orderStateLab.text =@"退款";
                } else {
                    cell.orderStateLab.text =@"未付款";
                }
                
                return cell;
            }
            else//分期支付
            {
                if ([_orderDetailInfo.state isEqualToString:@"1"]||[_orderDetailInfo.state isEqualToString:@"2"]||[_orderDetailInfo.state isEqualToString:@"3"]||[_orderDetailInfo.state isEqualToString:@"4"])
                {
                    //使用分期cell
                    FenQiOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FenQiOrderDetailCell"];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle]loadNibNamed:@"FenQiOrderDetailCell" owner:nil options:nil]lastObject];
                    }
                    cell.repayTypeLab.text = @"分期支付";
                    cell.orderMoneyLab.text = _orderDetailInfo.totalMoney;
                    cell.fenqiShouFuDetailLabel.text = _orderDetailInfo.paymentName;
                    cell.fenqiQiShuDetailLabel.text = [NSString stringWithFormat:@"%ld",_orderDetailInfo.installmentId];
                    cell.liXiDetailLabel.text = _orderDetailInfo.interest;
                    cell.percentMoneyDetailLabel.text = _orderDetailInfo.reimbursement;
                    if ([_orderDetailInfo.state isEqualToString:@"0"]) {
                        cell.orderStateLab.text =@"未付款";
                    } else if ([_orderDetailInfo.state isEqualToString:@"1"]) {
                        cell.orderStateLab.text =@"已付款";
                    } else if ([_orderDetailInfo.state isEqualToString:@"2"]) {
                        cell.orderStateLab.text =@"分期中";
                    } else if ([_orderDetailInfo.state isEqualToString:@"3"]) {
                        cell.orderStateLab.text =@"已报道";
                    } else if ([_orderDetailInfo.state isEqualToString:@"4"]) {
                        cell.orderStateLab.text =@"未付款";
                    } else if ([_orderDetailInfo.state isEqualToString:@"5"]) {
                        cell.orderStateLab.text =@"审核中";
                    } else if ([_orderDetailInfo.state isEqualToString:@"6"]) {
                        cell.orderStateLab.text =@"审核失败";
                    } else if ([_orderDetailInfo.state isEqualToString:@"7"]) {
                        cell.orderStateLab.text =@"审核通过";
                    } else if ([_orderDetailInfo.state isEqualToString:@"-1"]) {
                        cell.orderStateLab.text =@"已取消";
                    } else if ([_orderDetailInfo.state isEqualToString:@"-2"]) {
                        cell.orderStateLab.text =@"支付失败";
                    } else if ([_orderDetailInfo.state isEqualToString:@"-3"]) {
                        cell.orderStateLab.text =@"退款";
                    } else {
                        cell.orderStateLab.text =@"未付款";
                    }
                    
                    return cell;
                    
                } else {
                    static NSString * identifier = @"RepayTypeCell";
                    RepayTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.repayTypeLab.text = @"全款支付";
                    cell.orderMoneyLab.text = _orderDetailInfo.totalMoney;
                    if ([_orderDetailInfo.state isEqualToString:@"0"]) {
                        cell.orderStateLab.text =@"未付款";
                    } else if ([_orderDetailInfo.state isEqualToString:@"1"]) {
                        cell.orderStateLab.text =@"已付款";
                    } else if ([_orderDetailInfo.state isEqualToString:@"2"]) {
                        cell.orderStateLab.text =@"分期中";
                    } else if ([_orderDetailInfo.state isEqualToString:@"3"]) {
                        cell.orderStateLab.text =@"已报道";
                    } else if ([_orderDetailInfo.state isEqualToString:@"4"]) {
                        cell.orderStateLab.text =@"未付款";
                    } else if ([_orderDetailInfo.state isEqualToString:@"5"]) {
                        cell.orderStateLab.text =@"审核中";
                    } else if ([_orderDetailInfo.state isEqualToString:@"6"]) {
                        cell.orderStateLab.text =@"审核失败";
                    } else if ([_orderDetailInfo.state isEqualToString:@"7"]) {
                        cell.orderStateLab.text =@"审核通过";
                    } else if ([_orderDetailInfo.state isEqualToString:@"-1"]) {
                        cell.orderStateLab.text =@"已取消";
                    } else if ([_orderDetailInfo.state isEqualToString:@"-2"]) {
                        cell.orderStateLab.text =@"支付失败";
                    } else if ([_orderDetailInfo.state isEqualToString:@"-3"]) {
                        cell.orderStateLab.text =@"退款";
                    } else {
                        cell.orderStateLab.text =@"未付款";
                    }
                    
                    return cell;
                }
            }
        }
        //状态cell
        
        if ([_orderDetailInfo.state isEqualToString:@"0"]||[_orderDetailInfo.state isEqualToString:@"4"]) {
            //去支付
            ZhuFuBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZhuFuBtnCell"];
            if(!cell)
            {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ZhuFuBtnCell" owner:nil options:nil]lastObject];
            }
            cell.zhifuBtn.gestureRecognizers = [NSArray array];
            [cell.zhifuBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zhifuBtnClick:)]];
            return cell;
            
        } else if ([_orderDetailInfo.state isEqualToString:@"5"]) {
            //审核中
            static NSString *identify = @"PartnerTrainSubmitCell";
            PartnerTrainSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
            cell.fd_enforceFrameLayout = YES;//是Frame布局
            cell.contentString = @"分期支付审核中";
            cell.timeString = @"";
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        } else if ([_orderDetailInfo.state isEqualToString:@"6"]) {
            //审核失败
            static NSString *identify = @"PartnerTrainFailCell";
            PartnerTrainFailCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
            cell.fd_enforceFrameLayout = YES;
            cell.titleString = @"审核失败";
            cell.subTitleString = [NSString stringWithFormat:@"原因:%@",_orderDetailInfo.Remarks];
            cell.zhuanDouString = @"赚豆已退还账户";
            cell.timeString = @"";
            return cell;
        } else if ([_orderDetailInfo.state isEqualToString:@"7"]||[_orderDetailInfo.state isEqualToString:@"1"]) {
            //审核通过
            static NSString *identify = @"StagesApplySuccessCell";
            StagesApplySuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
            cell.fd_enforceFrameLayout = NO;
            cell.headLabel.text = @"审核通过";
            cell.subHeadLabel.text = @"";
            NSURL *url = [NSURL URLWithString:self.orderDetailInfo.codeUrl];
            [cell.erweimaImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"4x3比例"]];
            cell.codeLabel.text = [NSString stringWithFormat:@"%lld",_orderDetailInfo.orderNO];
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        } else {
            return [[UITableViewCell alloc]init];
        }

    }
    
    return [[UITableViewCell alloc]init];

    
//    if (_orderDetailInfo.installment==1)//已支付分期
//    {
//        if (indexPath.row == 5) {
//            static NSString *identify = @"PartnerTrainSubmitCell";
//            PartnerTrainSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
//            cell.fd_enforceFrameLayout = YES;//是Frame布局
//            cell.contentString = @"分期支付成功";
//            cell.timeString = @"";
//            cell.backgroundColor = [UIColor clearColor];
//            return cell;
//        }
//    }
//    
//    //全款并且已支付
//    if (_orderDetailInfo.payType==1 &&[_orderDetailInfo.state isEqualToString:@"已付款"]) {
//       
//        if (indexPath.row == 5) {
//            static NSString *identify = @"PartnerTrainSubmitCell";
//            PartnerTrainSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
//            cell.fd_enforceFrameLayout = YES;//是Frame布局
//            cell.contentString = @"全款支付成功";
//            cell.timeString = @"";
//            cell.backgroundColor = [UIColor clearColor];
//            return cell;
//        }
//    }
    
    //已取消
    /*
    if ([_orderDetailInfo.state isEqualToString:@"-1"]) {
        
        if (indexPath.row == 5) {
            static NSString *identify = @"PartnerTrainFailCell";
            PartnerTrainFailCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
            cell.fd_enforceFrameLayout = YES;
            cell.titleString = @"已取消";
            cell.subTitleString = @"原因:教练确认超时";
            cell.zhuanDouString = @"赚豆已退还账户";
            cell.timeString = @"";
            return cell;

        }
    }
     */
    /*
    NSString *str = @"";
    
    if ([_orderDetailInfo.state isEqualToString:@"0"]) {
        str = @"未付款";
    }
    else if ([_orderDetailInfo.state isEqualToString:@"1"]) {
        str = @"已付款";
    }
    else if ([_orderDetailInfo.state isEqualToString:@"2"]) {
        str = @"分期中";
    }
    else if ([_orderDetailInfo.state isEqualToString:@"3"]) {
        str = @"已报道";
    }
    else if ([_orderDetailInfo.state isEqualToString:@"4"]) {
        str = @"未付款";
    }
    else if ([_orderDetailInfo.state isEqualToString:@"5"]) {
        str = @"审核中";
    }
    else if ([_orderDetailInfo.state isEqualToString:@"6"]) {
        str = @"审核失败";
    }
    else if ([_orderDetailInfo.state isEqualToString:@"-1"]) {
        str = @"已取消";
    }
    else if ([_orderDetailInfo.state isEqualToString:@"-2"]) {
        str = @"支付失败";
    }
    else if ([_orderDetailInfo.state isEqualToString:@"-3"]) {
        str = @"退款";
    }
    else
    {
        str = @"未付款";
    }
     */
//    static NSString *identify = @"PartnerTrainSubmitCell";
//    PartnerTrainSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
//    cell.fd_enforceFrameLayout = YES;//是Frame布局
//    cell.contentString = _orderDetailInfo.state;
//    cell.timeString = @"";
//    cell.backgroundColor = [UIColor clearColor];
//    return cell;
    
   
    /*
    if (indexPath.row == 6) {
        static NSString *identify = @"PartnerTrainWaitCell";
        PartnerTrainWaitCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        cell.fd_enforceFrameLayout = YES;//是Frame布局
        if ([_detailsModel.examine isEqualToString:@"0"]) { //未审核
            cell.contentString = @"等待教练确认......";
        }else if ([_detailsModel.examine isEqualToString:@"0"]){//通过
            cell.contentString = @"";
        }else if ([_detailsModel.examine isEqualToString:@"0"]){//未通过
            cell.contentString = @"";
        }
        
        return cell;
        
    }if (indexPath.row == 7) {
        static NSString * identifier = @"RepaySuccessCell";
        
        RepaySuccessCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.stateLab.text = @"恭喜您，还款成功";
        cell.remindLab.text = @"(每月20日还款)";
        cell.timeLab.text= @"";
        return cell;
        
    }
    else {

        static NSString *identify = @"PartnerTrainFailCell";
        PartnerTrainFailCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        cell.fd_enforceFrameLayout = YES;
        cell.titleString = @"预约失败";
        cell.subTitleString = @"原因:教练确认超时";
        cell.zhuanDouString = @"赚豆已退还账户";
        cell.timeString = @"";
        return cell;
    }
     */
    
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.orderDetailInfo.orderType == 5) {//是学时陪练订单
            return 230;
        }
        if (self.orderDetailInfo.orderType == 3) {//私人订制订单
            return 105;
        }
        return 145;
    } else if (indexPath.section == 1) {
        return 50;
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0 || indexPath.row == 1){
            return 50;
        } else if (indexPath.row == 2) {
            if (_orderDetailInfo.Style == 1) {
                return 140;
            } else {
                if ([_orderDetailInfo.state isEqualToString:@"1"]||[_orderDetailInfo.state isEqualToString:@"2"]||[_orderDetailInfo.state isEqualToString:@"3"]||[_orderDetailInfo.state isEqualToString:@"4"])
                {
                    //是分期cell
                    return 220;
                } else {
                    return 140;
                }
            }
        } else if (indexPath.row == 3) {
            if ([_orderDetailInfo.state isEqualToString:@"0"]||[_orderDetailInfo.state isEqualToString:@"4"]) {
                //未付款
                return 50;
            } else if ([_orderDetailInfo.state isEqualToString:@"5"]) {
                //审核中
                return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainSubmitCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainSubmitCell * cell) {
                    cell.fd_enforceFrameLayout = YES;
                    cell.contentString = @"分期支付审核中";
                    cell.timeString = @"";
                    
                }];
            } else if ([_orderDetailInfo.state isEqualToString:@"6"]) {
                //审核失败
                return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainFailCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainFailCell * cell) {
                    cell.fd_enforceFrameLayout = YES;
                    cell.titleString = @"审核失败";
                    cell.subTitleString = _orderDetailInfo.Remarks;
                    cell.zhuanDouString = @"赚豆已退还账户";
                    cell.timeString = @"";
                }];
            } else if ([_orderDetailInfo.state isEqualToString:@"7"]) {
                //审核通过
                CGFloat height =  [tableView fd_heightForCellWithIdentifier:@"StagesApplySuccessCell" cacheByIndexPath:indexPath configuration:^(StagesApplySuccessCell * cell) {
                    cell.fd_enforceFrameLayout = NO;
                    cell.headLabel.text = @"审核通过";
                    cell.subHeadLabel.text = @"";
                    NSURL *url = [NSURL URLWithString:self.orderDetailInfo.codeUrl];
                    [cell.erweimaImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"4x3比例"]];
                    cell.codeLabel.text = [NSString stringWithFormat:@"%lld",_orderDetailInfo.orderNO];
                    cell.backgroundColor = [UIColor clearColor];
                }];
                
                return height;
            } else {
                return CGFLOAT_MIN;
            }
        }
        
    }


    /*
    if (indexPath.row == 6) {
        return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainWaitCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainWaitCell * cell) {
            cell.fd_enforceFrameLayout = YES;
            cell.contentString = @"等待教练确认......";
        }];
    }

    if (indexPath.row == 7) {

        return [tableView fd_heightForCellWithIdentifier:@"RepaySuccessCell" cacheByIndexPath:indexPath configuration:^(RepaySuccessCell * cell) {
            
        }];
    }
    else
    {
        return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainFailCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainFailCell * cell) {
            cell.fd_enforceFrameLayout = YES;
            cell.titleString = @"预约失败";
            cell.subTitleString = @"原因:教练确认超时";
            cell.zhuanDouString = @"赚豆已退还账户";
            cell.timeString = @"";
            
        }];
        
    }
    */
    
    return 0;
}

-(void)zhifuBtnClick:(UITapGestureRecognizer *)tap {
    [self pressCurrentCellrepaymentBtn];
}

#pragma mark --CurrentRepaymentCellDelegate
- (void)pressCurrentCellrepaymentBtn {
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

- (void)pressPayBtn:(UIButton *)sender {
    [self.grayBackBtn removeFromSuperview];
    
    NSInteger payType = 0;
    switch (sender.tag) {
        case 1000:
        {
            NSLog(@"点击了微信");
            payType = 3;
            [self.hudManager showNormalStateSVHUDWithTitle:nil];

            NSString *url = self.interfaceManager.payOrder;
            NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
            paramDict[@"uid"] = kUid;
            paramDict[@"orderId"] = @(self.orderDetailInfo.orderId);
            NSString *time = [HttpParamManager getTime];
            paramDict[@"time"] = time;
            paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/pay" time:time];
            paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
            paramDict[@"payType"] = @(payType);

            
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
                } else {
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

            NSString *url = self.interfaceManager.payOrder;
            NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
            paramDict[@"uid"] = kUid;
            paramDict[@"orderId"] = @(self.orderDetailInfo.orderId);
            NSString *time = [HttpParamManager getTime];
            paramDict[@"time"] = time;
            paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/pay" time:time];
            paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
            paramDict[@"payType"] = @(payType);
            
            [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                HJLog(@">>>%@",dict);
                NSInteger code = [dict[@"code"] integerValue];
                NSString * msg = dict[@"msg"];
                if (code == 1) {
                    
                    [self.hudManager dismissSVHud];
                    
                    NSDictionary * infoDict = [dict objectForKey:@"info"];
                    
                    NSString *jsonString = infoDict[@"content"];
                    
                    [[AlipaySDK defaultService] payOrder:jsonString fromScheme:@"alipaySDK" callback:^(NSDictionary *resultDic) {
                        
                        NSLog(@"开始确认支付状态 %@",resultDic[@"resultStatus"]);
                        if ([resultDic[@"resultStatus"]isEqualToString:@"9000"])//成功
                        {
                            //支付结果回写
                            [self.hudManager showNormalStateSVHUDWithTitle:nil];
                            NSString * url = self.interfaceManager.payResultUrl;
                            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
                            paramDict[@"orderId"] = @(self.orderDetailInfo.orderId);
                            paramDict[@"uid"] = kUid;
                            NSString * time = [HttpParamManager getTime];
                            paramDict[@"time"] = time;
                            paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/payResult" time:time addExtraStr:[NSString stringWithFormat:@"%lld",self.orderDetailInfo.orderId]];
                            paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
                            paramDict[@"totalMoney"] = self.orderDetailInfo.totalMoney;
                            paramDict[@"result"] = @"success";
                            
                            paramDict[@"payType"] = @(self.orderDetailInfo.payType);
                            paramDict[@"beansConsumption"] = @(self.orderDetailInfo.mortgageBean);
                            paramDict[@"orderType"] = @(self.orderDetailInfo.orderType);
                            
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
                                        if (self.orderDetailInfo.orderType == 3) {
                                            paySuccess.type = @"1";
                                        } else {
                                            paySuccess.type = @"2";
                                        }
                                        paySuccess.orderId = self.orderDetailInfo.orderId;
                                        [self.navigationController pushViewController:paySuccess animated:YES];
                                    });
                                    
                                } else {
                                    [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
                                }
                                
                            } failed:^(NSError *error) {
                                [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
                            }];
                            
                        } else {
                            
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
                } else {
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

- (void)cancelBtnClick {
    [self.grayBackBtn removeFromSuperview];
}

- (void)createNavigation {
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:@"订单详情"];
}

- (void)leftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
