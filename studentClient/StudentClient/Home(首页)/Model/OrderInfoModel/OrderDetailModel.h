//
//  OrderDetailModel.h
//  学员端
//
//  Created by zuweizhong  on 16/8/19.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderProfiles.h"
#import "ProductInfo.h"
#import "HuoDongInfo.h"
#import "CashCouponInfo.h"

@class CashCouponInfoDetail;

@interface OrderDetailModel : NSObject

@property(nonatomic,assign)long beans;

@property(nonatomic,assign)long examine;
@property(nonatomic,assign)long installment;
@property(nonatomic,assign)long installmentId;

@property(nonatomic,strong)NSString * installmentName;
@property(nonatomic,strong)NSString * installmentRatio;

@property(nonatomic,strong)NSString * interest;
@property(nonatomic,strong)NSString * offsetMoney;
@property(nonatomic,assign)long long orderId;
@property(nonatomic,assign)long long orderNO;

@property(nonatomic,strong)NSArray * orderProfiles;

@property(nonatomic,assign)int orderType;
@property(nonatomic,assign)int payType;
@property(nonatomic,assign)int paymentId;
@property(nonatomic,strong)NSString * paymentName;
@property(nonatomic,strong)NSString * paymentRatio;

@property(nonatomic,strong)CashCouponInfoDetail * cashCouponInfo;

@property(nonatomic,strong)NSArray * productInfo;

@property(nonatomic,strong)NSArray * productId;

@property(nonatomic,strong)NSString * reimbursement;

@property(nonatomic,strong)HuoDongInfo * selectActivityInfo;

@property(nonatomic,strong)NSString * state;

@property(nonatomic,strong)NSString * totalMoney;

@property(nonatomic,strong)NSString * codeUrl;

@property(nonatomic,strong)NSString * content;

@property(nonatomic,strong)NSString * Remarks;

@property(nonatomic,assign)int Style;

@property(nonatomic,assign)long long mortgageBean;

@property(nonatomic,strong)NSString * verificationCode;

@end


@interface CashCouponInfoDetail : NSObject
@property(nonatomic,assign)int idNum;
@property(nonatomic,strong)NSString * content;

@end
