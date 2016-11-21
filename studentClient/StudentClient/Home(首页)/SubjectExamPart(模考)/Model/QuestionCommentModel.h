//
//  QuestionCommentModel.h
//  学员端
//
//  Created by zuweizhong  on 16/8/5.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionCommentModel : NSObject

@property(nonatomic,assign)long long addtime;

@property(nonatomic,assign)int agreeCount;

@property(nonatomic,strong)NSString * avatar;

@property(nonatomic,assign)int commentsId;

@property(nonatomic,strong)NSString * content;

@property(nonatomic,assign)int is_like;

@property(nonatomic,assign)int is_senior;

@property(nonatomic,strong)NSString * nickname;

@property(nonatomic,assign)int tid;

@property(nonatomic,assign)int uid;

@end
