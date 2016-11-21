//
//  MessageDataBase.h
//  学员端
//
//  Created by zuweizhong  on 16/8/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsgModel.h"
@interface MessageDataBase : NSObject

+(instancetype)shareInstance;
// 插入数据
-(void)insertDataWithModel:(MsgModel *)model;
//获取主键最大的数据
-(MsgModel *)getMaxIdModel;
// 查找数据
- (NSArray *)query;
//更新
-(void)setDataIsReadWithModel:(MsgModel *)model;
//所有未读数据
- (NSArray *)queryAllUnRead;

//查找圈子消息
- (NSArray *)queryCircleMessage;
//查找圈子未读
- (NSArray *)queryCircleUnRead;




@end
