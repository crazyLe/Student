//
//  XueshiModel.h
//  学员端
//
//  Created by 翁昌青 on 16/8/6.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XueshiModel : NSObject
//教练id
@property(copy,nonatomic)NSString   *uid;
//头像
@property(copy,nonatomic)NSString   *imgUrl;
@property(copy,nonatomic)NSString   *name;
@property(copy,nonatomic)NSString   *remark;

@end
