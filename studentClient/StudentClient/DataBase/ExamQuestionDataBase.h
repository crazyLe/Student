//
//  ExamQuestionDataBase.h
//  学员端
//
//  Created by zuweizhong  on 16/8/3.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExamQuestionModel.h"
@interface ExamQuestionDataBase : NSObject

+(instancetype)shareInstance;

// 查找数据
- (NSArray *)query;
// 查找某条
-(ExamQuestionModel *)queryExamQuestionModelWithID:(int)idNum;
//查找科目一数据类型数据
-(NSArray *)queryExamOneQuestionWithClassType:(NSString *)type;
//查找科目4数据类型数据
-(NSArray *)queryExamFourQuestionWithClassType:(NSString *)type;
//查找科目一数据
-(NSArray *)queryExamOneQuestion;
//查找科目4数据
-(NSArray *)queryExamFourQuestion;
//获取科目一模考试题
-(NSArray *)query100ExamOneQuestions;
//获取科目四模考试题
-(NSArray *)query50ExamFourQuestions;
//更新某题目的错误率
-(void)updateErrorRateWithRate:(NSString *)errorRate questionId:(int)idNum;

@end
