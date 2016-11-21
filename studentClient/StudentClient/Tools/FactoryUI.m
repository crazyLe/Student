//
//  FactoryUI.m
//  派送员
//
//  Created by QiQi on 16/6/14.
//  Copyright © 2016年 Hefei JiuYi Network Technology Co.,Ltd. All rights reserved.
//

#import "FactoryUI.h"

@implementation FactoryUI

//UIView
+ (UIView *)createViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

// UILabel
+ (UILabel *)createLableWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)color font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textColor = color;
    return label;
}

// UIButton
+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor imageName:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName tagart:(id)target selector:(SEL)selector
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    // 设置标题
    [button setTitle:title forState:UIControlStateNormal];
    // 设置标题颜色
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    // 设置背景颜色
    [button setBackgroundColor:backgroundColor];
    // 设置图片
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    // 设置背景图片
    [button setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
    // 添加响应方法
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

// UIImageView
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    return  imageView;
}

// UITextField
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame text:(NSString *)text leftView:(UIView *)leftView rightView:(UIView *)rightView placdholder:(NSString *)placeholder
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.leftView = leftView;
    textField.rightView = rightView;
    textField.placeholder = placeholder;
    textField.text = text;
    return  textField;
}

@end

@implementation UIView (QuickControl)
//可以为任何view设置圆角
-(void)setCornerRadius:(float)radius
{
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}
// 设置边框和颜色
- (void)setborderWidth:(float)width borderColor:(UIColor *)color
{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}
@end