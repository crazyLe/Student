//
//  CircleZanMessageCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "CircleZanMessageCell.h"

@implementation CircleZanMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.layer.cornerRadius = self.iconImageView.width/2;
    
    self.titleLabel.attributedText = [self getAttriStringWithString:@"嫣然为诗笑"];
    
    self.titleLabel.font = kFont14;
    
    self.timeLabel.font = kFont11;
    
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


}
- (NSMutableAttributedString *)getAttriStringWithString:(NSString *)name
{
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:name];
    
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"758691"] range:NSMakeRange(0, name.length)];
    
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, name.length)];
    
    NSMutableAttributedString *attri2 = [[NSMutableAttributedString alloc]initWithString:@"赞了你的圈子"];
    
    [attri2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999"] range:NSMakeRange(0, attri2.length)];
    
    [attri2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attri2.length)];
    
    [attri appendAttributedString:attri2];
    
    return attri;
    
    
}


@end
