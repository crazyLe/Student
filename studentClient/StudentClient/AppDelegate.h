//
//  AppDelegate.h
//  学员端
//
//  Created by zuweizhong  on 16/7/8.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,assign)BOOL allowRotation;

-(void)setTabBarRootViewController;

@end

