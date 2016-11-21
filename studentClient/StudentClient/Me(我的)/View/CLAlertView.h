//
//  WithdrawViewController.m
//  学员端
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef void(^defaultBtnClicked)(UIButton *defaultBtn);

typedef void(^cancelBtnClicked)(UIButton *cancelBtn);


@interface CLAlertView : UIView


@property (nonatomic ,copy) defaultBtnClicked defaultBtnBlock;
@property (nonatomic ,copy) cancelBtnClicked cancelBtnBlock;
- (instancetype)initWithAlertViewWithTitle:(NSString *)title text:(NSString *)text DefauleBtn:(NSString *)defaultBtn cancelBtn:(NSString *)cancelBtn defaultBtnBlock:(defaultBtnClicked)defaultBlock cancelBtnBlock:(cancelBtnClicked)cancelBlock;



- (void)show;


@end
