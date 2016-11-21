//
//  BindCoachCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/29.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "BindCoachCell.h"
#import "CoachModel.h"

@implementation BindCoachCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.layer.cornerRadius = ((kScreenWidth-33)/2-100)/2;
    self.bindingBtn.layer.cornerRadius = 5.0f;
    self.bindingBtn.clipsToBounds = YES;
}


- (void)setCoach:(CoachModel *)coach
{
    _coach = coach;
    
    if ([coach.bind_status isEqualToString:@"-1"]) {//-1未绑定
        [self.bindingBtn setTitle:@"立即绑定" forState:UIControlStateNormal];
        self.bindingBtn.userInteractionEnabled = YES;
    }
    else if ([coach.bind_status isEqualToString:@"0"])//审核
    {
        [self.bindingBtn setTitle:@"已申请" forState:UIControlStateNormal];
        self.bindingBtn.userInteractionEnabled = NO;
    }
    else if ([coach.bind_status isEqualToString:@"1"])//已绑定
    {
        [self.bindingBtn setTitle:@"已绑定" forState:UIControlStateNormal];
        self.bindingBtn.userInteractionEnabled = YES;
    }
    else if ([coach.bind_status isEqualToString:@"0"])//被拒绝
    {
    
        [self.bindingBtn setTitle:@"立即绑定" forState:UIControlStateNormal];
        self.bindingBtn.userInteractionEnabled = YES;
    }
    
    NSURL *url = [NSURL URLWithString:coach.imgUrl];
    [self.iconImageView setImageWithURL:url placeholder:[UIImage imageNamed:@"头像"]];
    NSLog(@"%@",coach);
    if (coach.name.length == 0) {
        coach.name = @"未设置";
    }
    
    self.nameLabel.text = coach.name;

    if (coach.schoolName.length == 0) {
        coach.schoolName = @"康庄驾校";
    }
    self.driverSchoolLabel.text = coach.schoolName;
    self.mobileLabel.text = [NSString stringWithFormat:@"手机:%@",coach.phone];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (IBAction)bindingBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(bindCoachCellDidClickBindBtn:)]) {
        [self.delegate bindCoachCellDidClickBindBtn:self];
    }
}
@end
