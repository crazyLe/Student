//
//  VoucherCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "VoucherCell.h"

@implementation VoucherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];

    _valueLab.font = [UIFont boldSystemFontOfSize:autoScaleFont(39)];
    _valueLab.adjustsFontSizeToFitWidth = YES;
    _voucherLab.font = [UIFont systemFontOfSize:autoScaleFont(13)];
    _nameLab.font = [UIFont systemFontOfSize:autoScaleFont(17)];
    _introduceLab.font = [UIFont systemFontOfSize:autoScaleFont(13)];
    _dateLab.font = [UIFont systemFontOfSize:autoScaleFont(13)];
    _immediateUseBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleFont(14)];
    _immediateUseBtn.layer.cornerRadius = 5 * AutoSizeFont;
    _immediateUseBtn.clipsToBounds = YES;
    _nameLabel.font = [UIFont systemFontOfSize:autoScaleFont(13)];
    _nameLabel.textColor = [UIColor colorWithHexString:@"c8c8c8"];

    
    _valueLabWidth.constant = autoScaleW(80);
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(90*AutoSizeScaleY *0.3);
    }];
    
    [_immediateUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(autoScaleW(70));
        make.height.offset(autoScaleH(30));
    }];
    
    [_usedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(autoScaleW(80));
        make.height.offset(autoScaleH(45));
    }];
    
    
}
- (IBAction)LingQuBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voucherCellDidClickLingQuBtn:)]) {
        [self.delegate voucherCellDidClickLingQuBtn:self];
    }
}
@end
