//
//  LLLeftLblRightTFCell.m
//  学员端
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLLeftLblRightTFCell.h"

@implementation LLLeftLblRightTFCell

#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _leftLbl = [UILabel new];
    [self.contentView addSubview:_leftLbl];
    
    _rightTF = [UITextField new];
    [self.contentView addSubview:_rightTF];
    
    _accessoryImgView = [UIImageView new];
    [self.contentView addSubview:_accessoryImgView];
}

- (void)setContraints
{
    [super setContraints];
    
    WeakObj(_leftLbl)
    [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(22*kWidthScale);
//        make.top.offset(20*kHeightScale);
        make.centerY.offset(0);
        make.width.offset(80*kWidthScale);
        make.height.offset(25*kHeightScale);
    }];
    
    [_rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftLblWeak.mas_right);
        make.height.offset(32*kHeightScale);
        make.centerY.equalTo(_leftLblWeak);
        make.right.offset(-22*kWidthScale);
    }];
    
    WeakObj(_accessoryImgView)
    [_accessoryImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.bottom.offset(-5);
        make.right.offset(-20);
        make.width.equalTo(_accessoryImgViewWeak.mas_height);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    _leftLbl.textColor = [UIColor colorWithHexString:@"666666"];
    _leftLbl.font = kFont14;
    
    _rightTF.borderStyle = UITextBorderStyleRoundedRect;
    _rightTF.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    
    _accessoryImgView.contentMode = UIViewContentModeCenter;
}

@end
