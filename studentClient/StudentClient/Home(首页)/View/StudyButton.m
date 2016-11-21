//
//  StudyButton.m
//  学员端
//
//  Created by zuweizhong  on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "StudyButton.h"

@implementation StudyButton

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
    CGFloat x = 0;
    
    CGFloat y = 0;
    
    CGFloat width = contentRect.size.width ;
    
    CGFloat height = contentRect.size.width ;
    
    return CGRectMake(x, y, width, height);
    
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 0;
    
    CGFloat y =  contentRect.size.width ;
    
    CGFloat width = contentRect.size.width;
    
    CGFloat height = contentRect.size.width *(0.3) ;
    
    return CGRectMake(x, y, width, height);
    
}

@end
