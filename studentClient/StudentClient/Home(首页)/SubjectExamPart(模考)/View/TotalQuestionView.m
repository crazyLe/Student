//
//  TotalQuestionView.m
//  学员端
//
//  Created by zuweizhong  on 16/7/16.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "TotalQuestionView.h"

#define RowCount 6

@implementation TotalQuestionView
{
    NSMutableArray *itemBtnArray;
}
/**
 *  代码创建
 *
 *  @return instancetype
 */
-(instancetype)init
{
    if (self = [super init]) {
        [self setupSubviews];
    }

    return self;

}
/**
 *  XIB创建
 *
 *  @param aDecoder aDecoder
 *
 *  @return instancetype
 */
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupSubviews];
    }
    return self;

}
-(void)setTotalQuestionArr:(NSMutableArray *)totalQuestionArr
{

    _totalQuestionArr = totalQuestionArr;
    
    [itemBtnArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [itemBtnArray removeAllObjects];
    
    for (int i = 0; i<totalQuestionArr.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
//        [btn setBackgroundImage:[UIImage imageNamed:@"科一做题_椭圆-1"] forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        btn.layer.borderWidth = 0.5;
        NSNumber *num = totalQuestionArr[i];
        NSString *title = [NSString stringWithFormat:@"%ld",num.integerValue+1];
        [btn setTitle:title forState:UIControlStateNormal];

        [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        
        btn.tag = 1899+i;
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        
        [self.scrollView addSubview:btn];
        
        [itemBtnArray addObject:btn];
        
    }
    
    [self setNeedsLayout];
    
    [self layoutIfNeeded];
    




}
-(void)btnClick:(UIButton *)btn
{

    if ([self.delegate respondsToSelector:@selector(totalQuestionView:didSelectIndex:)]) {
        [self.delegate totalQuestionView:self didSelectIndex:(int)btn.tag-1899];
    }

}
-(void)setIncorrectIndexArray:(NSMutableArray *)incorrectIndexArray
{
    _incorrectIndexArray = incorrectIndexArray;
    
    for (int j = 0; j<incorrectIndexArray.count; j++) {
        
        NSNumber *num = incorrectIndexArray[j];
        
        for (int i = 0; i<itemBtnArray.count; i++) {
            
            UIButton *btn = itemBtnArray[i];
            
            if (num.integerValue == i) {
                NSNumber *num = _totalQuestionArr[i];
                NSString *title = [NSString stringWithFormat:@"%ld",num.integerValue+1];
                [btn setTitle:title forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithHexString:@"#ff5d5d"] forState:UIControlStateNormal];
                btn.layer.borderColor = [UIColor colorWithHexString:@"#ff5d5d"].CGColor;
                self.incorrentLabel.text = [NSString stringWithFormat:@"错误 %ld",incorrectIndexArray.count];
                break;
                
            }
            
            
        }
        
    }



}
-(void)setCorrectIndexArray:(NSMutableArray *)correctIndexArray
{
    _correctIndexArray = correctIndexArray;
    
    for (int j = 0; j<correctIndexArray.count; j++) {
        
        NSNumber *num = correctIndexArray[j];
        
        for (int i = 0; i<itemBtnArray.count; i++) {
            
            UIButton *btn = itemBtnArray[i];
            
            if (num.integerValue == i) {
                NSNumber *num = _totalQuestionArr[i];
                NSString *title = [NSString stringWithFormat:@"%ld",num.integerValue+1];
                [btn setTitle:title forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithHexString:@"#78cc1c"] forState:UIControlStateNormal];
                btn.layer.borderColor = [UIColor colorWithHexString:@"#78cc1c"].CGColor;
                
                self.correntLabel.text = [NSString stringWithFormat:@"正确 %ld",correctIndexArray.count];
                
                break;

            }
            
            
        }
        
    }


}
-(void)setupSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    
    itemBtnArray = [NSMutableArray array];
    
    UILabel *correntLabel = [[UILabel alloc]init];
    
    correntLabel.text = @"正确 0";
    
    correntLabel.font = [UIFont systemFontOfSize:13];
    
    correntLabel.textColor = [UIColor colorWithHexString:@"78cc1c"];
    
    self.correntLabel = correntLabel;
    
    self.correntLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.correntLabel];
    
    UILabel *incorrentLabel = [[UILabel alloc]init];
    
    incorrentLabel.text = @"错误 0";
    
    incorrentLabel.font = [UIFont systemFontOfSize:13];
    
    self.incorrentLabel = incorrentLabel;
    
    self.incorrentLabel.textAlignment = NSTextAlignmentCenter;

    
    incorrentLabel.textColor = [UIColor colorWithHexString:@"ff5d5d"];

    [self addSubview:self.incorrentLabel];
    
    UIButton *dismissBtn = [[UIButton alloc]init];
    
    [dismissBtn setImage:[UIImage imageNamed:@"iconfont-dismiss"] forState:UIControlStateNormal];
    
    [dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    self.dismissButton = dismissBtn;
    
    [self addSubview:self.dismissButton];
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    
    self.scrollView = scrollView;
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:scrollView];

}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.correntLabel.frame = CGRectMake(12, 20, 80, 20);
    
    self.incorrentLabel.frame = CGRectMake(92, 20, 80, 20);
    
    self.dismissButton.frame = CGRectMake(self.width-23-8, 20, 23, 23);
    
    self.scrollView.frame = CGRectMake(0, 60, self.width, self.height-60);
    
    CGFloat itemWidth = (self.width-18*2-(RowCount-1)*25)/RowCount;
    
    CGFloat itemHeight = itemWidth;

    
    for (int i = 0; i<itemBtnArray.count; i++) {
        
        int row = i/6;
        
        int col = i%6;
        
        UIButton *btn = itemBtnArray[i];
        
        CGFloat x = 18 + (itemWidth + 25)*col;
        
        CGFloat y = (itemHeight+18)*row;
        
        btn.frame = CGRectMake(x, y, itemWidth, itemHeight);
        
        btn.layer.cornerRadius = btn.width/2;
        
        btn.clipsToBounds = YES;

    }
    
    UIButton *btn = itemBtnArray.lastObject;
    
    CGFloat height = CGRectGetMaxY(btn.frame);
    
    self.scrollView.contentSize = CGSizeMake(self.width, height+20);
    






}
-(void)show
{
    
    self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 400);
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -400);
    } completion:^(BOOL finished) {
        
    }];
    
    
    
    
}
-(void)dismiss
{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];

}

@end
