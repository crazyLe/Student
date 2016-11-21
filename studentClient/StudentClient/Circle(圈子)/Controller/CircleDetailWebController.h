//
//  CircleDetailWebController.h
//  学员端
//
//  Created by zuweizhong  on 16/8/15.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "JSInteractiveManager.h"
@interface CircleDetailWebController : BaseViewController

@property(nonatomic,strong)NSString *urlString;

@property (nonatomic,strong) JSInteractiveManager *js_Manager; //处理和JS交互的Model

@property (nonatomic,strong) id object;  //携带的对象

@property(nonatomic,strong)UIWebView * webView;


@end
