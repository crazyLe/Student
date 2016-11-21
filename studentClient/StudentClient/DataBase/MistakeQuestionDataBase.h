//
//  MistakeQuestionDataBase.h
//  学员端
//
//  Created by zuweizhong  on 16/8/8.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExamQuestionModel.h"

@interface MistakeQuestionDataBase : NSObject

+(instancetype)shareInstance;
// 插入数据
-(void)insertDataWithModel:(ExamQuestionModel *)model;
// 查找模考数据
- (NSArray *)queryTestMistakeDataWithSubject:(NSString *)subject;
// 查找做题数据
- (NSArray *)queryZuoTiMistakeDataWithSubject:(NSString *)subject;
// 删除某条数据
-(void)deleteDataWithModel:(ExamQuestionModel *)model;
//删除所有科目四数据
-(void)deleteAllSubject4Data;
//删除所有科目一数据
-(void)deleteAllSubject1Data;


@end

