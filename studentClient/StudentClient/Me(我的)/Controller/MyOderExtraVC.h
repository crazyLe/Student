//
//  MyOderExtraVC.h
//  学员端
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderInfoModel.h"
@interface MyOderExtraVC : BaseViewController

@property (nonatomic, copy) NSString * orderIdStr;

@property(nonatomic,strong)OrderInfoModel *orderInfoModel;

//订单类型 1驾校班型报名 2教练班型报名 3私人订制 4考时陪练 5学时陪练 6考场订单
@property(nonatomic,assign)int  orderType;


@end
