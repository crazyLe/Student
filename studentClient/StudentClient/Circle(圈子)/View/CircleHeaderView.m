//
//  CircleHeaderView.m
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "CircleHeaderView.h"

@implementation CircleHeaderView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleLabel.font = kFont15;
    
    self.subTitleLabel.font = kFont12;


}

@end
