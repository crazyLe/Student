//
//  MsgModel.h
//  学员端
//
//  Created by zuweizhong  on 16/8/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgModel : NSObject

@property(nonatomic,assign)int idNum;

@property(nonatomic,strong)NSString * title;

@property(nonatomic,strong)NSString * msg;

@property(nonatomic,assign)NSInteger  addtime;

@property(nonatomic,assign)BOOL isRead;

@property(nonatomic,assign)NSInteger msg_id;


@end
