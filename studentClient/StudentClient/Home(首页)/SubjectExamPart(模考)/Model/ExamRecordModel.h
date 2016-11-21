//
//  ExamRecordModel.h
//  学员端
//
//  Created by zuweizhong  on 16/8/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamRecordModel : NSObject

@property(nonatomic,assign)long addtime;

@property(nonatomic,assign)int answer_time;

@property(nonatomic,copy)NSString * beat_percent;

@property(nonatomic,assign)int error_answer;

@property(nonatomic,assign)int is_del;

@property(nonatomic,assign)long long jiaojuan_time;

@property(nonatomic,assign)int mid;

@property(nonatomic,assign)int scores;

@property(nonatomic,assign)int type;

@property(nonatomic,assign)int un_answer;

@property(nonatomic,copy)NSString * user_time_format;

@property(nonatomic,assign)int idNum;



@end
