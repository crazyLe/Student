//
//  OtherTrainerCell.m
//  学员端/Users/apple/Desktop/IOS5/trunk/学员端/学员端.xcodeproj
//
//  Created by gaobin on 16/7/15.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "OtherTrainerCell.h"


@implementation OtherTrainerCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.headerImgView.clipsToBounds = YES;
    self.headerImgView.layer.cornerRadius = 25;
    //设置阴影
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    _bgView.layer.shadowOpacity = 0.05f;
    _bgView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    
    [self layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)getCellHeightWithLab:(NSString *)string {
    
    
    CGRect cellFrame = self.frame;
    
    _locationLab.text = string;
    _locationLab.numberOfLines = 10;
    CGSize size = CGSizeMake(kScreenWidth - 106, MAXFLOAT);
    
    CGSize labelSize = [_locationLab.text sizeWithFont:_locationLab.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    _locationLab.frame = CGRectMake(_locationLab.frame.origin.x, _locationLab.frame.origin.y, labelSize.width, labelSize.height);
  
    cellFrame.size.height = labelSize.height + 80;
    
    self.frame = cellFrame;
}

@end
