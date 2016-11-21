//
//  UIView+Cover.m
//  学员端
//
//  Created by zuweizhong  on 16/7/23.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "UIView+Cover.h"
#import <objc/runtime.h>
@implementation UIView (Cover)

-(TouchCoverHandler)touchCoverHandler
{
    return objc_getAssociatedObject(self, _cmd);

}
-(void)setTouchCoverHandler:(TouchCoverHandler)touchCoverHandler
{
    objc_setAssociatedObject(self, @selector(touchCoverHandler), touchCoverHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(UIView *)translucentCoverView
{
    UIView *cover = [[UIView alloc] initWithFrame:self.bounds];
    cover.backgroundColor = [UIColor darkGrayColor];
    cover.userInteractionEnabled = YES;
    cover.alpha = 0.8f;
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(translucentCoverViewSingleTap:)];
    [cover addGestureRecognizer:singleTapGesture];
    
    return cover;

}
-(void)translucentCoverViewSingleTap:(UITapGestureRecognizer *)tap
{

    UIView *cover = tap.view;
    
    if (self.touchCoverHandler) {
        
        self.touchCoverHandler(cover);
        
    }
}

@end
