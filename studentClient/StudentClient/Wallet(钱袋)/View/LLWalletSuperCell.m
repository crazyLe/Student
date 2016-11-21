//
//  LLWalletSuperCell.m
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLWalletSuperCell.h"

@implementation LLWalletSuperCell

- (void)setUI
{
    _bgView = [UIView new];
    [self.contentView addSubview:_bgView];
    
    _leftView = [UIView new];
    [_bgView addSubview:_leftView];
    
    _titleLbl = [UILabel new];
    [_bgView addSubview:_titleLbl];
    
    _rightBtn = [LLButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_rightBtn];
    
    [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)rightBtnClick
{
    if ([self.delegate respondsToSelector:@selector(LLStudentTaskCellDidClickRightBtn:)]) {
        [self.delegate LLStudentTaskCellDidClickRightBtn:self];
    }
}
- (void)setContraints
{
    WeakObj(_leftView)
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
    
    [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.offset(0);
        make.width.offset(5);
    }];
    
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftViewWeak.mas_right).offset(10*kWidthScale);
        make.top.offset(20);
        make.height.offset(30);
        make.width.offset(120);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5*kWidthScale);
        make.width.offset(65);
        make.height.offset(30);
        make.centerY.offset(0);
    }];
}

- (void)setAttributes
{
    self.backgroundColor = [UIColor clearColor];
    
    _bgView.backgroundColor = [UIColor whiteColor];
    
    _leftView.backgroundColor = [UIColor colorWithRed:254/255.0 green:166/255.0 blue:47/255.0 alpha:1];
    
    _titleLbl.textColor = [UIColor colorWithRed:254/255.0 green:166/255.0 blue:47/255.0 alpha:1];
    _titleLbl.font = [UIFont boldSystemFontOfSize:17*kWidthScale];
    
    [_rightBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = kFont11;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_rightBtn layoutButtonWithEdgeInsetsStyle:LLButtonStyleTextLeft imageTitleSpace:5];
}

@end
