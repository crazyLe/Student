//
//  StagingBillModel.h
//  学员端
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StagingBillModel : NSObject

@property (nonatomic,strong) NSString * completeCount;
@property (nonatomic,strong) NSString * id;
@property (nonatomic,strong) NSString * installmentCount;
@property (nonatomic,strong) NSString * installmentMoney;
@property (nonatomic,strong) NSString * interest;
@property (nonatomic,strong) NSString * isReimbursement;
@property (nonatomic,strong) NSString * proportion;
@property (nonatomic,strong) NSString * reimbursement;
@property (nonatomic,strong) NSString * remainingBeans;
@property (nonatomic,strong) NSString * thisMonthMoney;
@property (nonatomic,strong) NSString * totalMoney;
@property (nonatomic,strong) NSString * orderType;

@end
