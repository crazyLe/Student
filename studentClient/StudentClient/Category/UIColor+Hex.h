//
//  UIColor+Hex.h
//  
//
//  Created by cdcm on 15/11/25.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
/**
 *  从十六进制字符串获取颜色
 *
 *  @param color 色值(支持@“#123456”、 @“0X123456”、 @“123456”三种格式)
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;
/**
 *  从十六进制字符串获取颜色
 *
 *  @param color 色值(支持@“#123456”、 @“0X123456”、 @“123456”三种格式)
 *  @param alpha 透明度
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;


@end
