//
//  OrderEarnBeanCell.h
//  学员端
//
//  Created by gaobin on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderEarnBeanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *earnBeanTitleLab;
@property (weak, nonatomic) IBOutlet UIImageView *beanImgView;
@property (weak, nonatomic) IBOutlet UILabel *offsetMoneyLab;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UITextField *textView;

@end
