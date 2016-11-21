//
//  MyPartnerTrainCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/29.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MyPartnerTrainCell.h"
#import "XueshiModel.h"
@implementation MyPartnerTrainCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 23;
}

- (void)setXueshi:(XueshiModel *)xueshi
{
    _xueshi = xueshi;

    NSURL *url = [NSURL URLWithString: _xueshi.imgUrl];
    [self.iconImageView setImageWithURL:url placeholder:[UIImage imageNamed:@"coachAvatar"]];
    
    self.nameLabel.text = xueshi.name;
    
    self.subTitleLabel.text = xueshi.remark;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)cancelBindBtnClick:(id)sender {
}
@end
