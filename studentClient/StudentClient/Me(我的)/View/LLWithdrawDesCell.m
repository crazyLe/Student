//
//  LLWithdrawDesCell.m
//  学员端
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLWithdrawDesCell.h"

@implementation LLWithdrawDesCell

#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _titleLbl = [UILabel new];
    [self.contentView addSubview:_titleLbl];
    
    _contentLbl = [UILabel new];
    [self.contentView addSubview:_contentLbl];
}

- (void)setContraints
{
    [super setContraints];
    
    WeakObj(_titleLbl)
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kWidthScale);
        make.top.offset(20*kHeightScale);
        make.height.offset(25*kHeightScale);
        make.right.offset(-20*kWidthScale);
    }];
    
    [_contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titleLblWeak);
        make.top.equalTo(_titleLblWeak.mas_bottom);
        make.height.offset(200*kHeightScale);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    _titleLbl.textColor = [UIColor colorWithHexString:@"666666"];
    _titleLbl.font = [UIFont boldSystemFontOfSize:14*kWidthScale];
    
    _contentLbl.textColor = [UIColor colorWithHexString:@"666666"];
    _contentLbl.numberOfLines = 0;
    _contentLbl.font = kFont14;
}

@end
