//
//  NSString+Extension.h
//  
//
//  Created by zwz on 14-5-30.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Extension)

/**
 *  计算文本占用的宽高
 *
 *  @param font    显示的字体
 *  @param maxSize 最大的显示范围
 *
 *  @return 占用的宽高
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

+ (NSString *)convertSimpleUnicodeStr:(NSString *)inputStr;

+ (NSString *)encodeToPercentEscapeString: (NSString *) input;

+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;
/**
 *  ios 格式化金额，金额三位一个逗号
 *
 *  @param num 原金额字符串
 *
 *  @return Format后字符串
 */
+ (NSString *)countNumAndChangeFormat:(NSString *)num;

/**
 *  普通字符串转换为十六进制的
 *
 *  @param string 普通字符串
 *
 *  @return 十六进制
 */
+ (NSString *)hexStringFromString:(NSString *)string;
/**
 *  十六进制转换为普通字符串的
 *
 *  @param hexString 十六进制
 *
 *  @return 普通字符串
 */
+ (NSString *)stringFromHexString:(NSString *)hexString;

//十进制转二进制
- (NSString *)toBinarySystemWithDecimalSystem:(NSInteger)decimal;

//  二进制转十进制
+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary;

@end
