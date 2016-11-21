//
//  RealNameHeaderCell.m
//  学员端
//
//  Created by gaobin on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "RealNameHeaderCell.h"

@implementation RealNameHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.headerImgView.layer.masksToBounds = YES;
    self.headerImgView.layer.cornerRadius = 25;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
