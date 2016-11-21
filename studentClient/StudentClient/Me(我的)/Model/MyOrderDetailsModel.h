//
//  MyOrderDetailsModel.h
//  学员端
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderDetailsModel : NSObject

@property (nonatomic, strong) NSDictionary * orderInfo;
@property (nonatomic, copy) NSString * beans;
@property (nonatomic, strong) NSDictionary * cashCouponInfo;
@property (nonatomic, copy) NSString * examine;
@property (nonatomic, copy) NSString * installment;
@property (nonatomic, copy) NSString * installmentId;
@property (nonatomic, copy) NSString * interest;
@property (nonatomic, copy) NSString * offsetMoney;
@property (nonatomic, copy) NSString * orderId;
@property (nonatomic, copy) NSString * orderNO;
@property (nonatomic, strong) NSArray * orderProfiles;
@property (nonatomic, copy) NSString * orderType;
@property (nonatomic, copy) NSString * payType;
@property (nonatomic, copy) NSString * paymentId;
@property (nonatomic, copy) NSArray * productId;
@property (nonatomic, copy) NSString * productInfo;
@property (nonatomic, copy) NSString * reimbursement;
@property (nonatomic, strong) NSDictionary * selectActivityInfo;
@property (nonatomic, copy) NSString * totalMoney;

@end
