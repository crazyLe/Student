//
//  MsgNotifiCell.m
//  学员端
//
//  Created by zuweizhong  on 16/8/1.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MsgNotifiCell.h"
@implementation MsgNotifiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.badgeView.layer.cornerRadius = self.badgeView.width/2;
    self.badgeView.clipsToBounds = YES;
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
