//
//  MistakeQuestionController.h
//  学员端
//
//  Created by zuweizhong  on 16/8/8.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "SubjectExamController.h"

@interface MistakeQuestionController : BaseViewController
/**
 *  数据源
 */
@property(nonatomic,strong)NSMutableArray * allDataArray;

@property(nonatomic,strong)NSString * titleString;//标题
/**
 *  是否显示评论
 */
@property(nonatomic,assign)BOOL isShowComment;
/**
 *  是否进来就显示评论
 */
@property(nonatomic,assign)BOOL isIminiteShowComment;

/**
 *  答对后自动删除该题目
 */
@property(nonatomic,assign)BOOL isDeleteWhenAnswerCorrect;


@end
