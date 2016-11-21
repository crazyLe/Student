//
//  QuestionBottomView.h
//  学员端
//
//  Created by zuweizhong  on 16/7/16.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamQuestionModel.h"
@class QuestionBottomView;
@protocol QuestionBottomViewDelegate <NSObject>

@optional
/**
 *  点击题目指示器button
 *
 *  @param bottomView       bottomView
 *  @param totalQuestionArr 题目总数
 */
-(void)questionBottomView:(QuestionBottomView *)bottomView didClickQuestionHudBtnWithTotalQuestionArr:(NSMutableArray *)totalQuestionArr;
/**
 *  对某题目吐槽
 *
 *  @param bottomView bottomView
 *  @param questionId 题目id
 */
-(void)questionBottomView:(QuestionBottomView *)bottomView didClickTuCaoButtonWithQuestionId:(ExamQuestionModel *)questionModel;


@end

@interface QuestionBottomView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *correctBtnLeftPaddingConstraint;
@property (weak, nonatomic) IBOutlet UIButton *questionHudBtn;
@property (weak, nonatomic) IBOutlet UIButton *correctBtn;
@property (weak, nonatomic) IBOutlet UIButton *incorrectBtn;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *tuCaoBtn;//吐槽按钮
- (IBAction)questionHudBtnClick:(id)sender;
- (IBAction)tucaoBtnClick:(id)sender;
@property(nonatomic,weak)id<QuestionBottomViewDelegate> delegate;
@property(nonatomic,strong)NSMutableArray * totalQuestionArr;
@property(nonatomic,strong)ExamQuestionModel * questionModel;


@end
