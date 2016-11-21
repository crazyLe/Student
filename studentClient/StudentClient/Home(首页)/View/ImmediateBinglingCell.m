//
//  ImmediateBinglingCell.m
//  学员端
//
//  Created by gaobin on 16/7/15.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "ImmediateBinglingCell.h"

@implementation ImmediateBinglingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bindingBtn.layer.masksToBounds = YES;
    self.bindingBtn.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
