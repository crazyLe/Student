//
//  LLExtraMoneyCell.m
//  Coach
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLExtraMoneyCell.h"

@implementation LLExtraMoneyCell

#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _dateLbl = [UILabel new];
    [self.contentView addSubview:_dateLbl];
    
    _timeLbl = [UILabel new];
    [self.contentView addSubview:_timeLbl];
    
    _beansNumLbl = [UILabel new];
    [self.contentView addSubview:_beansNumLbl];
    
    _classLbl = [UILabel new];
    [self.contentView addSubview:_classLbl];
    
    _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_headBtn];
}

- (void)setContraints
{
    [super setContraints];
    
    WeakObj(self)
    WeakObj(_dateLbl)
    WeakObj(_headBtn)
    WeakObj(_beansNumLbl)
    [_dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18*kWidthScale);
        make.bottom.equalTo(selfWeak.mas_centerY);
        make.width.offset(40*kWidthScale);
        make.height.offset(20);
    }];
    
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_dateLblWeak.mas_bottom);
        make.width.height.centerX.equalTo(_dateLblWeak);
    }];
    
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_dateLblWeak.mas_right).offset(10);
        make.centerY.offset(0);
        make.width.height.equalTo(selfWeak.mas_height).multipliedBy(0.5);
    }];
    
    [_beansNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headBtnWeak.mas_right).offset(26);
        make.bottom.height.equalTo(_dateLblWeak);
        make.right.offset(0);
    }];
    
    [_classLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.equalTo(_beansNumLblWeak);
        make.top.equalTo(_beansNumLblWeak.mas_bottom);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    _dateLbl.textColor = [UIColor colorWithHexString:@"ff5d5d"];
    _dateLbl.font = kFont15;
    
    _timeLbl.textColor = _dateLbl.textColor;
    _timeLbl.font = kFont12;
    
    _beansNumLbl.textColor = [UIColor colorWithHexString:@"333333"];
    _beansNumLbl.font = kFont16;
    
    _classLbl.textColor = [UIColor colorWithHexString:@"666666"];
    _classLbl.font = kFont15;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _headBtn.layer.cornerRadius = _headBtn.frame.size.width/2;
}

@end
