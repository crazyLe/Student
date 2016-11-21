//
//  LLEarnBeanInfoCell.m
//  学员端
//
//  Created by apple on 16/7/23.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLEarnBeanInfoCell.h"

@implementation LLEarnBeanInfoCell

- (void)setUI
{
    [super setUI];
    
    _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_rechargeBtn];
    
    _withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_withdrawBtn];
}

- (void)setContraints
{
    [super setContraints];
    
    WeakObj(_withdrawBtn)
    [_withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15*kWidthScale);
        make.centerY.offset(0);
        make.width.offset(45*kWidthScale);
        make.height.offset(25*kHeightScale);
    }];
    
    [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_withdrawBtnWeak.mas_left).offset(-6*kWidthScale);
        make.width.centerY.height.equalTo(_withdrawBtnWeak);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    [_rechargeBtn setBackgroundColor:[UIColor colorWithHexString:@"5bb7ff"]];
    [_rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rechargeBtn.titleLabel.font = kFont13;
    _rechargeBtn.layer.cornerRadius = 2.5f;
    _rechargeBtn.layer.masksToBounds = YES;
    _rechargeBtn.layer.borderColor = [UIColor colorWithHexString:@"5bb7ff"].CGColor;
    _rechargeBtn.layer.borderWidth = 1.0f;
    [_rechargeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _rechargeBtn.tag  = 10;
    
    [_withdrawBtn setBackgroundColor:[UIColor whiteColor]];
    [_withdrawBtn setTitleColor:[UIColor colorWithHexString:@"5bb7ff"] forState:UIControlStateNormal];
    _withdrawBtn.titleLabel.font = _rechargeBtn.titleLabel.font;
    _withdrawBtn.layer.cornerRadius = _rechargeBtn.layer.cornerRadius;
    _withdrawBtn.layer.masksToBounds = _rechargeBtn.layer.masksToBounds;
    _withdrawBtn.layer.borderColor = _rechargeBtn.layer.borderColor;
    _withdrawBtn.layer.borderWidth = _rechargeBtn.layer.borderWidth;
    [_withdrawBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _withdrawBtn.tag  = 20;
}

- (void)clickBtn:(UIButton *)btn
{
    if (btn.tag == 10) {
        if (_delegate && [_delegate respondsToSelector:@selector(LLEarnBeanInfoCell:clickRechargeBtn:)]) {
            [_delegate LLEarnBeanInfoCell:self clickRechargeBtn:btn];
        }
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(LLEarnBeanInfoCell:clickWithdrawBtn:)]) {
            [_delegate LLEarnBeanInfoCell:self clickWithdrawBtn:btn];
        }
    }
}

@end
