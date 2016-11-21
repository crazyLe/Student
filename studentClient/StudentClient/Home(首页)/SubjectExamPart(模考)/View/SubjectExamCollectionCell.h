//
//  SubjectExamCollectionCell.h
//  学员端
//
//  Created by zuweizhong  on 16/8/4.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamQuestionModel.h"

@class SubjectExamCollectionCell;

@protocol SubjectExamCollectionCellDelegate <NSObject>

-(void)subjectExamCollectionCell:(SubjectExamCollectionCell *)cell didClickSubmitBtnWithExamQuestionModel:(ExamQuestionModel *)model;
-(void)subjectExamCollectionCell:(SubjectExamCollectionCell *)cell didClickMoreCommentBtnWithExamQuestionModel:(ExamQuestionModel *)model;

@end

@interface SubjectExamCollectionCell : UICollectionViewCell

@property(nonatomic,strong)UITableView *bottomTableView;
@property(nonatomic,strong)ExamQuestionModel *currentQuestionModel;
@property(nonatomic,weak)id<SubjectExamCollectionCellDelegate> delegate;
/**
 *  是否是模考模式
 */
@property(nonatomic,assign)BOOL isExamination;
/**
 * 是否进来就显示评论
 */
@property(nonatomic,assign)BOOL isIminiteShowComment;

/**
 *  答对后自动删除该题目
 */
@property(nonatomic,assign)BOOL isDeleteFromDBWhenAnswerCorrect;


@end
