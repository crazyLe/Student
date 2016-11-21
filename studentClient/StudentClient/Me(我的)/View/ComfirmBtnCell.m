//
//  ComfirmBtnCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "ComfirmBtnCell.h"

@implementation ComfirmBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = BG_COLOR;
    self.comfirmBtn.layer.cornerRadius = 20.0f;
    self.comfirmBtn.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)comfirmBtnClick:(id)sender {
}
@end
