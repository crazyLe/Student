//
//  UIView+DrawDashLine.m
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "UIView+DrawDashLine.h"

@implementation UIView (DrawDashLine)

+(void)drawDashLineInViewBorderRect:(UIView *)view lineColor:(UIColor *)lineColor cornerRadius:(CGFloat)radius
{
    CAShapeLayer *border = [CAShapeLayer layer];
    
    border.strokeColor = lineColor.CGColor;
    
    border.fillColor = nil;
    
    border.path = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    
    border.frame = view.bounds;
    
    border.lineWidth = 1.f;
    
    border.lineCap = @"square";
    
    border.lineDashPattern = @[@4, @2];
    
    [view.layer addSublayer:border];

}
@end
