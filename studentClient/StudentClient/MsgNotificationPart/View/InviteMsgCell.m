//
//  InviteMsgCell.m
//  学员端
//
//  Created by zuweizhong  on 16/8/1.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "InviteMsgCell.h"

@implementation InviteMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5.0f;
    [self.rejectBtn setborderWidth:LINE_HEIGHT borderColor:[UIColor colorWithHexString:@"e6e6e6"]];
    [self.agreeBtn setborderWidth:LINE_HEIGHT borderColor:[UIColor colorWithHexString:@"7acc1d"]];
    self.rejectBtn.layer.cornerRadius = 5.0f;
    self.agreeBtn.layer.cornerRadius = 5.0f;


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setFrame:(CGRect)frame
{
    frame.origin.x = frame.origin.x+12;
    
    frame.size.width = frame.size.width-24;
    
    [super setFrame:frame];
    
    
}
- (IBAction)agreeBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inviteMsgCell:didClickAgreeOrRejectBtnWithString:)]) {
        [self.delegate inviteMsgCell:self didClickAgreeOrRejectBtnWithString:@"1"];
    }
}

- (IBAction)rejectBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(inviteMsgCell:didClickAgreeOrRejectBtnWithString:)]) {
        [self.delegate inviteMsgCell:self didClickAgreeOrRejectBtnWithString:@"0"];
    }
}
@end
