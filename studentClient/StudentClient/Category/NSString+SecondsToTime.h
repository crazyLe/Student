//
//  NSString+SecondsToTime.h
//  小筛子
//
//  Created by zuweizhong  on 16/4/18.
//  Copyright © 2016年 zwz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SecondsToTime)

/**
 *  秒换算成时分秒的算法
 */
+(NSString*)timeFormatFromSeconds:(NSInteger)seconds;


@end
