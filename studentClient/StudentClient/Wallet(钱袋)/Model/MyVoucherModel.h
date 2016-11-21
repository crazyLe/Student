//
//  MyVoucherModel.h
//  学员端
//
//  Created by gaobin on 16/8/4.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyVoucherModel : NSObject


@property (nonatomic, assign) int sid;
@property (nonatomic, assign) long long add_time; //领取时间
@property (nonatomic, assign) BOOL state; //是否使用
@property (nonatomic, assign) int delflag; //删除，2是3否
@property (nonatomic, assign) long long end_time; //有限期至
@property (nonatomic, copy) NSString * pay_time; //优惠券支付时间
@property (nonatomic, copy) NSString * title; //代金券标题
@property (nonatomic, assign) int money;
@property (nonatomic, copy) NSString * sendname;

@end
