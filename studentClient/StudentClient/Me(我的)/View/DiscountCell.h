//
//  DiscountCell.h
//  学员端
//
//  Created by gaobin on 16/7/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *discountTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *voucherLab;
@property (weak, nonatomic) IBOutlet UILabel *detailVoucherLab;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@end
