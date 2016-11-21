//
//  LLButton.m
//  Coach
//
//  Created by apple on 16/7/11.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLButton.h"

@implementation LLButton
{
    LLButtonStyle _buttonStyle;
    
    AnimationCompeletionBlock completionBlock;
    
    BOOL isShowColorBgWhenTouch;
    NSString *colorOfBgWhenTouch;
    NSNumber *alphaOfBgWhenTouch;
}

- (void)setIsShowColorBgWhenTouch:(BOOL)isShow highlightedBgColor:(NSString *)color
                        highlightedBgAlpha:(NSNumber *)alpha
{
    isShowColorBgWhenTouch = isShow;
    colorOfBgWhenTouch = color;
    alphaOfBgWhenTouch = alpha;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (!isShowColorBgWhenTouch) {
        return;
    }
    
    if (highlighted) {
        //高亮
        self.backgroundColor = [UIColor colorWithHexString:colorOfBgWhenTouch alpha:[alphaOfBgWhenTouch floatValue]];
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)layoutButtonWithEdgeInsetsStyle:(LLButtonStyle)style
                        imageTitleSpace:(CGFloat)space
{
    //    self.backgroundColor = [UIColor cyanColor];
    
    /**
     *  前置知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case LLButtonStyleTextBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case LLButtonStyleTextRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case LLButtonStyleTextTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case LLButtonStyleTextLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
            
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

- (void)zoomAnimationWithDuration:(NSTimeInterval)duration completeBlock:(AnimationCompeletionBlock)block
{
    completionBlock = block;
    
    CABasicAnimation *zoomInAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [zoomInAnimation setDuration:duration*0.5];
    [zoomInAnimation setAutoreverses:NO];
    [zoomInAnimation  setRepeatCount:1];
    [zoomInAnimation setToValue:@(5.0f)];
    zoomInAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *zoomOutAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [zoomOutAnimation setDuration:duration*0.5];
    [zoomOutAnimation setAutoreverses:NO];
    [zoomOutAnimation  setRepeatCount:1];
    [zoomOutAnimation setToValue:@(1)];
    zoomOutAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = duration;
    group.animations = @[zoomInAnimation,zoomOutAnimation];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeBackwards;
    group.delegate = self;
    
    [self.layer addAnimation: group forKey:nil];
   
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    completionBlock(self);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
