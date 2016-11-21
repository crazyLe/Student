//
//  StudyCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "StudyCell.h"

@implementation StudyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.subject1 setImage:[UIImage imageNamed:@"study1"] forState:UIControlStateNormal];
    [self.subject2 setImage:[UIImage imageNamed:@"study2"] forState:UIControlStateNormal];

    [self.subject3 setImage:[UIImage imageNamed:@"study3"] forState:UIControlStateNormal];

    [self.subject4 setImage:[UIImage imageNamed:@"study4"] forState:UIControlStateNormal];
    
    [self.orderBtn setImage:[UIImage imageNamed:@"study5"] forState:UIControlStateNormal];
    
    [self.studyBtn setImage:[UIImage imageNamed:@"study6"] forState:UIControlStateNormal];
    
    self.cellHeight = 38+18+((float)(kScreenWidth-20-18*3)/4)*1.3*2+15+15;

    

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)subject1Click:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(studyCellDidClickBtnWithButtonType:)]) {
        [self.delegate studyCellDidClickBtnWithButtonType:StudyCellButtonSubjectOne];
    }
    
}
- (IBAction)subject2Click:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(studyCellDidClickBtnWithButtonType:)]) {
        [self.delegate studyCellDidClickBtnWithButtonType:StudyCellButtonSubjectTwo];
    }
}
- (IBAction)subject3Click:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(studyCellDidClickBtnWithButtonType:)]) {
        [self.delegate studyCellDidClickBtnWithButtonType:StudyCellButtonSubjectThree];
    }
}
- (IBAction)subject4Click:(id)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(studyCellDidClickBtnWithButtonType:)]) {
        [self.delegate studyCellDidClickBtnWithButtonType:StudyCellButtonSubjectFour];
    }
}
- (IBAction)orderClick:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(studyCellDidClickBtnWithButtonType:)]) {
        [self.delegate studyCellDidClickBtnWithButtonType:StudyCellButtonSubjectOrder];
    }

}

- (IBAction)studyClick:(id)sender{

    
    if ([self.delegate respondsToSelector:@selector(studyCellDidClickBtnWithButtonType:)]) {
        [self.delegate studyCellDidClickBtnWithButtonType:StudyCellButtonSubjectStudy];
    }



}
@end
