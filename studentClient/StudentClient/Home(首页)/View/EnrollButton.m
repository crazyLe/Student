//
//  EnrollButton.m
//  学员端
//
//  Created by zuweizhong  on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "EnrollButton.h"

@implementation EnrollButton
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
    CGFloat x = ((float)1/4) * contentRect.size.width-5;
    
    CGFloat y = ((float)1/8) * contentRect.size.height-5;
    
    CGFloat width = contentRect.size.width * ((float)1/2)+10;
    
    CGFloat height = contentRect.size.height* ((float)1/2)+10;
    
    return CGRectMake(x, y, width, height);
    
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 0;
    
    CGFloat y = ((float)5/8) * contentRect.size.height;
    
    CGFloat width = contentRect.size.width;
    
    CGFloat height = contentRect.size.height *((float)1/4) ;
    
    return CGRectMake(x, y, width, height);
    
}

@end
