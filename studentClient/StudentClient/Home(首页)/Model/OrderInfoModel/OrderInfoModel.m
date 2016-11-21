//
//  OrderInfoModel.m
//  学员端
//
//  Created by zuweizhong  on 16/8/17.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "OrderInfoModel.h"

@implementation OrderInfoModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"orderProfiles":[OrderProfiles class],@"cashCouponInfo":[CashCouponInfo class],@"installment":[Installment class],@"payment":[Payment class],@"productinfo":[ProductInfo class]};
}

@end
