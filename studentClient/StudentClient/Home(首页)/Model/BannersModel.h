//
//  BannersModel.h
//  学员端
//
//  Created by gaobin on 16/8/4.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannersModel : NSObject


@property (nonatomic, copy) NSString * imgUrl;
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString * pageUrl;
@property (nonatomic, copy) NSString * pageTag;//原生页面标签

@end
