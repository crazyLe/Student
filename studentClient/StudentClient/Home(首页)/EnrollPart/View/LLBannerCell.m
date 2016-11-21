//
//  LLBannerCell.m
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLBannerCell.h"

@implementation LLBannerCell

- (void)setUI
{
    _flagImgView = [UIImageView new];
    [self.contentView addSubview:_flagImgView];
    
    _titleLbl = [UILabel new];
    [self.contentView addSubview:_titleLbl];
    
    _rightBtn = [LLButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_rightBtn];
    
    _bannerBtn = [[UIImageView alloc] init];
    [self.contentView addSubview:_bannerBtn];
}

- (void)setContraints
{
    WeakObj(_flagImgView)
    WeakObj(_titleLbl)
    [_flagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(5);
        make.top.offset(15);
        make.height.offset(18);
    }];
    
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_flagImgViewWeak.mas_right).offset(5);
        make.top.equalTo(_flagImgViewWeak).offset(-7);
        make.width.offset(40);
        make.height.offset(30);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.width.offset(120);
        make.height.top.equalTo(_titleLblWeak);
    }];
    
    [_bannerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLblWeak);
        make.top.equalTo(_titleLblWeak.mas_bottom);
        make.right.offset(-10);
        make.bottom.offset(5);
    }];
}

- (void)setAttributes
{
    _flagImgView.backgroundColor = [UIColor colorWithHexString:@"5cb6ff"];
    
    _titleLbl.textColor = [UIColor colorWithHexString:@"666666"];
    _titleLbl.font = [UIFont systemFontOfSize:16];
    
    [_rightBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
//    _bannerBtn.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_rightBtn layoutButtonWithEdgeInsetsStyle:LLButtonStyleTextLeft imageTitleSpace:3];
}

@end
