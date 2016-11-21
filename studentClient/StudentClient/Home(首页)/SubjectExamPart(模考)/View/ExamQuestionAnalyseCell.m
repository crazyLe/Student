//
//  ExamQuestionAnalyseCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "ExamQuestionAnalyseCell.h"

@implementation ExamQuestionAnalyseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
    
}
-(NSMutableAttributedString *)getStringWithRadio:(NSString *)radio
{
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:@"答错率:"];
    
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:radio];
    
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ffb037"] range:NSMakeRange(0, str2.length)];
    
    [str1 appendAttributedString:str2];

    return str1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
