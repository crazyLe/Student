//
//  OrderDetailModel.m
//  学员端
//
//  Created by zuweizhong  on 16/8/19.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"productInfo":[ProductInfo class],@"orderProfiles":[OrderProfiles class]};
}
@end


@implementation CashCouponInfoDetail

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"idNum":@"id"};
}

@end