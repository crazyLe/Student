//
//  MyVoucherCell.h
//  学员端
//
//  Created by gaobin on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyVoucherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *valueLab;
@property (weak, nonatomic) IBOutlet UILabel *voucherLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *introduceLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIButton *immediateUseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *usedImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueLabWidth;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
