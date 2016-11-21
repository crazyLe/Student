//
//  LLLeftImgLeftLblCell.m
//  学员端
//
//  Created by apple on 16/7/23.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLLeftImgLeftLblCell.h"

@implementation LLLeftImgLeftLblCell

- (void)setUI
{
    _leftImgView = [UIImageView new];
    [self.contentView addSubview:_leftImgView];
    
    _leftLbl = [UILabel new];
    [self.contentView addSubview:_leftLbl];
}

- (void)setContraints
{
    WeakObj(self)
    WeakObj(_leftImgView)
    [_leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12*kWidthScale);
        make.centerY.offset(0);
        make.width.height.equalTo(selfWeak.mas_height).multipliedBy(0.3f);
    }];
    
    [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImgViewWeak.mas_right).offset(12*kWidthScale);
        make.centerY.equalTo(_leftImgViewWeak);
        make.height.equalTo(selfWeak);
        make.width.offset(150*kWidthScale);
    }];
}

- (void)setAttributes
{
    _leftLbl.textColor = [UIColor colorWithHexString:@"666666"];
    _leftLbl.font = kFont14;
}

@end
