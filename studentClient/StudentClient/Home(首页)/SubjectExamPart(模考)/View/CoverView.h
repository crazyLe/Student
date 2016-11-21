//
//  CoverView.h
//  学员端
//
//  Created by zuweizhong  on 16/7/19.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchBlock)();

@interface CoverView : UIView

@property(nonatomic,copy)TouchBlock touchBlock ;


@end
