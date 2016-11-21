//
//  VouchersListModel.h
//  学员端
//
//  Created by gaobin on 16/8/4.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VouchersListModel : NSObject

@property (nonatomic, assign) int idNum;
@property (nonatomic, assign) int endTime;
@property (nonatomic, assign) int money;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * sendname;


@end
