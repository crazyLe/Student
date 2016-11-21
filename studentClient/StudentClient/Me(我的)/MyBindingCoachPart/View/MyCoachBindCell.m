//
//  MyCoachBindCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/29.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MyCoachBindCell.h"
#import "CoachModel.h"



@implementation MyCoachBindCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 23;
    self.cancelBindBtn.clipsToBounds = YES;
    self.cancelBindBtn.layer.cornerRadius = 5.0;
}

- (void)setCoach:(CoachModel *)coach {
    _coach = coach;
    NSLog(@"%@",coach);
    if (coach.name.length == 0) {
        coach.name = @"未设置";
    }
    
    self.nameLabel.text = coach.name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:coach.imgUrl] placeholderImage:[UIImage imageNamed:@"coachAvatar"]];
    if (coach.schoolName.length == 0) {
        coach.schoolName = @"康庄驾校";
    }
    if ([coach.subjects isEqualToString:@"2"]) {
        self.subTitleLabel.text = @"科目二";
    } else if ([coach.subjects isEqualToString:@"3"]) {
        self.subTitleLabel.text = @"科目三";
    } else {
        self.subTitleLabel.text = coach.subjects;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)cancelBindBtnClick:(id)sender
{
    if ([_delegate respondsToSelector:@selector(jiechuBDingCoach:)]) {
        [_delegate jiechuBDingCoach:self];
    }

}
@end
