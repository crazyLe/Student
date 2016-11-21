//
//  TestCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "TestCell.h"

@implementation TestCell
{
    NSMutableArray *btnArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cellHeight = ((float)(kScreenWidth-16-3*2)/3)*1.5+38+11+20;
    
    btnArray = [@[self.subjectBtn1,self.subjectBtn4,self.kanTestBtn] mutableCopy];
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)subject1Click:(UIButton *)sender {
    
    
    
    [UIView animateWithDuration:0.2 animations:^{
        for (UIButton *btn in btnArray) {
            btn.transform = CGAffineTransformIdentity;
        }
        sender.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(testCell:didClickSubjectButtonWithType:)]) {
            [self.delegate testCell:self didClickSubjectButtonWithType:SubjectBtn1];
        }
    }];
    
    
   
    
    
    
    
}
- (IBAction)kanTestBtnClick:(UIButton *)sender{

    [UIView animateWithDuration:0.2 animations:^{
        for (UIButton *btn in btnArray) {
            btn.transform = CGAffineTransformIdentity;
        }
        sender.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(testCell:didClickSubjectButtonWithType:)]) {
            [self.delegate testCell:self didClickSubjectButtonWithType:KanTestBtn];
        }
    }];
    
    
    
    
}

- (IBAction)subject4Click:(UIButton *)sender {
    
    
    
    [UIView animateWithDuration:0.2 animations:^{
        for (UIButton *btn in btnArray) {
            btn.transform = CGAffineTransformIdentity;
        }
        sender.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(testCell:didClickSubjectButtonWithType:)]) {
            [self.delegate testCell:self didClickSubjectButtonWithType:SubjectBtn4];
        }
    }];
    
    
    
}
@end
