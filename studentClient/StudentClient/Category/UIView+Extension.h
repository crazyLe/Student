//
//  UIView+Extension.h
//  
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;//left
@property (nonatomic, assign) CGFloat y;//top
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

//额外添加的一些常用属性
@property (nonatomic, assign) CGFloat right;//控件右边
@property (nonatomic, assign) CGFloat bottom;//控件左边

/**
 * 移除所有子控件
 */
- (void)removeAllSubviews;



@end
