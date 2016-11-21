//
//  LLEarnBeansCell.m
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#define kBtnBorderWidth LINE_HEIGHT
#define kLeftOffset 15

#import "LLEarnBeansCell.h"

@implementation LLEarnBeansCell

- (void)setUI
{
    _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_headBtn];
    
    _nameLbl = [UILabel new];
    [self.contentView addSubview:_nameLbl];
    
    _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_rechargeBtn];
    
    _withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [self.contentView addSubview:_withdrawBtn];
    
    _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_recordBtn];
    
    _ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_ruleBtn];
    
    _helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_helpBtn];
    
    [_rechargeBtn addTarget:self action:@selector(rechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_recordBtn addTarget:self action:@selector(recordBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [_ruleBtn addTarget:self action:@selector(ruleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_helpBtn addTarget:self action:@selector(helpBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [_withdrawBtn addTarget:self action:@selector(withdrawBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)recordBtnClick
{
    if ([self.delegate respondsToSelector:@selector(earnBeansCell:didClickRecordBtnWithDict:)]) {
        [self.delegate earnBeansCell:self didClickRecordBtnWithDict:self.userInfoDict];
    }

}
-(void)ruleBtnClick
{
    if ([self.delegate respondsToSelector:@selector(earnBeansCell:didClickRuleBtnWithDict:)]) {
        [self.delegate earnBeansCell:self didClickRuleBtnWithDict:self.userInfoDict];
    }
}
-(void)helpBtnClick
{
    if ([self.delegate respondsToSelector:@selector(earnBeansCell:didClickHelpBtnWithDict:)]) {
        [self.delegate earnBeansCell:self didClickHelpBtnWithDict:self.userInfoDict];
    }
}
-(void)withdrawBtnClick
{
    if ([self.delegate respondsToSelector:@selector(earnBeansCell:didClickWithdrawBtnWithDict:)]) {
        [self.delegate earnBeansCell:self didClickWithdrawBtnWithDict:self.userInfoDict];
    }
    

}
-(void)rechargeBtnClick
{
    if ([self.delegate respondsToSelector:@selector(earnBeansCell:didClickRechargeBtnWithDict:)]) {
        [self.delegate earnBeansCell:self didClickRechargeBtnWithDict:self.userInfoDict];
    }
    

}
- (void)setContraints
{
    WeakObj(self)
    WeakObj(_headBtn)
    WeakObj(_withdrawBtn)
    WeakObj(_helpBtn)
    WeakObj(_recordBtn)
    WeakObj(_rechargeBtn)
    [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(kLeftOffset);
        make.width.height.offset(60);
    }];
    
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headBtnWeak.mas_right).offset(5);
        make.top.height.equalTo(_headBtnWeak);
        make.right.equalTo(_rechargeBtnWeak.mas_left).offset(-10);
    }];
    
    [_withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.width.offset(50);
        make.height.offset(30);
        make.top.equalTo(_headBtnWeak).offset(15);
    }];
    
    [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_withdrawBtnWeak.mas_left).offset(-5);
        make.width.top.height.equalTo(_withdrawBtnWeak);
    }];
    
    [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(-kBtnBorderWidth);
        make.bottom.offset(0);
        make.width.offset(kScreenWidth/3);
        make.top.equalTo(_headBtnWeak.mas_bottom).offset(20);
    }];
    
    [_helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headBtnWeak.mas_bottom).offset(20);
        make.width.offset(kScreenWidth/3);
        make.right.equalTo(selfWeak.mas_right);
        make.bottom.offset(0);

    }];
    
    [_ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_recordBtnWeak.mas_right).offset(-kBtnBorderWidth);
        make.right.equalTo(_helpBtnWeak.mas_left).offset(kBtnBorderWidth);
        make.top.height.equalTo(_recordBtnWeak);
        make.bottom.offset(0);

    }];
}

- (void)setAttributes
{
    _headBtn.layer.masksToBounds = YES;
    
    _nameLbl.numberOfLines = 0;
    
    [_rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rechargeBtn setBackgroundColor:[UIColor colorWithHexString:@"5cb6ff"]];
    _rechargeBtn.layer.cornerRadius = 3;
    _rechargeBtn.layer.masksToBounds = YES;
    _rechargeBtn.titleLabel.font = kFont12;
    
    [_withdrawBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    _withdrawBtn.layer.cornerRadius = 3;
    _withdrawBtn.layer.masksToBounds = YES;
    _withdrawBtn.layer.borderWidth = LINE_HEIGHT;
    _withdrawBtn.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    _withdrawBtn.titleLabel.font = _rechargeBtn.titleLabel.font;
    
    for (UIButton *btn in @[_recordBtn,_ruleBtn,_helpBtn]) {
        btn.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
        btn.layer.borderWidth = kBtnBorderWidth;
        [btn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        btn.titleLabel.font = kFont12;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    }
    
    

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _headBtn.layer.cornerRadius = _headBtn.frame.size.width/2;
}


@end
