//
//  HJTextField.m
//  小筛子
//
//  Created by zwz on 15/6/26.
//  Copyright (c) 2015年 zwz. All rights reserved.
//

#import "HJTextField.h"

@implementation HJTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;// 右偏10
    return iconRect;
}


@end
