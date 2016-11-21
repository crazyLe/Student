//
//  MobileModifyCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MobileModifyCell.h"

@implementation MobileModifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.sendBtnWidthConstraint.constant = 70;
    self.sendBtn.layer.cornerRadius = 5.0;
    self.sendBtn.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sendBtnClick:(id)sender {
}
@end
