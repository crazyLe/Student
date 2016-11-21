//
//  PartnerTrainingDetailCell1.m
//  学员端
//
//  Created by zuweizhong  on 16/7/14.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PartnerTrainingDetailCell1.h"

@implementation PartnerTrainingDetailCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageView.clipsToBounds = YES;
    
    self.iconImageView.layer.cornerRadius = self.iconImageView.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
