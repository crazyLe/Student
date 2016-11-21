//
//  LLPromptCell.m
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#define kSideOffset 20

#import "LLPromptCell.h"

@implementation LLPromptCell

- (void)setUI
{
    _promptLbl = [UILabel new];
    [self.contentView addSubview:_promptLbl];
}

- (void)setContraints
{
    WeakObj(self)
    [_promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kSideOffset);
        make.right.offset(-kSideOffset);
        make.centerY.equalTo(selfWeak);
        make.height.equalTo(selfWeak).multipliedBy(0.5);
    }];
    
}

- (void)setAttributes
{
    _promptLbl.textColor = [UIColor colorWithHexString:@"0Xb4a47d"];
    _promptLbl.backgroundColor = [UIColor colorWithHexString:@"0Xfefdf4"];
    _promptLbl.layer.borderColor = [UIColor colorWithHexString:@"0Xe3dcc2"].CGColor;
    _promptLbl.layer.borderWidth = 1.0f;
    _promptLbl.layer.cornerRadius = 4;
    _promptLbl.layer.masksToBounds = YES;
    _promptLbl.numberOfLines = 0;
    _promptLbl.font = [UIFont systemFontOfSize:14];
    _promptLbl.textAlignment = NSTextAlignmentCenter;
}

@end
