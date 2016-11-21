//
//  RecordModel.h
//  学员端
//
//  Created by zuweizhong  on 16/8/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject

@property(nonatomic,strong)NSString * beans;

@property(nonatomic,assign)int money;

@property(nonatomic,assign)int pay_status;

@property(nonatomic,strong)NSString * remarks;

@property(nonatomic,assign)int state;

@property(nonatomic,assign)int statetime;

@property(nonatomic,assign)long long time;

@property(nonatomic,strong)NSString * timeStr;

@property(nonatomic,strong)NSString * month;


@end
