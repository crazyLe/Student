//
//  LLEarnBeansCell.h
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLEarnBeansCell;

@protocol LLEarnBeansCellDelegate <NSObject>

-(void)earnBeansCell:(LLEarnBeansCell *)cell didClickRechargeBtnWithDict:(NSDictionary *)dict;

-(void)earnBeansCell:(LLEarnBeansCell *)cell didClickWithdrawBtnWithDict:(NSDictionary *)dict;

-(void)earnBeansCell:(LLEarnBeansCell *)cell didClickRecordBtnWithDict:(NSDictionary *)dict;

-(void)earnBeansCell:(LLEarnBeansCell *)cell didClickHelpBtnWithDict:(NSDictionary *)dict;

-(void)earnBeansCell:(LLEarnBeansCell *)cell didClickRuleBtnWithDict:(NSDictionary *)dict;

@end

@interface LLEarnBeansCell : SuperTableViewCell

@property (nonatomic,strong) UIButton *headBtn,*rechargeBtn,*withdrawBtn,*recordBtn,*ruleBtn,*helpBtn;

@property (nonatomic,strong) UILabel *nameLbl;

@property(nonatomic,weak)id<LLEarnBeansCellDelegate> delegate;

@property(nonatomic,strong)NSMutableDictionary * userInfoDict;

@end
