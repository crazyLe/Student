//
//  ExamQuestionModel.h
//  学员端
//
//  Created by zuweizhong  on 16/7/16.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamQuestionModel : NSObject

@property(nonatomic,assign)int  idNum;//'用户编号'
@property(nonatomic,assign)int  multi_radio;//'1单选题、2多选题、3判断题'
@property(nonatomic,strong)NSString * name_bin;//'试题名称',
@property(nonatomic,strong)NSString * option;//'试题选项'
@property(nonatomic,strong)NSString * answer;//'答案'
@property(nonatomic,strong)NSString * test_answer_bin;//'试题解答分析'
@property(nonatomic,strong)NSData * image_bin;// '图片地址'
@property(nonatomic,assign)int  type;//'考题类型（科目一,科目二等）1 科目一  4 科目四',
@property(nonatomic,strong)NSString * class_type;//'题目类型 分号分隔'
@property(nonatomic,assign)NSInteger  addtime;//'时间'
@property(nonatomic,assign)int  is_del;//'是否删除 1删除',
@property(nonatomic,assign)int  chapter;//'所属章节  详情对照  exam_chapter',
@property(nonatomic,assign)int  media_type;//1文字题  2 图片题  3 动画题
@property(nonatomic,assign)float err_rate;//试题错误率
@property(nonatomic,assign)int  is_img;//1文字题  2 图片题  3 动画题


/**
 *  是否点击选中准备答题
 */
@property(nonatomic,assign)BOOL isPrepareAnswered;
/**
 *  是否已答题
 */
@property(nonatomic,assign)BOOL isAnswered;
/**
 *  是否答题正确,0表示未答题，1表示答对，2表示答错
 */
@property(nonatomic,assign)int answerState;
/**
 *  答题时选择的indexPath
 */
@property(nonatomic,strong)NSMutableArray * selectedIndexPathArray;
/**
 *  本题的评论数组（第一页）
 */
@property(nonatomic,strong)NSMutableArray * commentArray;
/**
 *  本题的评论总数
 */
@property(nonatomic,assign)int commentTotalNum;
/**
 *  是模考把这题做错还是做题把这题做错（1表示 做题   2表示模考）
 */
@property(nonatomic,assign)int mistakeType;




@end
