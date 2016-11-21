//
//  AlreadyReleaseCell.m
//  学员端
//
//  Created by gaobin on 16/7/15.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "AlreadyReleaseCell.h"

@implementation AlreadyReleaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)getCellHeightWithLabText:(NSString *)string{
    
    CGRect cellFrame = self.frame;
    _locationLab.text = string;
    _locationLab.numberOfLines = 0;
    CGSize size = CGSizeMake(kScreenWidth - 133, MAXFLOAT);
    CGSize labelSize = [_locationLab.text sizeWithFont:_locationLab.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    _locationLab.frame = CGRectMake(_locationLab.frame.origin.x, _locationLab.frame.origin.y, labelSize.width, labelSize.height);
    cellFrame.size.height = labelSize.height + 60;
    self.frame = cellFrame;
    
    
}
@end
