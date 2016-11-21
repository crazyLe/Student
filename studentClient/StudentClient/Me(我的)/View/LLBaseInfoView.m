//
//  LLBaseInfoView.m
//  学员端
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLBaseInfoView.h"

@implementation LLBaseInfoView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
        [self setConstraints];
        [self setAttributes];
    }
    return self;
}

- (void)setUI
{
    _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_headBtn];
    [_headBtn setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
    
    _nameLbl = [UILabel new];
    [self addSubview:_nameLbl];
    
    
    _infoLbl = [UILabel new];
    [self addSubview:_infoLbl];
    
    _bgView  = [UIView new];
    [self addSubview:_bgView];
    
    _studentIdLbl = [UILabel new];
    [_bgView addSubview:_studentIdLbl];
}

- (void)setConstraints
{
    WeakObj(_headBtn)
    WeakObj(_nameLbl)
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.height.offset(68*kHeightScale);
    }];
    
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headBtnWeak.mas_bottom).offset(5*kHeightScale);
        make.centerX.equalTo(_headBtnWeak);
        make.width.offset(kScreenWidth*0.5);
        make.height.offset(20*kHeightScale);
    }];
    
    [_infoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headBtnWeak);
        make.top.equalTo(_nameLblWeak.mas_bottom).offset(4*kHeightScale);
        make.width.equalTo(_nameLblWeak);
        make.height.equalTo(_nameLblWeak).multipliedBy(0.6);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.height.offset(32*kHeightScale);
    }];
    
    [_studentIdLbl  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.offset(0);
        make.left.offset(10);
    }];
    
}

- (void)setAttributes
{
    _headBtn.layer.masksToBounds = YES;
    _headBtn.layer.borderWidth = 3.0f;
    _headBtn.layer.borderColor = [UIColor colorWithHexString:@"ffffff" alpha:0.08f].CGColor;
    
    _nameLbl.textAlignment = NSTextAlignmentCenter;
    _nameLbl.textColor = [UIColor whiteColor];
    if (!kLoginStatus) {
        _nameLbl.text = @"请先登录";
    }
    _infoLbl.textColor = [UIColor colorWithHexString:@"ffffff" alpha:0.5f];
    _infoLbl.font = kFont10;
    _infoLbl.textAlignment = NSTextAlignmentCenter;
    
    _bgView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.3f];
    
    _studentIdLbl.textColor = [UIColor colorWithHexString:@"ffffff" alpha:0.3f];
    _studentIdLbl.font = kFont11;
    _studentIdLbl.alpha = 0.3f;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _headBtn.layer.cornerRadius = _headBtn.frame.size.width/2;
    _headBtn.layer.borderWidth = 3.0f;
    _headBtn.layer.borderColor = [UIColor colorWithHexString:@"ffffff" alpha:0.1f].CGColor;
}

@end
