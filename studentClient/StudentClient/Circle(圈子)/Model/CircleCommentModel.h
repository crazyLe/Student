//
//  CircleCommentModel.h
//  学员端
//
//  Created by zuweizhong  on 16/7/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleCommentModel : NSObject

@property(nonatomic,strong)NSString * face;

@property(nonatomic,strong)NSString * nickname;

@property(nonatomic,strong)NSString * content;

@property(nonatomic,strong)NSString * addtime;

@property(nonatomic,assign)int  idNum;

@property(nonatomic,assign)int  isamazing;

@property(nonatomic,assign)int  likeNum;

@property(nonatomic,assign)int is_praise;

@end
