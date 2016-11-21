//
//  JSInteractiveManager.h
//  Coach
//
//  Created by LL on 16/8/20.
//  Copyright © 2016年 sskz. All rights reserved.
//

typedef void(^didGetJSBridgeBlock)(UIViewController *webViewVC);

#import <WebViewJavascriptBridge.h>
#import <Foundation/Foundation.h>

@interface JSInteractiveManager : NSObject

@property WebViewJavascriptBridge* bridge;

@property (nonatomic, copy)   didGetJSBridgeBlock block;

@end
