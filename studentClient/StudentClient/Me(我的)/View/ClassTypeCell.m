//
//  ClassTypeCell.m
//  学员端
//
//  Created by gaobin on 16/7/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "ClassTypeCell.h"

@implementation ClassTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _classTypeTitleLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _classTypeLab.textColor = [UIColor colorWithHexString:@"#666666"];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#ececec"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
