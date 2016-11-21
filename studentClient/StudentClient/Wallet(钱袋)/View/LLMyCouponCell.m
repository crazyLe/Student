//
//  LLMyCouponCell.m
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLMyCouponCell.h"

@implementation LLMyCouponCell

- (void)setUI
{
    [super setUI];
    
    _lblArr = [[NSMutableArray alloc] init];
    
    CGFloat topOffset = 60;
    CGFloat btnWidth = (kScreenWidth - (5+10*kWidthScale) - 65)/3;
    CGFloat btnHeight = 25;
    for (int i = 0; i < 3; i++) {
        UILabel *lbl = [UILabel new];
        [self.bgView addSubview:lbl];
        lbl.frame = CGRectMake(5+10*kWidthScale+btnWidth*(i%3), topOffset+ btnHeight*(i/3), btnWidth, btnHeight);
        lbl.textColor = [UIColor colorWithHexString:@"666666"];
        lbl.font = kFont12;
        [_lblArr addObject:lbl];
    }
}

- (void)setAttributes
{
    [super setAttributes];
    self.leftView.backgroundColor = [UIColor colorWithRed:254/255.0 green:166/255.0 blue:47/255.0 alpha:1];
    
    self.titleLbl.textColor = self.leftView.backgroundColor;
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
