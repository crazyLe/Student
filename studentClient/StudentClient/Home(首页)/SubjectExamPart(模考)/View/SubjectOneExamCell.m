//
//  SubjectOneExamCell.m
//  学员端
//
//  Created by gaobin on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SubjectOneExamCell.h"

@implementation SubjectOneExamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _examBankLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _examTimeLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _standardLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _questionRuleLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _examRuleLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    
    _examBankLab1.textColor = [UIColor colorWithHexString:@"#666666"];
    _examTimeLab1.textColor = [UIColor colorWithHexString:@"#666666"];
    _standardLab1.textColor = [UIColor colorWithHexString:@"#666666"];
    _questionRuleLab1.textColor = [UIColor colorWithHexString:@"#666666"];
    _examRuleLab1.textColor = [UIColor colorWithHexString:@"#666666"];
    
    
    [_startExamBtn setTitle:@"开始考试" forState:UIControlStateNormal];
    [_startExamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _startExamBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _startExamBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 7, 0, 0);
    [_startExamBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    

}
-(void)setSubjectNum:(NSString *)subjectNum
{
    _subjectNum = subjectNum;
    
    if ([subjectNum isEqualToString:@"一"]) {
        self.bgImageView.image = [UIImage imageNamed:@"Subject--One"];
        self.examRuleLab1.text = [NSString stringWithFormat:@"科目%@考试答题后不能修改答案,每做一题,系统自动计算错题数量,如累计错题数量超过11题(共100题),系统会自动提交答案,本次考试不通过!",subjectNum];
    }
    else
    {
        self.bgImageView.image = [UIImage imageNamed:@"Subject--four"];
    
        self.examRuleLab1.text = [NSString stringWithFormat:@"科目%@考试答题后不能修改答案,每做一题,系统自动计算错题数量,如累计错题数量超过6题(共50题),系统会自动提交答案,本次考试不通过!",subjectNum];

    }


}
//开始考试
-(void)startBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(subjectOneExamCellDidClickStartBtn:)]) {
        [self.delegate subjectOneExamCellDidClickStartBtn:self];
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





@end
