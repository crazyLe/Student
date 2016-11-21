//
//  ShareView.m
//  Coach
//
//  Created by zuweizhong  on 16/8/1.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView

-(void)awakeFromNib
{

    [super awakeFromNib];
    
    self.cancelBtn.layer.borderWidth = 1.0f;
    
    self.cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"6e6e6e"].CGColor;
    
    self.cancelBtn.clipsToBounds = YES;
    
    self.cancelBtn.layer.cornerRadius = 5.0f;


}

-(void)updateConstraints
{
    [super updateConstraints];
    
    self.constriant2.constant = self.constriant1.constant;
    
    self.constriant3.constant = self.constriant2.constant;
    
    self.constriant4.constant = self.constriant3.constant;
    
    self.constriant5.constant = self.constriant4.constant;
    
}
- (IBAction)btn1Click:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shareView:didClickButtonWithType:)]) {
        [self.delegate shareView:self didClickButtonWithType:ShareViewBtnWeChatQuan];
    }
}
- (IBAction)btn2Click:(id)sender{
    if ([self.delegate respondsToSelector:@selector(shareView:didClickButtonWithType:)]) {
        [self.delegate shareView:self didClickButtonWithType:ShareViewBtnWeChat];
    }
}
- (IBAction)btn3Click:(id)sender{
    if ([self.delegate respondsToSelector:@selector(shareView:didClickButtonWithType:)]) {
        [self.delegate shareView:self didClickButtonWithType:ShareViewBtnWeBo];
    }

}
- (IBAction)btn4Click:(id)sender{
    if ([self.delegate respondsToSelector:@selector(shareView:didClickButtonWithType:)]) {
        [self.delegate shareView:self didClickButtonWithType:ShareViewBtnQQZone];
    }
}
- (IBAction)cancelBtnClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(shareViewDidClickCancelButton:)])
    {
        [self.delegate shareViewDidClickCancelButton:self];
    }
}
-(void)show
{
    self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 245);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -245);
    } completion:^(BOOL finished) {
        
    }];



}
-(void)dismissWithCompletionBlock:(ShareViewDismiss)block
{

    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        if (block) {
            block(self);
        }
    }];



}

@end
