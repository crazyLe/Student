//
//  LLStageBillCell.m
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLStageBillCell.h"

@implementation LLStageBillCell

- (void)setUI
{
    [super setUI];
    
    _lblArr = [[NSMutableArray alloc] init];
    
    CGFloat topOffset = 60;
    CGFloat btnWidth = (kScreenWidth - 25 - 50)/2;
    CGFloat btnHeight = 25;
    for (int i = 0; i < 6; i++) {
        UILabel *lbl = [UILabel new];
        [self.bgView addSubview:lbl];
        lbl.frame = CGRectMake(5+10*kWidthScale+btnWidth*(i%2), topOffset+ btnHeight*(i/2), btnWidth, btnHeight);
        lbl.textColor = [UIColor colorWithHexString:@"666666"];
        lbl.font = kFont12;
        [_lblArr addObject:lbl];
    }
    
    _promptLbl = [UILabel new];
    [self.bgView addSubview:_promptLbl];
    [_promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.bottom.offset(0);
        make.height.offset(30);
        make.width.offset(300);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    self.leftView.backgroundColor = [UIColor colorWithHexString:@"fe5e5b"];
    
    self.titleLbl.textColor = self.leftView.backgroundColor;
    
    _promptLbl.textAlignment = NSTextAlignmentRight;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.rightBtn.imageEdgeInsets = UIEdgeInsetsMake(self.rightBtn.imageEdgeInsets.top, self.rightBtn.imageEdgeInsets.left+5, self.rightBtn.imageEdgeInsets.bottom, self.rightBtn.imageEdgeInsets.right-5);
    self.rightBtn.titleEdgeInsets = UIEdgeInsetsMake(self.rightBtn.titleEdgeInsets.top, self.rightBtn.titleEdgeInsets.left+5, self.rightBtn.titleEdgeInsets.bottom, self.rightBtn.titleEdgeInsets.right-5);
}
/**
 *  自定义cell的高亮背景
 *
 *  @param highlighted highlighted
 *  @param animated    animated
 */
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
    if (highlighted) {
        self.bgView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    }
    else
    {
        self.bgView.backgroundColor = [UIColor whiteColor];
        
    }
    
    [super setHighlighted:highlighted animated:animated];
    
    
}

@end
