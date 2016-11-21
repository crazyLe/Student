//
//  UIImage+HJ.h
//  小筛子
//
//  Created by zwz on 15/6/26.
//  Copyright (c) 2015年 zwz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HJ)
/**
 *  返回一张自由拉伸的图
 *
 *  @param name 图片名
 *  @param left 左边距
 *  @param top  上边距
 *
 *  @return UIImage
 */
+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
+ (UIImage *)resizedImageWithName:(NSString *)name;
/**
 *  加载原始图片, 没有渲染
 *  @return UIImage
 */
+ (instancetype)imageWithOriginName:(NSString *)imageName;
@end
