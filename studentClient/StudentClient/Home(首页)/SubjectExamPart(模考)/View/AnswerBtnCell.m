//
//  AnswerBtnCell.m
//  学员端
//
//  Created by zuweizhong  on 16/8/4.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "AnswerBtnCell.h"

@implementation AnswerBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.answerButtom.layer.cornerRadius = 20.0f;
    self.answerButtom.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)answerBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(answerBtnCell:didClickBtnWithModel:)]) {
        [self.delegate answerBtnCell:self didClickBtnWithModel:self.questionModel];
    }
}
@end
