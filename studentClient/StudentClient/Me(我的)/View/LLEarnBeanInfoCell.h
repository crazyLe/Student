//
//  LLEarnBeanInfoCell.h
//  学员端
//
//  Created by apple on 16/7/23.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLLeftImgLeftLblCell.h"
#import <UIKit/UIKit.h>

@class LLEarnBeanInfoCell;

@protocol LLEarnBeanInfoCellDelegate <NSObject>

@optional

- (void)LLEarnBeanInfoCell:(LLEarnBeanInfoCell *)cell clickRechargeBtn:(UIButton *)rechargeBtn;

- (void)LLEarnBeanInfoCell:(LLEarnBeanInfoCell *)cell clickWithdrawBtn:(UIButton *)withdrawBtn;

@end

@interface LLEarnBeanInfoCell : LLLeftImgLeftLblCell

@property (nonatomic,strong) UIButton *rechargeBtn,*withdrawBtn;

@property (nonatomic,assign) id delegate;

@end
