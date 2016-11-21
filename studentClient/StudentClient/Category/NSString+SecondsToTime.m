//
//  NSString+SecondsToTime.m
//  小筛子
//
//  Created by zuweizhong  on 16/4/18.
//  Copyright © 2016年 zwz. All rights reserved.
//

#import "NSString+SecondsToTime.h"

@implementation NSString (SecondsToTime)

/**
 *  秒换算成时分秒的算法
 */
+(NSString*)timeFormatFromSeconds:(NSInteger)seconds
{
    //format of hour
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}



@end
