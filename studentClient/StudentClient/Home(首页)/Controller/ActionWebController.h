//
//  ActionWebController.h
//  学员端
//
//  Created by 翁昌青 on 16/8/8.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionWebController : UIViewController
@property(strong,nonatomic)NSString *urlstr;
@property (weak, nonatomic) IBOutlet UIWebView *web;

@end
