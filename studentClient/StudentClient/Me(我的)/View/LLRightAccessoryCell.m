//
//  LLRightAccessoryCell.m
//  学员端
//
//  Created by apple on 16/7/23.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLRightAccessoryCell.h"

@implementation LLRightAccessoryCell

- (void)setUI
{
    [super setUI];
    
    _accessoryImgView = [UIImageView new];
    [self.contentView addSubview:_accessoryImgView];
    
    _accessoryLbl = [UILabel new];
    [self.contentView addSubview:_accessoryLbl];
}

- (void)setContraints
{
    [super setContraints];
    
    WeakObj(_accessoryImgView)
    [_accessoryImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5*kWidthScale);
        make.width.height.offset(15*kWidthScale);
        make.centerY.offset(0);
    }];
    
    [_accessoryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_accessoryImgViewWeak.mas_left).offset(-8*kWidthScale);
        make.height.offset(15*kHeightScale);
        make.centerY.offset(0);
        make.width.offset(120*kWidthScale);
    }];

}

- (void)setAttributes
{
    [super setAttributes];
    
    _accessoryImgView.contentMode = UIViewContentModeCenter;
    
    _lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
}

- (void)setMessageNum:(NSString *)messageNum
{
    if (_messageNum != messageNum) {
        _messageNum = messageNum;
        CGSize size = [messageNum sizeWithFont:[UIFont systemFontOfSize:11] maxSize:CGSizeMake(MAXFLOAT, 15)];
        [_accessoryLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(size.width+10*kWidthScale);
            make.height.offset(size.height);
        }];
        _accessoryLbl.layer.cornerRadius = (7.0f*kWidthScale);
        _accessoryLbl.layer.masksToBounds = YES;
        _accessoryLbl.font = kFont11;
        _accessoryLbl.backgroundColor = [UIColor colorWithHexString:@"ff5d5d"];
        _accessoryLbl.textColor = [UIColor whiteColor];
        _accessoryLbl.text = messageNum;
        _accessoryLbl.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)setAccessoryLblText:(NSString *)accessoryLblText
{
    if (_accessoryLblText != accessoryLblText) {
        _accessoryLblText = accessoryLblText;
        
         WeakObj(_accessoryImgView)
        [_accessoryLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_accessoryImgViewWeak.mas_left).offset(-8*kWidthScale);
            make.height.offset(15*kHeightScale);
            make.centerY.offset(0);
            make.width.offset(120*kWidthScale);
        }];
        
        _accessoryLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _accessoryLbl.font = kFont12;
        _accessoryLbl.textAlignment = NSTextAlignmentRight;
        _accessoryLbl.text = accessoryLblText;
        _accessoryLbl.backgroundColor = [UIColor clearColor];
        _accessoryLbl.layer.cornerRadius = .0f;
        _accessoryLbl.layer.masksToBounds = NO;
    }
}

@end
