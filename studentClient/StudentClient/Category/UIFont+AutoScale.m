//
//  UIFont+AutoScale.m
//  学员端
//
//  Created by zuweizhong  on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//  iOS不同机型,文字大小按比例显示 runtime实现

#import "UIFont+AutoScale.h"

static CGFloat fontScale;

#define displayFontSize(fontSize) fontSize * fontScale

@implementation UIFont (AutoScale)
/*
+ (void)load
{
    //以iPhone6为标准
    fontScale = kScreenWidth/375;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleClassSelector:@selector(systemFontOfSize:) withSwizzledClassSelector:@selector(gy_systemFontOfSize:)];
        [self swizzleClassSelector:@selector(systemFontOfSize:weight:) withSwizzledClassSelector:@selector(gy_systemFontOfSize:weight:)];
        [self swizzleClassSelector:@selector(boldSystemFontOfSize:) withSwizzledClassSelector:@selector(gy_boldSystemFontOfSize:)];
        [self swizzleClassSelector:@selector(italicSystemFontOfSize:) withSwizzledClassSelector:@selector(gy_italicSystemFontOfSize:)];
        [self swizzleClassSelector:@selector(fontWithName:size:) withSwizzledClassSelector:@selector(gy_fontWithName:size:)];
    });
}

+ (UIFont *)gy_systemFontOfSize:(CGFloat)fontSize
{
    return [self gy_systemFontOfSize:displayFontSize(fontSize)];
}

+ (UIFont *)gy_systemFontOfSize:(CGFloat)fontSize weight:(CGFloat)weight
{
    return [self gy_systemFontOfSize:displayFontSize(fontSize) weight:weight];
}


+ (UIFont *)gy_boldSystemFontOfSize:(CGFloat)fontSize
{
    return [self gy_boldSystemFontOfSize:displayFontSize(fontSize)];
}

+ (UIFont *)gy_italicSystemFontOfSize:(CGFloat)fontSize
{
    return [self gy_italicSystemFontOfSize:displayFontSize(fontSize)];
}

+ (nullable UIFont *)gy_fontWithName:(NSString *)fontName size:(CGFloat)fontSize
{
    return [self gy_fontWithName:fontName size:displayFontSize(fontSize)];
}
*/


 
@end

/**
 *  按钮
 */
@implementation UIButton (myFont)

//+ (void)load
//{
//    [self swizzleInstanceSelector:@selector(initWithCoder:) withSwizzledInstanceSelector:@selector(myInitWithCoder:)];
//}
//
//- (id)myInitWithCoder:(NSCoder*)aDecode{
//    [self myInitWithCoder:aDecode];
//    if (self) {
//        //部分不像改变字体的 把tag值设置成333跳过
//        if(self.titleLabel.tag != 333){
//            CGFloat fontSize = self.titleLabel.font.pointSize;
//            self.titleLabel.font = [UIFont systemFontOfSize:fontSize*fontScale];
//        }
//    }
//    return self;
//}


@end

/**
 *  Label
 */
@implementation UILabel (myFont)

//+ (void)load
//{
//    [self swizzleInstanceSelector:@selector(initWithCoder:) withSwizzledInstanceSelector:@selector(myInitWithCoder:)];
//
//}
//
//- (id)myInitWithCoder:(NSCoder*)aDecode{
//    [self myInitWithCoder:aDecode];
//    if (self) {
//        //部分不像改变字体的 把tag值设置成333跳过
//        if(self.tag != 333){
//            CGFloat fontSize = self.font.pointSize;
//            self.font = [UIFont systemFontOfSize:fontSize*fontScale];
//        }
//    }
//    return self;
//}

@end

/**
 *  YYLabel
 */
@implementation YYLabel (myFont)

//+ (void)load
//{
//    [self swizzleInstanceSelector:@selector(initWithCoder:) withSwizzledInstanceSelector:@selector(myInitWithCoder:)];
//    
//}
//
//- (id)myInitWithCoder:(NSCoder*)aDecode{
//    [self myInitWithCoder:aDecode];
//    if (self) {
//        //部分不像改变字体的 把tag值设置成333跳过
//        if(self.tag != 333){
//            CGFloat fontSize = self.font.pointSize;
//            self.font = [UIFont systemFontOfSize:fontSize*fontScale];
//        }
//    }
//    return self;
//}

@end









//不管是xib还是代码都可以用这种方法做字体适配
/*
+(void)load
{
    
    //以iPhone6为标准
    fontScale = kScreenWidth/375;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL systemSel = @selector(willMoveToSuperview:);
        SEL swizzSel = @selector(myWillMoveToSuperview:);
        
        [self swizzleInstanceMethod:systemSel with:swizzSel];
        
        
    });
    
    
    
    
}
- (void)myWillMoveToSuperview:(nullable UIView *)newSuperview
{
    [self myWillMoveToSuperview:newSuperview];
    
    //当时写的时候不改变button的title字体设置的，在这里你可以判断那种类型的改哪种不改，比如说你不想改button的字体，把这一句解注释即可
    if ([self isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
        
        return;
        
    }
    if (self) {
        
        if (self.tag == 10086) {
            
            self.font = [UIFont systemFontOfSize:self.font.pointSize];
        }
        else
        {
            NSLog(@"%f",self.font.pointSize);
            self.font  = [UIFont fontWithName:self.font.fontName size:self.font.pointSize*fontScale];
        }
        
    }
    
    
}
 */

