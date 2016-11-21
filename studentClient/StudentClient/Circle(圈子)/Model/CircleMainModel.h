//
//  CircleMainModel.h
//  学员端
//
//  Created by zuweizhong  on 16/7/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CircleCommentModel.h"
@interface CircleMainModel : NSObject

@property(nonatomic,strong)NSString * face;

@property(nonatomic,strong)NSString * nickName;

@property(nonatomic,strong)NSString * content;

@property(nonatomic,strong)NSArray<NSDictionary *> * pic;

@property(nonatomic,strong)NSString * addtime;

@property(nonatomic,strong)NSString * area;

@property(nonatomic,strong)CircleCommentModel * comemnt;

@property(nonatomic,assign)int isTop;

@property(nonatomic,assign)int commentNum;

@property(nonatomic,assign)int idNum;

@property(nonatomic,assign)int likeNum;

@property(nonatomic,assign)int shareNum;

@property(nonatomic,strong)NSString * url;

@property(nonatomic,assign)int user_type;

@property(nonatomic,assign)int is_ver;

@property(nonatomic,assign)int uid;

@property(nonatomic,assign)int is_praise;


@end
