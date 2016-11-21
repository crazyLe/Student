//
//  JpushManager.h
//  学员端
//
//  Created by zuweizhong  on 16/8/19.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JpushManager : NSObject

singletonInterface(JpushManager)

-(void)startMonitor;

@end
