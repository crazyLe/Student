//
//  SystemHeaderCell.m
//  学员端
//
//  Created by zuweizhong  on 16/8/1.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SystemHeaderCell.h"

@implementation SystemHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.timeLabel.clipsToBounds = YES;
    self.timeLabel.layer.cornerRadius = 5.0f;
}

@end
