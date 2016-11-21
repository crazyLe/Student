//
//  UIViewController+NavigationController.h
//  醉了么
//
//  Created by zuweizhong  on 16/6/3.
//  Copyright © 2016年 Hefei JiuYi Network Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationController)
/**
 *  创建有左边和中间title的导航栏
 *
 *  @param leftName           左边按钮图片名字
 *  @param leftHightlightName 左边按钮图片高亮名字
 *  @param selector           左边按钮点击事件
 *  @param title              导航栏标题
 *
 *  @return 左边按钮
 */
-(UIButton *)createNavWithLeftBtnImageName:(NSString *)leftName leftHighlightImageName:(NSString *)leftHightlightName leftBtnSelector:(SEL)selector  andCenterTitle:(NSString *)title;
/**
 *  布局导航栏的左边，中间和右边
 *
 *  @param leftName           左边按钮图片名字
 *  @param leftHightlightName 左边按钮图片高亮名字
 *  @param leftSelector       左边按钮点击事件
 *  @param title              导航栏标题
 *  @param rightName          右边按钮图片名字
 *  @param rightHighlightName 右边按钮图片高亮名字
 *  @param rightSelector      右边按钮点击事件
 *
 *  @return 按钮数组
 */
-(NSArray *)createNavWithLeftBtnImageName:(NSString *)leftName leftHighlightImageName:(NSString *)leftHightlightName leftBtnSelector:(SEL)leftSelector andCenterTitle:(NSString *)title andRightBtnImageName:(NSString *)rightName rightHighlightImageName:(NSString *)rightHighlightName rightBtnSelector:(SEL)rightSelector;

/**
 *  布局导航栏的左边，中间和右边,同时右边按钮带文字
 *
 *  @param leftName           左边按钮图片名字
 *  @param leftHightlightName 左边按钮图片高亮名字
 *  @param leftSelector       左边按钮点击事件
 *  @param title              导航栏标题
 *  @param rightName          右边按钮图片名字
 *  @param rightHighlightName 右边按钮图片高亮名字
 *  @param rightSelector      右边按钮点击事件
 *  @param rightTitle         右边按钮文字title
 *
 *  @return 按钮数组
 */
-(NSArray *)createNavWithLeftBtnImageName:(NSString *)leftName leftHighlightImageName:(NSString *)leftHightlightName leftBtnSelector:(SEL)leftSelector andCenterTitle:(NSString *)title andRightBtnImageName:(NSString *)rightName rightHighlightImageName:(NSString *)rightHighlightName rightBtnSelector:(SEL)rightSelector withRightBtnTitle:(NSString *)rightTitle;

/**
 *  布局导航栏的左边，中间和右边,同时右边按钮带文字(右边字体X色)
 *
 *  @param leftName           左边按钮图片名字
 *  @param leftHightlightName 左边按钮图片高亮名字
 *  @param leftSelector       左边按钮点击事件
 *  @param title              导航栏标题
 *  @param rightName          右边按钮图片名字
 *  @param rightHighlightName 右边按钮图片高亮名字
 *  @param rightSelector      右边按钮点击事件
 *  @param rightTitle         右边按钮文字title
 *
 *  @return 按钮数组
 */
-(NSArray *)createNavWithLeftBtnImageName:(NSString *)leftName leftHighlightImageName:(NSString *)leftHightlightName leftBtnSelector:(SEL)leftSelector andCenterTitle:(NSString *)title andRightBtnImageName:(NSString *)rightName rightHighlightImageName:(NSString *)rightHighlightName rightBtnSelector:(SEL)rightSelector withRightBtnTitle:(NSString *)rightTitle rightColor:(UIColor*)color;


/**
 *  布局主页面导航栏的左边，中间和右边(右按钮是图片 并且 左边按钮是定位按钮)
 *
 *  @param leftName           左边按钮图片名字
 *  @param leftHightlightName 左边按钮图片高亮名字
 *  @param leftSelector       左边按钮点击事件
 *  @param title              导航栏标题
 *  @param rightName          右边按钮图片名字
 *  @param rightHighlightName 右边按钮图片高亮名字
 *  @param rightSelector      右边按钮点击事件
 *
 *  @return 按钮数组
 */
-(NSArray *)createMainNavWithLeftBtnImageName:(NSString *)leftName leftHighlightImageName:(NSString *)leftHightlightName leftBtnSelector:(SEL)leftSelector andCenterTitle:(NSString *)title andRightBtnImageName:(NSString *)rightName rightHighlightImageName:(NSString *)rightHighlightName rightBtnSelector:(SEL)rightSelector;

/**
 *  布局主页面导航栏的左边，中间和右边(右边有定位)
 *
 *  @param leftName           左边按钮图片名字
 *  @param leftHightlightName 左边按钮图片高亮名字
 *  @param leftSelector       左边按钮点击事件
 *  @param title              导航栏标题
 *  @param rightName          右边按钮图片名字
 *  @param rightHighlightName 右边按钮图片高亮名字
 *  @param rightSelector      右边按钮点击事件
 *
 *  @return 按钮数组
 */
-(NSArray *)createRightLocationNavWithLeftBtnImageName:(NSString *)leftName leftHighlightImageName:(NSString *)leftHightlightName leftBtnSelector:(SEL)leftSelector andCenterTitle:(NSString *)title andRightBtnImageName:(NSString *)rightName rightHighlightImageName:(NSString *)rightHighlightName rightBtnSelector:(SEL)rightSelector;



/**
 *  布局导航栏的左边中间和右边，同时中间title为按钮类型
 *
 *  @param leftName           左边按钮图片名字
 *  @param leftHightlightName 左边按钮图片高亮名字
 *  @param leftSelector       左边按钮点击事件
 *  @param title              导航栏标题
 *  @param centerSelector     导航中间按钮点击事件
 *  @param rightName          右边按钮图片名字
 *  @param rightHighlightName 右边按钮图片高亮名字
 *  @param rightSelector      右边按钮点击事件
 *  @param rightTitle         右边按钮文字title
 *
 *  @return 按钮数组(左边和右边)
 */
-(NSArray *)createCenterBtnNavWithLeftBtnImageName:(NSString *)leftName leftHighlightImageName:(NSString *)leftHightlightName leftBtnSelector:(SEL)leftSelector andCenterTitle:(NSString *)title  centerBtnSelector:(SEL)centerSelector andRightBtnImageName:(NSString *)rightName rightHighlightImageName:(NSString *)rightHighlightName rightBtnSelector:(SEL)rightSelector withRightBtnTitle:(NSString *)rightTitle;

@end

@interface UIViewController (Translucent)

@end
