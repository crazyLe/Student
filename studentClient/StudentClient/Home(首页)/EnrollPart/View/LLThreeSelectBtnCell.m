//
//  LLThreeSelectBtnCell.m
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#define kSideOffset 20
#define filterSelectKey(i) [NSString stringWithFormat:@"filterSelect_%d",i]

#import "LLThreeSelectBtnCell.h"

@implementation LLThreeSelectBtnCell

- (void)setUI
{
    CGFloat btnWidth = 70;
    CGFloat interval = (kScreenWidth - btnWidth*3)/4;
    _btnArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        LLButton *btn = [LLButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:btn];
        
        btn.layer.masksToBounds = YES;
        btn.titleLabel.numberOfLines = 0;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.tag = 10+i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.frame = CGRectMake(interval+(btnWidth+interval)*i, 0, btnWidth, btnWidth);
        
        [_btnArr addObject:btn];
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (LLButton *btn in _btnArr) {
        btn.center = CGPointMake(btn.center.x, self.contentView.center.y);
        btn.layer.cornerRadius = btn.frame.size.width/2;
        [btn layoutButtonWithEdgeInsetsStyle:LLButtonStyleTextBottom imageTitleSpace:10];
    }
}

- (void)clickBtn:(LLButton *)btn
{
    if (btn.tag == 10) {
        //bool选择
        btn.selected = !btn.selected;
        
        if (btn.selected) {
            [_filterSelectDic setObject:@(YES) forKey:filterSelectKey(0)];

        }
        else
        {
            [_filterSelectDic setObject:@(NO) forKey:filterSelectKey(0)];
        }
        //存储
    }
    else
    {
        //Radio选择
        btn.selected = !btn.selected;
        for (LLButton *tempBtn in @[_btnArr[1],_btnArr[2]]) {
            if (tempBtn.tag != btn.tag) {
                tempBtn.selected = NO;
                break;
            }
        }
        //存储
        [_filterSelectDic setObject:btn.selected?@(btn.tag-10):@(0) forKey:filterSelectKey(1)];
    }
    
}

@end
