//
//  RepayTypeCell.m
//  学员端
//
//  Created by gaobin on 16/7/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "RepayTypeCell.h"

@implementation RepayTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _repayTypeTitleLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _orderMoneyTitleLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _orderStateTitleLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    
    _repayTypeLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _orderMoneyLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _orderStateLab.textColor = [UIColor colorWithHexString:@"#7ccc1e"];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
