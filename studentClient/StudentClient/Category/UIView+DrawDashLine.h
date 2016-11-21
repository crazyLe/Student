//
//  UIView+DrawDashLine.h
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DrawDashLine)
/**
 *  在UIView的四周画虚线
 *
 *  @param 要画虚线的View 
 */
+(void)drawDashLineInViewBorderRect:(UIView *)view lineColor:(UIColor *)lineColor cornerRadius:(CGFloat)radius;

@end
