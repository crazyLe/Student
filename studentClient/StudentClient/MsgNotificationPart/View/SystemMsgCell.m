//
//  SystemMsgCell.m
//  学员端
//
//  Created by zuweizhong  on 16/8/1.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SystemMsgCell.h"

@implementation SystemMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5.0f;
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

@end
