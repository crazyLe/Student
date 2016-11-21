//
//  CircleTopLineController.h
//  学员端
//
//  Created by zuweizhong  on 16/8/23.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"

@class JSInteractiveManager;

@interface CircleTopLineController : BaseViewController

@property(nonatomic,strong)UIWebView * webView;

@property(nonatomic,strong)NSString * url;

@property(nonatomic,strong)NSString * url2;

@property (nonatomic,strong) JSInteractiveManager *js_Manager; //处理和JS交互的Model

@property (nonatomic,strong) id object;  //携带的对象

@end
