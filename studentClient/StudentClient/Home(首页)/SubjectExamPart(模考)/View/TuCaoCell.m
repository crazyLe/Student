//
//  TuCaoCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "TuCaoCell.h"

@implementation TuCaoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImageView.layer.cornerRadius = self.iconImageView.width/2;
    self.iconImageView.clipsToBounds = YES;
}
-(void)setCommentModel:(QuestionCommentModel *)commentModel
{
    _commentModel = commentModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.avatar] placeholderImage:[UIImage imageNamed:@"头像"]];
    
    self.nameLabel.text = commentModel.nickname;
    
    self.contentLabel.text = commentModel.content;
    
    if (self.commentModel.is_senior == 1) {
        self.shengPinLabel.hidden = NO;
    }else
    {
        self.shengPinLabel.hidden = YES;
    }
    
    if (self.commentModel.is_like == 1) {
        [self.zanBtn setImage:[UIImage imageNamed:@"iconfont-20151209tubiaolianxizhuanhuan10"] forState:UIControlStateNormal];
    }
    else
    {
        [self.zanBtn setImage:[UIImage imageNamed:@"iconfont-20151209tubiaolianxizhuanhuan102"] forState:UIControlStateNormal];

    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.commentModel.addtime];
    
    df.dateFormat = @"yyyy-MM-dd";
    
    NSString *str = [df stringFromDate:date];
    
    self.timeLabel.text = str;
    
    self.zanCountLabel.text = [NSString stringWithFormat:@"%d",self.commentModel.agreeCount];
    

    
}

- (IBAction)tucaoBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(tuCaoCell:didClickZanBtnWithModel:)]) {
        [self.delegate tuCaoCell:self didClickZanBtnWithModel:self.commentModel];
    }
    
    
    
}
@end
