//
//  LLWithdrawAmountCell.m
//  学员端
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLWithdrawAmountCell.h"

@implementation LLWithdrawAmountCell
#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _leftLbl = [UILabel new];
    [self.contentView addSubview:_leftLbl];
    _leftLbl.frame = CGRectMake(22*kWidthScale, 10, 80*kWidthScale, 32*kHeightScale);
    _leftLbl.textColor = [UIColor colorWithHexString:@"666666"];
    _leftLbl.font = kFont14;
    
    _btnArr = [[NSMutableArray alloc] init];
    CGFloat btnInterval = 10*kWidthScale;
    CGFloat btnHeight = 32*kHeightScale;
    CGFloat btnLeftOffset = _leftLbl.frame.origin.x+_leftLbl.frame.size.width;
    CGFloat btnWidth = (kScreenWidth - btnLeftOffset - 22*kWidthScale -btnInterval*2)/3;
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btn];
        btn.frame = CGRectMake(btnLeftOffset+(btnInterval+btnWidth)*i, _leftLbl.frame.origin.y, btnWidth, btnHeight);
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"5cb6ff"]] forState:UIControlStateSelected];
        if (i==0) {
            [self clickBtn:btn];
        }
        [btn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.layer.borderWidth = LINE_HEIGHT;
        btn.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
        btn.titleLabel.font = kFont14;
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_btnArr addObject:btn];
    }
}

- (void)clickBtn:(UIButton *)btn
{
    btn.selected = YES;
    
    self.currentBtn.selected = NO;
    
    self.currentBtn = btn;
    
    if (self.selectedBtnBlock) {
        NSString *str = [btn.titleLabel.text substringToIndex:btn.titleLabel.text.length - 1];
        self.selectedBtnBlock(str);
    }

}

@end
