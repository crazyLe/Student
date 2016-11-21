//
//  NSObject+Swizzle.h
//  学员端
//
//  Created by zuweizhong  on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)
/**
 *  替换类方法
 */
+ (void)swizzleClassSelector:(SEL)originalSelector withSwizzledClassSelector:(SEL)swizzledSelector;
/**
 *  替换对象方法
 */
+ (void)swizzleInstanceSelector:(SEL)origSelector withSwizzledInstanceSelector:(SEL)swizzledSelector;

@end
