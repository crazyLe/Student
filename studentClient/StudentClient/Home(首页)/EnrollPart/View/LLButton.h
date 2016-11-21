//
//  LLButton.h
//  Coach
//
//  Created by apple on 16/7/11.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LLButtonStyleTextOnly = 1, //只显示文字
    LLButtonStyleImgOnly,      //只显示图片
    LLButtonStyleTextLeft,     //文字在左，图片在右
    LLButtonStyleTextRight,    //文字在右，图片在左
    LLButtonStyleTextTop,      //文字在上，图片在下
    LLButtonStyleTextBottom    //文字在下，图片在上
}LLButtonStyle;

@class LLButton;

typedef void(^AnimationCompeletionBlock)(LLButton *animationBtn);

@interface LLButton : UIButton

- (void)setIsShowColorBgWhenTouch:(BOOL)isShow highlightedBgColor:(NSString *)color
               highlightedBgAlpha:(NSNumber *)alpha; //是否当触摸按钮时显示某种颜色,透明度背景

- (void)layoutButtonWithEdgeInsetsStyle:(LLButtonStyle)style
                        imageTitleSpace:(CGFloat)space;

- (void)zoomAnimationWithDuration:(NSTimeInterval)duration completeBlock:(AnimationCompeletionBlock)block;

@end
