//
//  LLProgressView.m
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLProgressView.h"

@implementation LLProgressView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    _bgView = [UIView new];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    _progressLbl = [UILabel new];
    [_bgView addSubview:_progressLbl];
    _progressLbl.frame = CGRectMake(0, 0, 40, 25);
    _progressLbl.textColor = [UIColor colorWithHexString:@"c8c8c8"];
    _progressLbl.font = kFont12;
    
    _progressBgView = [UIView new];
    [self addSubview:_progressBgView];
    _progressBgView.frame = CGRectMake(0, _progressLbl.frame.origin.y+_progressLbl.frame.size.height, self.frame.size.width, 10);
    _progressBgView.layer.cornerRadius = 5;
    _progressBgView.layer.masksToBounds = YES;
    _progressBgView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    
    _progressFrontView = [UIView new];
    [self addSubview:_progressFrontView];
    _progressFrontView.frame = CGRectMake(_progressBgView.frame.origin.x, _progressBgView.frame.origin.y, _progressBgView.frame.size.width*_progress, _progressBgView.frame.size.height);
    _progressFrontView.backgroundColor = [UIColor colorWithHexString:@"5cb6ff"];
    _progressFrontView.layer.masksToBounds = YES;
    _progressFrontView.layer.cornerRadius = 5;
    
    [self setProgress:0];
}

- (void)setProgress:(CGFloat)progress
{
    if (_progress != progress) {
        _progress = progress;
        
        _progressFrontView.frame = CGRectMake(_progressFrontView.frame.origin.x, _progressFrontView.frame.origin.y, _progressBgView.frame.size.width*_progress, _progressFrontView.frame.size.height);
        _progressLbl.center = CGPointMake(_progressFrontView.frame.origin.x+_progressFrontView.frame.size.width, _progressLbl.center.y);
        [_progressLbl setText:[NSString stringWithFormat:@"%.0f%%",(float)(_progress*100)]];
    }
}

@end
