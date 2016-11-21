//
//  RechargeCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJTextField.h"

typedef void(^chongzhiClickBlock)(int money);


@interface RechargeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *tishiLabel;
@property (weak, nonatomic) IBOutlet HJTextField *rechargeTextF;
@property (weak, nonatomic) IBOutlet UILabel *zhuanDouLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmRechargeBtn;
- (IBAction)confirmRechargeBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *zhuanDouYuErLabel;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property(copy,nonatomic)chongzhiClickBlock chongzhi;

@end
