//
//  SafeRightsCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SafeRightsCell.h"

@implementation SafeRightsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SafeRightModel *)model
{
    _model = model;
    _contentLabel.text = _model.descible;
    _phoneLabel.text = _model.tel;
}

- (IBAction)clickPhoneBtn:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSafeRightsCellPhoneBtn:)])
    {
        [self.delegate clickSafeRightsCellPhoneBtn:_model.tel];
    }
}

@end
