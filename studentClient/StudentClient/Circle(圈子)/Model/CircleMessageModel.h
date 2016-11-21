//
//  CircleMessageModel.h
//  学员端
//
//  Created by zuweizhong  on 16/8/19.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleMessageModel : NSObject

@property(nonatomic,strong)NSString * communityUrl;

@property(nonatomic,assign)long addtime;

@property(nonatomic,assign)int communityId;

@property(nonatomic,strong)NSString * content;

@property(nonatomic,strong)NSString * desc;

@property(nonatomic,strong)NSString * imgUrl;

@property(nonatomic,assign)int is_read;

@property(nonatomic,strong)NSString * name;

@property(nonatomic,assign)int type;

@end
