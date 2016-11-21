//
//  LocationButton.m
//  学员端
//
//  Created by zuweizhong  on 16/7/11.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LocationButton.h"

@implementation LocationButton

-(instancetype)init
{
    if (self = [super init]) {
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;

    }
    
    return self;

}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = ((float)3/4) * contentRect.size.width;
    
    CGFloat y = contentRect.origin.y;
    
    CGFloat width = contentRect.size.width * ((float)1/4);
    
    CGFloat height = contentRect.size.height;
    
    return CGRectMake(x, y, width, height);

}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 0;
    
    CGFloat y = contentRect.origin.y;
    
    CGFloat width = contentRect.size.width * ((float)3/4);
    
    CGFloat height = contentRect.size.height;
    
    return CGRectMake(x, y, width, height);
    
}

@end
