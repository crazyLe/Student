//
//  MyOrderDetailPatnerTrainCell.m
//  学员端
//
//  Created by zuweizhong  on 16/8/24.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MyOrderDetailPatnerTrainCell.h"

@implementation MyOrderDetailPatnerTrainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    _titleLabel1.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _titleLabel2.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _titleLabel3.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _titleLabel4.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _titleLabel5.textColor = [UIColor colorWithHexString:@"#c8c8c8"];

    _detailTitleLabel1.textColor = [UIColor colorWithHexString:@"#666666"];
    _detailTitleLabel2.textColor = [UIColor colorWithHexString:@"#666666"];
    _detailTitleLabel3.textColor = [UIColor colorWithHexString:@"#666666"];
    _detailTitleLabel4.textColor = [UIColor colorWithHexString:@"#666666"];
    _detailTitleLabel5.textColor = [UIColor colorWithHexString:@"#666666"];
    
    _titleLab.textColor = [UIColor colorWithHexString:@"56affe"];
    _orderNumberLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#ececec"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
