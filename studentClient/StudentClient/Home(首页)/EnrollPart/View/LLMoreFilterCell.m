//
//  LLMoreFilterCell.m
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//
#define filterSelectKey(i) [NSString stringWithFormat:@"filterSelect_%d",i]

#import "LLMoreFilterCell.h"

@implementation LLMoreFilterCell

- (void)setUI
{
    CGFloat topOffset = 35;
    CGFloat sideOffset = 20;
    CGFloat btnWidth = 85*kWidthScale;
    CGFloat interval = (kScreenWidth - btnWidth*3 - sideOffset*2)/2;
    CGFloat btnVerticalInterval = 10;
    CGFloat btnHeight = 30*kWidthScale;
    
    _titleLbl = [UILabel new];
    [self.contentView addSubview:_titleLbl];
    _titleLbl.font = kFont14;
    
    _helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_helpBtn];
    [_helpBtn setTitleColor:[UIColor colorWithHexString:@"0Xff7572"] forState:UIControlStateNormal];
    _helpBtn.titleLabel.font = kFont11;
    
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(sideOffset);
        make.top.offset(5);
        make.height.offset(25);
    }];
    
    WeakObj(_titleLbl)
    [_helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLblWeak.mas_right);
        make.right.offset(0);
        make.top.height.equalTo(_titleLblWeak);
    }];
    
    _filterBtnArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btn];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:@"0X999999"] forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 10;
        btn.titleLabel.font = kFont12;
        [btn setBackgroundImage:[UIImage imageNamed:@"iconfont-teacher-bluebtn"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"iconfont-teacher-graybtn"] forState:UIControlStateNormal];
        btn.tag = i + 10;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(sideOffset+(btnWidth+interval)*(i%3), topOffset+(btnVerticalInterval+btnHeight)*(i/3), btnWidth, btnHeight);
        
        [_filterBtnArr addObject:btn];
    }
}

- (void)setContentWithType:(LLMoreFilterCellType)type
{
    _type = type;
    
}

- (void)clickBtn:(UIButton *)btn
{
    if (_type == LLMoreFilterCellTypeRadio) {
//        for (UIButton *tempBtn in _filterBtnArr) {
//            tempBtn.selected  = NO;
//        }
//        btn.selected = YES;
        btn.selected = !btn.selected;
        for (UIButton *tempBtn in _filterBtnArr) {
            if (tempBtn.tag != btn.tag) {
                tempBtn.selected = NO;
            }
        }
        //存储
        [_filterSelectDic setObject:btn.selected?@(btn.tag-9):@(0) forKey:filterSelectKey((int)(3+_indexPath.row))];
    }
    else
    {
        btn.selected = !btn.selected;
        NSMutableArray *mutArr = _filterSelectDic[filterSelectKey((int)(3+_indexPath.row))];
        if (btn.selected) {
            [mutArr addObject:@(btn.tag-9)];
        }
        else
        {
            [mutArr removeObject:@(btn.tag-9)];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
