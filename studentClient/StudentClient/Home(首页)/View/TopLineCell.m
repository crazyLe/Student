//
//  TopLineCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "TopLineCell.h"

@implementation TopLineCell
{
    NSTimer *_timer;
    
    NSInteger i;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    i = 0;
    
    self.cyclingLabel.text = @"";
    
//    self.cyclingLabel.transitionEffect = BBCyclingLabelTransitionEffectScrollUp;
    self.cyclingLabel.transitionEffect = BBCyclingLabelTransitionEffectCrossFade;
    
    self.cyclingLabel.clipsToBounds = YES;
    
    self.cyclingLabel.font = [UIFont systemFontOfSize:14];
    
//    self.cyclingLabel.transitionDuration = 1.999f;
    
    self.cyclingLabel.textColor = [UIColor colorWithHexString:@"#aeaeae"];
    
    self.cyclingLabel.userInteractionEnabled = NO;
    
    [self.cyclingLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
    
    
    

}
-(void)click:(UITapGestureRecognizer *)tap
{
    BBCyclingLabel *label = (BBCyclingLabel *)tap.view;
    for (NSDictionary *dict in self.studentTopArray) {
        if ([dict[@"communityTitle"] isEqualToString:label.text]) {
            if ([self.delegate respondsToSelector:@selector(topLineCell:didClickCircleLabelWithDict:)]) {
                [self.delegate topLineCell:self didClickCircleLabelWithDict:dict];
                break;
            }
        }
    }

}
-(void)setStudentTopArray:(NSMutableArray *)studentTopArray
{
    _studentTopArray = studentTopArray;
    

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(valueChange) userInfo:nil repeats:YES];
        [_timer fire];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    });


}

- (void)valueChange {
    
    
    if (i<self.studentTopArray.count) {
        [self.cyclingLabel setText:((NSDictionary *)self.studentTopArray[i])[@"communityTitle"] animated:YES];
        i++;
    }else
    {
        i=0;
        [self.cyclingLabel setText:((NSDictionary *)self.studentTopArray[0])[@"communityTitle"] animated:YES];
        i++;
    }
    
    
}

- (IBAction)moreBtnClick:(id)sender {
}
@end
