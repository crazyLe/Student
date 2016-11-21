//
//  UIImage+HJ.m
//  小筛子
//
//  Created by zwz on 15/6/26.
//  Copyright (c) 2015年 zwz. All rights reserved.
//

#import "UIImage+HJ.h"

@implementation UIImage (HJ)

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}
//原始图片
+ (instancetype)imageWithOriginName:(NSString *)imageName
{
    UIImage *img = [UIImage imageNamed:imageName];
    return [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
