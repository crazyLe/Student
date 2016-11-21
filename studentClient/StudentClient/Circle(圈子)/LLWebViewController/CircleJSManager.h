//
//  CircleJSManager.h
//  Coach
//
//  Created by LL on 16/8/22.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "JSInteractiveManager.h"
#import <Foundation/Foundation.h>
#import "ChatBarContainer.h"

@class CircleJSManager;

typedef void(^NeedRefreshTableBlock)(CircleJSManager *js_Manager);

@interface CircleJSManager : JSInteractiveManager <UIScrollViewDelegate,ChatBarContainerDelegate>

@property (nonatomic,copy) NeedRefreshTableBlock needRefreshBlock;

@end
