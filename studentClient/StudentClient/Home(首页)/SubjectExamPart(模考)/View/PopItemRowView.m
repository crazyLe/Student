//
//  PopItemRowView.m
//  学员端
//
//  Created by zuweizhong  on 16/7/19.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PopItemRowView.h"

@implementation PopItemRowView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleNumBtn.clipsToBounds = YES;
    
    self.titleNumBtn.layer.cornerRadius = self.titleNumBtn.width/2;
    
    

}
-(void)setSelected:(BOOL)selected
{
    if (selected) {
        self.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    [super setSelected:selected];

}

@end
