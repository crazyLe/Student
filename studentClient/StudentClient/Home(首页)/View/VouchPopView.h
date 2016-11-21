//
//  VouchPopView.h
//  学员端
//
//  Created by zuweizhong  on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VouchersListModel.h"

@class VouchPopView;
@protocol VouchPopViewDelegate <NSObject>

-(void)vouchPopViewDidClickKnowBtn:(VouchPopView *)popView;

@end
@interface VouchPopView : UIView


@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverSchoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *knowBtn;
- (IBAction)knowBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property(nonatomic,weak)id<VouchPopViewDelegate> delegate;
@property (nonatomic, strong) VouchersListModel * vouchers;


@end
