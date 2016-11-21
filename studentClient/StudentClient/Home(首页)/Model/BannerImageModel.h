//
//  BannerImageModel.h
//  学员端
//
//  Created by zuweizhong  on 16/8/3.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerImageModel : NSObject
@property(nonatomic,strong)NSString * imgUrl;
@property(nonatomic,strong)NSString * pageTag;
@property(nonatomic,strong)NSString * pageUrl;
@property(nonatomic,assign)int  type;

@end
