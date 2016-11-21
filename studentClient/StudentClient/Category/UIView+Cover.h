//
//  UIView+Cover.h
//  学员端
//
//  Created by zuweizhong  on 16/7/23.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//  给UIView添加半透明蒙版

#import <UIKit/UIKit.h>

typedef void (^TouchCoverHandler) (UIView *translucentCoverView);

@interface UIView (Cover)
/**
 *  蒙版UIView
 */
@property(nonatomic,strong,readonly)UIView * translucentCoverView;


@property(nonatomic,copy)TouchCoverHandler touchCoverHandler;


@end
