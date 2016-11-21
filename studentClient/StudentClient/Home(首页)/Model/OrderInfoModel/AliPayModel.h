//
//  AliPayModel.h
//  学员端
//
//  Created by zuweizhong  on 16/8/18.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliPayModel : NSObject


@property(nonatomic, copy) NSString * service;
@property(nonatomic, copy) NSString * partner;
@property(nonatomic, copy) NSString * seller_id;
@property(nonatomic, copy) NSString * out_trade_no;
@property(nonatomic, copy) NSString * subject;
@property(nonatomic, copy) NSString * body;
@property(nonatomic, copy) NSString * total_fee;
@property(nonatomic, copy) NSString * notify_url;
@property(nonatomic, copy) NSString * _input_charset;
@property(nonatomic, copy) NSString * payment_type;
@property(nonatomic, copy) NSString * sign;
@property(nonatomic, copy) NSString * sign_type;
@property(nonatomic, copy) NSString * success;


@end
