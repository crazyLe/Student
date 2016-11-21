//
//  UIImage+CatchImage.h
//  yyjx
//
//  Created by zuweizhong  on 16/7/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CatchImage)
/**
 *  获取视频url的第N帧
 *
 *  @param videoURL 视频url
 *  @param time     第N帧
 *
 *  @return 图片
 */
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;
/**
 *  重新设置图片的大小
 *
 *  @param image   原图片
 *  @param newSize 新大小
 *
 *  @return 重新设置大小的图片
 */
+ (UIImage*)imageWithImage :( UIImage*)image scaledToSize :(CGSize)newSize;


@end