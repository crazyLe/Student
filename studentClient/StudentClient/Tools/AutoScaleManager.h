//
//  AutoScaleManager.h
//  学员端
//
//  Created by zuweizhong  on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

//适配宏定义
#define autoScaleW(width) [[AutoScaleManager sharedAutoScaleManager] autoScaleW:width]

#define autoScaleH(height) [[AutoScaleManager sharedAutoScaleManager] autoScaleH:height]

#define autoScaleFont(fontSize) autoScaleW(fontSize)

#import <Foundation/Foundation.h>

//(iOS 控件宽高字体大小适配方法,请不要使用该类，转而使用该类的宏定义)
@interface AutoScaleManager : NSObject

singletonInterface(AutoScaleManager)

- (CGFloat)autoScaleW:(CGFloat)w;

- (CGFloat)autoScaleH:(CGFloat)h;

//当前屏幕与设计尺寸(iPhone6)宽度比例
@property (nonatomic, assign)CGFloat autoSizeScaleW;

//当前屏幕与设计尺寸(iPhone6)高度比例
@property (nonatomic, assign)CGFloat autoSizeScaleH;

@end
