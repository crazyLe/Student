//
//  UILabel+Arrtribute.h
//  UILabelTest
//
//  Created by 周文艳 on 16/6/20.
//  Copyright © 2016年 jiuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Arrtribute)

// Label 文字距离左边 edge 个距离
- (void)setEdgeToLeft:(CGFloat)edge WithString:(NSString *)text;

// Label 文字距离右边 edge 个距离
- (void)setEdgeToRight:(CGFloat)edge WithString:(NSString *)text;

@end
