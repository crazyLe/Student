//
//  AnswerBtnCell.h
//  学员端
//
//  Created by zuweizhong  on 16/8/4.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamQuestionModel.h"
@class AnswerBtnCell;
@protocol AnswerBtnCellDelegate <NSObject>

-(void)answerBtnCell:(AnswerBtnCell *)cell didClickBtnWithModel:(ExamQuestionModel *)questionModel;

@end

@interface AnswerBtnCell : UITableViewCell
- (IBAction)answerBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *answerButtom;
@property(nonatomic,strong)ExamQuestionModel * questionModel;
@property(nonatomic,weak)id<AnswerBtnCellDelegate> delegate;

@end
