//
//  CircleMessageCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "CircleMessageCell.h"

@implementation CircleMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.layer.cornerRadius = self.iconImageView.width/2;
    self.subTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.titleLabel.attributedText = [self getAttriStringWithString:@"嫣然为诗笑"];
    
    self.titleLabel.font = kFont14;
    
    self.timeLabel.font = kFont11;
    
    self.subTitleLabel.font = kFont14;
    
}
-(void)setMessageModel:(CircleMessageModel *)messageModel
{
    _messageModel = messageModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:messageModel.imgUrl] placeholderImage:[UIImage imageNamed:@"头像"]];
    self.titleLabel.attributedText = [self getAttriStringWithString:messageModel.name];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"MM-dd HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:messageModel.addtime];
    NSString *time = [df stringFromDate:date];
    self.timeLabel.text = time;
    self.subTitleLabel.text = messageModel.content;


}

- (NSMutableAttributedString *)getAttriStringWithString:(NSString *)name
{
    if (name != nil) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:name];
        
        [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"758691"] range:NSMakeRange(0, name.length)];
        
        [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, name.length)];
        
        NSMutableAttributedString *attri2 = [[NSMutableAttributedString alloc]initWithString:@"评论了你的圈子"];
        
        [attri2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999"] range:NSMakeRange(0, attri2.length)];
        
        [attri2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attri2.length)];
        
        [attri appendAttributedString:attri2];
        
        return attri;
    }
    return [[NSMutableAttributedString alloc]initWithString:@""];
   


}

@end
