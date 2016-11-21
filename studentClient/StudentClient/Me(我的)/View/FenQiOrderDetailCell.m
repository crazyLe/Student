//
//  FenQiOrderDetailCell.m
//  学员端
//
//  Created by zuweizhong  on 16/8/24.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "FenQiOrderDetailCell.h"

@implementation FenQiOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    _repayTypeTitleLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _orderMoneyTitleLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _orderStateTitleLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    
    _fenqiShouFuLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _fenqiQiShuLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _liXiLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _percentMoneyLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    
    _repayTypeLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _orderMoneyLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _orderStateLab.textColor = [UIColor colorWithHexString:@"#7ccc1e"];
    
    _fenqiShouFuDetailLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _fenqiQiShuDetailLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _liXiDetailLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _percentMoneyDetailLabel.textColor = [UIColor colorWithHexString:@"#666666"];
}

@end
