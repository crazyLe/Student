//
//  AutoScaleManager.m
//  学员端
//
//  Created by zuweizhong  on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "AutoScaleManager.h"

@implementation AutoScaleManager

singletonImplementation(AutoScaleManager)

-(instancetype)init
{
    if (self = [super init]) {
        if (kScreenHeight == 480)
        {
            //4s
            _autoSizeScaleW = kScreenWidth / 375;
            _autoSizeScaleH = kScreenHeight / 667;
        }
        else if (kScreenHeight == 568)
        {
            //5
            _autoSizeScaleW = kScreenWidth / 375;
            _autoSizeScaleH = kScreenHeight / 667;
        }
        else if (kScreenHeight ==667)
        {
            //6
            _autoSizeScaleW = kScreenWidth / 375;
            _autoSizeScaleH = kScreenHeight / 667;
        }
        else if(kScreenHeight == 736)
        {
            //6p
            _autoSizeScaleW = kScreenWidth / 375;
            _autoSizeScaleH = kScreenHeight / 667;
        }
        else
        {
            _autoSizeScaleW = 1;
            _autoSizeScaleH = 1;
        }
    }
    return self;
}
- (CGFloat)autoScaleW:(CGFloat)w{
    
    return w * self.autoSizeScaleW;
    
}

- (CGFloat)autoScaleH:(CGFloat)h{
    
    return h * self.autoSizeScaleH;
    
}


@end
