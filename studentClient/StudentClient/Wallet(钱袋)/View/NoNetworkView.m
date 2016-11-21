//
//  NoNetWorkView.m
//  wills
//
//  Created by ai_ios on 16/5/19.
//  Copyright © 2016年 ai_ios. All rights reserved.
//

#import "NoNetworkView.h"
#define TextBlackColor  RGBCOLOR(51, 51, 51) //黑色字体颜色
#define TextGrayColor RGBCOLOR(165, 165, 165)  //灰色字体颜色

@interface NoNetworkView () {
    
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UILabel*_detailLabel;
    UIButton *_reloadButton;
}

@end

@implementation NoNetworkView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BG_COLOR;
        [self initSubviews];
    }
    return self ;
}

- (void)initSubviews
{
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"亲，网络请求失败";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = TextGrayColor;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(@20);
    }];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_wifi"]] ;
    [self addSubview:_imageView];
    CGSize imgSize = [UIImage imageNamed:@"icon_wifi"].size ;
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(imgSize);
        make.bottom.equalTo(_titleLabel.mas_top).offset(-10);
        
    }];

    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.text = @"请检查您的网络";
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.textColor = TextGrayColor;
    _detailLabel.font = Font14;
    [self addSubview:_detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.height.equalTo(@20);
    }];
    
    _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _reloadButton.titleLabel.font = Font14;
    [_reloadButton setTitle:@"重新加载" forState:UIControlStateNormal];
    [_reloadButton setBackgroundImage:[UIImage imageNamed:@"ico_buttonBg"] forState:UIControlStateNormal];
    [_reloadButton addTarget:self action:@selector(reloadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_reloadButton];
    [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detailLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(170, 44));
    }];
    
}

- (void)reloadAction:(UIButton *)sender
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(reloadButtonClick)]) {
        [self.delegate reloadButtonClick];
    }
}


@end
