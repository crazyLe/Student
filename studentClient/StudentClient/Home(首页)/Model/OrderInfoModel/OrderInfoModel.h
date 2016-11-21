//
//  OrderInfoModel.h
//  学员端
//
//  Created by zuweizhong  on 16/8/17.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CashCouponInfo.h"
#import "OrderProfiles.h"
#import "Installment.h"
#import "Payment.h"
#import "ProductInfo.h"
@interface OrderInfoModel : NSObject

@property(nonatomic,assign)long beans;

@property(nonatomic,assign)CGFloat  beans_ratio;

@property(nonatomic,strong)NSArray * cashCouponInfo;

@property(nonatomic,strong)NSArray * installment;

@property(nonatomic,assign)long offsetMoney;

@property(nonatomic,strong)NSArray * orderProfiles;

@property(nonatomic,assign)int orderType;

@property(nonatomic,strong)NSArray * payment;

@property(nonatomic,strong)NSArray * productinfo;

@property(nonatomic,strong)NSString * totalMoney;


@end



