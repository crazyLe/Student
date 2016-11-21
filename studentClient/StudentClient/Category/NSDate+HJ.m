//
//  NSDate+HJ.m
//  
//
//  Created by zwz on 15-2-28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "NSDate+HJ.h"

@implementation NSDate (HJ)
-(BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay|NSCalendarUnitYear|NSCalendarUnitMonth;
    NSDateComponents *selfDateComponents = [calendar components:unit fromDate:self];
    NSDateComponents *nowDateComponents = [calendar components:unit fromDate:[NSDate date]];
    
    return (selfDateComponents.year == nowDateComponents.year &&selfDateComponents.month == nowDateComponents.month && selfDateComponents.day == nowDateComponents.day);

}
-(BOOL)isYesterday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *now = [NSDate date];
    NSString *nowStr = [dateFormatter stringFromDate:now];
    NSDate *nowDate=[dateFormatter dateFromString:nowStr];
    NSString *selfStr = [dateFormatter stringFromDate:self];
    NSDate *selfDate = [dateFormatter dateFromString:selfStr];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    
    return components.day == 1;

}
-(BOOL)isThisyear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear;
    NSDateComponents *selfDateComponents = [calendar components:unit fromDate:self];
    NSDateComponents *nowDateComponents = [calendar components:unit fromDate:[NSDate date]];
    return selfDateComponents.year == nowDateComponents.year;

}
-(NSDateComponents *)deltaFromNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:NSCalendarWrapComponents];

}
-(BOOL)isEarlyThanDate:(NSDate *)otherDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *d= [calendar components:unit fromDate:otherDate toDate:self options:NSCalendarWrapComponents];
    long sec = [d hour]*3600+[d minute]*60+[d second];
    
    if (sec >= 90) {
        return NO;
    }else
    {
        return YES;
    }



}
- (BOOL)isBetweenFromTime:(NSDate *)fromDate toTime:(NSDate *)toDate
{
    NSDateFormatter *dateF1 = [[NSDateFormatter alloc]init];
    dateF1.dateFormat = @"HH";
    NSString *fromHour = [dateF1 stringFromDate:fromDate];
    
    NSDateFormatter *dateF2 = [[NSDateFormatter alloc]init];
    dateF2.dateFormat = @"mm";
    NSString *fromMinute = [dateF2 stringFromDate:fromDate];
    
    NSInteger minuteTotalFromBegin = [fromHour integerValue] * 60+[fromMinute integerValue];
    
    
    NSDateFormatter *dateF = [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"HH:mm";
    NSString *tempNow = [dateF stringFromDate:self];
    NSDate *nowDate = [dateF dateFromString:tempNow];
    
    NSString *fromHourNow = [dateF1 stringFromDate:nowDate];
    
    NSString *fromMinuteNow = [dateF2 stringFromDate:nowDate];
    
    NSInteger minuteTotalFromNow = [fromHourNow integerValue] * 60+[fromMinuteNow integerValue];
    
    NSString *toHourEnd = [dateF1 stringFromDate:toDate];
    
    NSString *toMinuteEnd = [dateF2 stringFromDate:toDate];
    
    NSInteger minuteTotalFromEnd = [toHourEnd integerValue] * 60+[toMinuteEnd integerValue];
    if (minuteTotalFromBegin < minuteTotalFromEnd) {
        if (minuteTotalFromNow >=minuteTotalFromBegin && minuteTotalFromNow <=minuteTotalFromEnd) {
            return YES;
        }else
        {
            return NO;
        }
    }else
    {
        if ((minuteTotalFromNow >=minuteTotalFromBegin && minuteTotalFromNow <= 24*60) ||(minuteTotalFromNow >= 0 && minuteTotalFromNow <= minuteTotalFromEnd)  ) {
            return YES;
        }else
        {
            return NO;
        }
    
    
    
    }
    

}


+(NSString *)compareDate:(NSDate *)date
{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
    }
    
}


@end
