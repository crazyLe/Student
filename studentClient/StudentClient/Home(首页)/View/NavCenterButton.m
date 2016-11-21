//
//  NavCenterButton.m
//  学员端
//
//  Created by zuweizhong  on 16/7/13.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "NavCenterButton.h"

@implementation NavCenterButton

/**
 *  代码创建
 *
 *  @return instancetype
 */
-(instancetype)init
{
    if (self = [super init]) {
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return self;
    
}
/**
 *  XIB创建
 *
 *  @param aDecoder aDecoder
 *
 *  @return instancetype
 */
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return self;
    
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = contentRect.size.width-10;
    
    CGFloat y = 6;
    
    CGFloat width = 10;
    
    CGFloat height = 8;
    
    return CGRectMake(x, y, width, height);
    
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 0;
    
    CGFloat y = contentRect.origin.y;
    
    CGFloat width = contentRect.size.width-10;
    
    CGFloat height = contentRect.size.height;
    
    return CGRectMake(x, y, width, height);
    
}

@end
