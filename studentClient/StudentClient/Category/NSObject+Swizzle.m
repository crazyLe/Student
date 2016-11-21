//
//  NSObject+Swizzle.m
//  学员端
//
//  Created by zuweizhong  on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "NSObject+Swizzle.h"

@implementation NSObject (Swizzle)

+ (void)swizzleClassSelector:(SEL)originalSelector withSwizzledClassSelector:(SEL)swizzledSelector
{
    Method originalMethod = class_getClassMethod(self, originalSelector);
    Method swizzledMethod = class_getClassMethod(self, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}
+(void)swizzleInstanceSelector:(SEL)origSelector withSwizzledInstanceSelector:(SEL)swizzledSelector
{
    Method method1 = class_getInstanceMethod([self class], origSelector);
    Method method2 = class_getInstanceMethod([self class], swizzledSelector);
    method_exchangeImplementations(method1, method2);

}


@end
