//
//  DiscountCell.m
//  学员端
//
//  Created by gaobin on 16/7/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "DiscountCell.h"

@implementation DiscountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _discountTitleLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    [_voucherLab setborderWidth:1 borderColor:[UIColor colorWithHexString:@"#fd5e5b"]];
    _voucherLab.text = @"代金券";
    _voucherLab.textColor = [UIColor colorWithHexString:@"#fd5e5b"];
    _voucherLab.layer.cornerRadius = 3;
    _voucherLab.clipsToBounds = YES;
    
    _detailVoucherLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#ececec"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
