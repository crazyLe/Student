//
//  QuestionBottomView.m
//  学员端
//
//  Created by zuweizhong  on 16/7/16.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "QuestionBottomView.h"

@implementation QuestionBottomView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.questionHudBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    
    self.correctBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);

    self.incorrectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);




}

- (IBAction)questionHudBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(questionBottomView:didClickQuestionHudBtnWithTotalQuestionArr:)]) {
        [self.delegate questionBottomView:self didClickQuestionHudBtnWithTotalQuestionArr:self.totalQuestionArr];
    }
}

- (IBAction)tucaoBtnClick:(id)sender {
    
    if (self.questionModel == nil) {
        [self.hudManager showErrorSVHudWithTitle:@"无题目吐槽!" hideAfterDelay:1.0];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(questionBottomView:didClickTuCaoButtonWithQuestionId:)]) {
        [self.delegate questionBottomView:self didClickTuCaoButtonWithQuestionId:self.questionModel];
    }
    
}
@end
