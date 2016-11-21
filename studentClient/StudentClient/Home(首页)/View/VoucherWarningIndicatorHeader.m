//
//  VoucherWarningIndicatorHeader.m
//  StudentClient
//
//  Created by sky on 2016/9/30.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "VoucherWarningIndicatorHeader.h"

@interface VoucherWarningIndicatorHeader()

@property(nonatomic, strong) UIImageView *warningImageView;

@property(nonatomic, strong) UILabel *warningLable;

@end

@implementation VoucherWarningIndicatorHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
        [self setLayout];
    }

    return self;
}

- (void)setupSubViews {
    _warningImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconWarning"]];
    _warningLable = [[UILabel alloc] init];
    _warningLable.text = @"代金券仅适用于发布的教练或驾校";
    _warningLable.textColor = [UIColor colorWithHexString:@"#666666"];

    [self addSubview:_warningImageView];
    [self addSubview:_warningLable];
}

- (void)setLayout {

    [_warningLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.top.equalTo(self.mas_top).offset(5);
    }];

    [_warningImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(_warningLable.mas_leading);
    }];
}

@end
