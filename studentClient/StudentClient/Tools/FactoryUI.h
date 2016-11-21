//
//  FactoryUI.h
//  派送员
//
//  Created by QiQi on 16/6/14.
//  Copyright © 2016年 Hefei JiuYi Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FactoryUI : NSObject

//UIView
+ (UIView *)createViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color;

// UILabel
+ (UILabel *)createLableWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font;

// UIButton
+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor imageName:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName tagart:(id)target selector:(SEL)selector;

// UIImageView
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;

// UITextField
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame text:(NSString *)text leftView:(UIView *)leftView rightView:(UIView *)rightView placdholder:(NSString *)placeholder;

@end

@interface UIView (QuickControl)

//可以为任何view设置圆角
-(void)setCornerRadius:(float)radius;
// 设置边框和颜色
- (void)setborderWidth:(float)width borderColor:(UIColor *)color;

@end
