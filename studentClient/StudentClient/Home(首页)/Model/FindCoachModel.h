//
//  FindCoachModel.h
//  学员端
//
//  Created by 翁昌青 on 16/8/8.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindCoachModel : NSObject

//TuitionFees = 6000;
//address = "";
//addressRemark = "";
//coachsName = "";
//distance = 7076718;
//id = 13;
//imgUrl = "20160801203618829.jpg";
//installment = 0;
//orderType = 2;
//preferential = 0;
//shoolname = "\U5408\U80a5\U65b0\U5b89\U9a7e\U6821";
//tag = "";
//学费
@property(copy,nonatomic)NSString *TuitionFees;
//练车地址
@property(copy,nonatomic)NSString *address;
//练车地址备注
@property(copy,nonatomic)NSString *addressRemark;
//教练姓名
@property(copy,nonatomic)NSString *coachsName;
//据当前位置距离
@property(copy,nonatomic)NSString *distance;
//教练id
@property(copy,nonatomic)NSString *uid;
//教练头像
@property(copy,nonatomic)NSString *imgUrl;
//是否支持分期
@property(assign,nonatomic)BOOL installment;
//订单类型
@property(copy,nonatomic)NSString *orderType;
//是否优惠
@property(assign,nonatomic)BOOL preferential;
//驾校名称
@property(copy,nonatomic)NSString *shoolname;
//标签
@property(copy,nonatomic)NSArray *tag;
//班型
@property(copy,nonatomic)NSString *classname;

@property(copy,nonatomic)NSString *weburl;

@end
