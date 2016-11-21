//
//  LLLicenceTypeCell.m
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//
#define filterSelectKey(i) [NSString stringWithFormat:@"filterSelect_%d",i]

#import "LLLicenceTypeCell.h"

@implementation LLLicenceTypeCell


- (void)setUI
{
    _titleLbl = [UILabel new];
    [self.contentView addSubview:_titleLbl];
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.right.offset(0);
        make.height.offset(20);
    }];
    _titleLbl.textColor = [UIColor colorWithHexString:@"0X666666"];
    _titleLbl.font = kFont14;
    
    CGFloat topOffset = 25;
    CGFloat leftOffset = 20;
    CGFloat btnWidth = 30;
    CGFloat interval = (kScreenWidth - 2*leftOffset - btnWidth*7)/6;
    _btnArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btn];
        btn.frame = CGRectMake(leftOffset+(btnWidth+interval)*i, topOffset, btnWidth, btnWidth);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:@"0X999999"] forState:UIControlStateNormal];
        btn.tag = i+10;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchDown];
        btn.titleLabel.font = kFont12;
        btn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
        [_btnArr addObject:btn];
    }
}

- (void)clickBtn:(UIButton *)btn
{
//    for (UIButton *tempBtn in _btnArr) {
//        tempBtn.selected = NO;
//    }
//    btn.selected = YES;
    //Radio选择
    btn.selected = !btn.selected;
    for (UIButton *tempBtn in _btnArr) {
        if (tempBtn.tag != btn.tag) {
            tempBtn.selected = NO;
        }
    }
    //存储
    [_filterSelectDic setObject:btn.selected?@(btn.tag-9):@(0) forKey:filterSelectKey(2)];
}

@end
