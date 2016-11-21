//
//  MyCoachUnBindCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/29.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MyCoachUnBindCell.h"
#import "CoachModel.h"
@implementation MyCoachUnBindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lijiBindBtn.clipsToBounds = YES;
    self.lijiBindBtn.layer.cornerRadius = 5.0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)lijiBindBtnClick:(id)sender {
//    if ([_delegate respondsToSelector:@selector(BDingCoach:)]) {
//        [_delegate BDingCoach:self];
//    }
    self.gotoBlock();
}
@end
