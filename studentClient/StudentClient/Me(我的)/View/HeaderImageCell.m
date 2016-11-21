//
//  HeaderImageCell.m
//  学员端
//
//  Created by gaobin on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "HeaderImageCell.h"

@implementation HeaderImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _headerImgView.layer.cornerRadius = _headerImgView.size.width/2;
    _headerImgView.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
