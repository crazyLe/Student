//
//  PaySuccessController.h
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

@interface PaySuccessController : BaseViewController
/**
 *  type等于1是私人定制
 */
@property(nonatomic,strong)NSString * type;
/**
 *  支付数据
 */
@property(nonatomic,strong)NSDictionary * resultDict;
/**
 *  订单编号
 */
@property(nonatomic,assign)long long orderId;


@end
