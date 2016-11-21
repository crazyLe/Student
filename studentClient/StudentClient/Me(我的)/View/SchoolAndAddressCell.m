//
//  SchoolAndAddressCell.m
//  学员端
//
//  Created by gaobin on 16/7/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SchoolAndAddressCell.h"

@implementation SchoolAndAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    

    _addressTitleLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _schoolTitleLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _schoolLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _addressLab.textColor = [UIColor colorWithHexString:@"#666666"];
    
    _titleLab.textColor = [UIColor colorWithHexString:@"56affe"];
    _orderNumberLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#ececec"];
}

- (void)setDetailsModel:(MyOrderDetailsModel *)detailsModel
{
    _detailsModel = detailsModel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
