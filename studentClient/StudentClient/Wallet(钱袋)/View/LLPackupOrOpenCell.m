//
//  LLPackupOrOpenCell.m
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLPackupOrOpenCell.h"

@implementation LLPackupOrOpenCell

- (void)setUI
{
    _packOrOpenBtn = [LLButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_packOrOpenBtn];
}

- (void)setContraints
{
    [_packOrOpenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)setAttributes
{
    [_packOrOpenBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-teacher-downarrowbg"] forState:UIControlStateNormal];
    [_packOrOpenBtn setImage:[UIImage imageNamed:@"iconfont-teacher-downarrow"] forState:UIControlStateNormal];
    [_packOrOpenBtn setImage:[UIImage imageNamed:@"iconfont-iconfontop"] forState:UIControlStateSelected];
    [_packOrOpenBtn setTitle:@"更多筛选" forState:UIControlStateNormal];
    [_packOrOpenBtn setTitle:@"收起筛选" forState:UIControlStateSelected];
    [_packOrOpenBtn setTitleColor:[UIColor colorWithHexString:@"cfbb9b"] forState:UIControlStateNormal];
    [_packOrOpenBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_packOrOpenBtn layoutButtonWithEdgeInsetsStyle:_packOrOpenBtn.selected ? LLButtonStyleTextBottom : LLButtonStyleTextTop imageTitleSpace:5];
}

- (void)clickBtn:(LLButton *)btn
{
    btn.selected = !btn.selected;
    [self setNeedsLayout];
    [self.layer layoutIfNeeded];
    
    if (_delegate && [_delegate respondsToSelector:@selector(LLPackupOrOpenCell:clickBtn:)]) {
        [_delegate LLPackupOrOpenCell:self clickBtn:btn];
    }
}

@end
