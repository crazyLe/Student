//
//  DayBtnView.m
//  学员端
//
//  Created by zuweizhong  on 16/7/15.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "DayBtnView.h"

@implementation DayBtnView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    
    self.bgImageView.userInteractionEnabled = YES;
    
    self.topLabel.userInteractionEnabled = YES;
    
    self.bottomLabel.userInteractionEnabled = YES;

}

@end
