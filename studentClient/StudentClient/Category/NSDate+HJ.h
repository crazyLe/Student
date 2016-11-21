//
//  NSDate+HJ.h
//
//
//  Created by zwz on 15-2-28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HJ)
/**
 判断是否是今天
 */
-(BOOL)isToday;
/**
 判断是否是昨天
 */
-(BOOL)isYesterday;
/**
 判断是否是今年
 */
-(BOOL)isThisyear;
/**
 获得2个时间的时间差
 */
-(NSDateComponents *)deltaFromNow;
/**
 判断一个时间是否比另一个时间早
 */
-(BOOL)isEarlyThanDate:(NSDate *)otherDate;
/**
 完成判断一个时间是否在8:23-11:46之间的功能
 NSDate必须传8：23或23：45之类的格式
 */
- (BOOL)isBetweenFromTime:(NSDate *)fromDate toTime:(NSDate *)toDate;
/**
 *  判断日期是今天，昨天还是明天
 *
 *  @param date 要判断的日期
 *
 *  @return 字符串
 */
+(NSString *)compareDate:(NSDate *)date;

@end
