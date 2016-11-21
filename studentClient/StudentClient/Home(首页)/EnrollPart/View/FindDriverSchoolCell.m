//
//  FindDriverSchoolCell.m
//  学员端
//
//  Created by gaobin on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "FindDriverSchoolCell.h"

@implementation FindDriverSchoolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

/**
 *  自定义CollectionView的高亮背景色
 *
 *  @param highlighted highlighted
 */
- (void)setHighlighted:(BOOL)highlighted{
    
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.contentView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
            
        } completion:nil];
        
            
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            self.contentView.backgroundColor = [UIColor whiteColor];
            
        } completion:^(BOOL finished) {
        }];
    }

}
@end
