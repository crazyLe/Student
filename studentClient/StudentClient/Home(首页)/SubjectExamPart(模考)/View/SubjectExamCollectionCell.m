//
//  SubjectExamCollectionCell.m
//  学员端
//
//  Created by zuweizhong  on 16/8/4.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SubjectExamCollectionCell.h"
#import "ExamQuestionCell.h"
#import "ExamQuestionTopCell.h"
#import "AnswerBtnCell.h"
#import "ExamQuestionAnalyseCell.h"
#import "TuCaoFooterCell.h"
#import "TuCaoHeaderCell.h"
#import "TuCaoCell.h"
#import "QuestionCommentModel.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "MistakeQuestionDataBase.h"
@interface SubjectExamCollectionCell()<UITableViewDelegate,UITableViewDataSource,TuCaoFooterCellDelegate,AnswerBtnCellDelegate,TuCaoCellDelegate>

@property(nonatomic,strong)NSMutableArray * optionArray;

@end

@implementation SubjectExamCollectionCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //创建底部的tableView
        self.optionArray = [NSMutableArray arrayWithObjects:@"A",@"B",@"C",@"D", nil];

        UITableView *bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-kNavHeight-40-50) style:UITableViewStylePlain];
        self.bottomTableView = bottomTableView;
        self.bottomTableView.delegate = self;
        self.bottomTableView.dataSource = self;
        
        bottomTableView.backgroundColor = [UIColor clearColor];
        [bottomTableView setExtraCellLineHidden];
        [bottomTableView setCellLineFullInScreen];
        bottomTableView.separatorColor = [UIColor colorWithHexString:@"ececec"];
        [self.contentView addSubview:bottomTableView];
        [bottomTableView registerNib:[UINib nibWithNibName:@"ExamQuestionAnalyseCell" bundle:nil] forCellReuseIdentifier:@"ExamQuestionAnalyseCell"];
        [bottomTableView registerNib:[UINib nibWithNibName:@"TuCaoCell" bundle:nil] forCellReuseIdentifier:@"TuCaoCell"];
    }
    return self;
}

-(void)setIsIminiteShowComment:(BOOL)isIminiteShowComment {
    _isIminiteShowComment = isIminiteShowComment;
    
    if (isIminiteShowComment) {//是立即显示,获取评论
        [self loadNoHudCommentList];
    }
}

-(void)setCurrentQuestionModel:(ExamQuestionModel *)currentQuestionModel {
    _currentQuestionModel = currentQuestionModel;
    if (currentQuestionModel.selectedIndexPathArray == nil) {
        currentQuestionModel.selectedIndexPathArray = [NSMutableArray array];
    }
    [self.bottomTableView reloadData];
}

#pragma mark - TableViewDelegate & DataSoure
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.currentQuestionModel.isAnswered) {
        if (section == 1) {
            return 10;
        }
        if (section == 2) {
            return 10;
        }
    } else {
        return CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.currentQuestionModel.isAnswered) {
        if (self.isExamination) {
            return 1;
        }
        return 3;
    }
    if(self.currentQuestionModel.multi_radio == 1||self.currentQuestionModel.multi_radio == 3)//单选题或判断题
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentQuestionModel.isAnswered) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0 ) {
                ExamQuestionTopCell *cell = (ExamQuestionTopCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
                return cell.cellHeight;
            } else {
                NSArray *options = [self.currentQuestionModel.option componentsSeparatedByString:@"；"];
                NSString *str = options[indexPath.row-1];
                CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(kScreenWidth-43-16, MAXFLOAT)];
                return size.height+35;
            }
        }
        
        if (indexPath.section == 1) {
            CGFloat height =  [tableView fd_heightForCellWithIdentifier:@"ExamQuestionAnalyseCell" cacheByIndexPath:indexPath configuration:^(ExamQuestionAnalyseCell * cell) {
                cell.answerLabel.text = [NSString stringWithFormat:@"答案:%@",[self getAnswerWithAnswerString:self.currentQuestionModel.answer]];
                //TODU
                cell.test_answerLabel.text = self.currentQuestionModel.test_answer_bin;
                CGFloat radio = 0;
                radio = self.currentQuestionModel.err_rate;
                cell.incorrectRadioLabel.attributedText = [cell getStringWithRadio:[NSString stringWithFormat:@"%.2f%%",radio]];
            }];
            return height;
        }
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                return 44;
            } else if(indexPath.row == self.currentQuestionModel.commentArray.count+1) {
                return 44;
            } else {
                CGFloat height =  [tableView fd_heightForCellWithIdentifier:@"TuCaoCell" cacheByIndexPath:indexPath configuration:^(TuCaoCell * cell) {
                    cell.commentModel = self.currentQuestionModel.commentArray[indexPath.row-1];
                }];
                return height;
            }
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0 ) {
                ExamQuestionTopCell *cell = (ExamQuestionTopCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
                return cell.cellHeight;
            } else {
                NSArray *options = [self.currentQuestionModel.option componentsSeparatedByString:@"；"];
                NSString *str = options[indexPath.row-1];
                CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(kScreenWidth-43-16, MAXFLOAT)];
                return size.height+35;
            }
        } else {
            return 55;
        }
    }
    
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentQuestionModel.isAnswered) {
        if (section == 0) {
            NSArray *options = [self.currentQuestionModel.option componentsSeparatedByString:@"；"];
            return options.count + 1;
        }
        if (section == 1) {
            return 1;
        }
        if (section == 2) {
            return 2+self.currentQuestionModel.commentArray.count;
        }
    } else {
        if (section == 0) {
            NSArray *options = [self.currentQuestionModel.option componentsSeparatedByString:@"；"];
            return options.count + 1;
        }
        if (section == 1) {
            return 1;
        }
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.currentQuestionModel.isAnswered) {
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                static NSString *identify = @"ExamQuestionTopCell";
                ExamQuestionTopCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
                if (!cell) {
                    cell = [[ExamQuestionTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                //TODU
                cell.contentLabel.text =self.currentQuestionModel.name_bin;
                cell.questionModel = self.currentQuestionModel;
                if (self.currentQuestionModel.multi_radio == 1) {
                    [cell.multi_radioBtn setTitle:@"单选" forState:UIControlStateNormal];
                }
                if (self.currentQuestionModel.multi_radio == 2) {
                    [cell.multi_radioBtn setTitle:@"多选" forState:UIControlStateNormal];
                }
                if (self.currentQuestionModel.multi_radio == 3) {
                    [cell.multi_radioBtn setTitle:@"判断" forState:UIControlStateNormal];
                }
                
                return cell;
            }
            else
            {
                static NSString *identify = @"ExamQuestionCell";
                ExamQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
                if (!cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"ExamQuestionCell" owner:nil options:nil]lastObject];

                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *options = [self.currentQuestionModel.option componentsSeparatedByString:@"；"];
                cell.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
                [cell.optionBtn setTitle:self.optionArray[indexPath.row-1] forState:UIControlStateNormal];
                cell.titleLabel.text = options[indexPath.row-1];
                [cell.optionBtn setBackgroundImage:[UIImage imageNamed:@"科一做题_椭圆-1"] forState:UIControlStateNormal];
                [cell.optionBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];

                return cell;
            }
        }
        else
        {
            static NSString *identify = @"AnswerBtnCell";
            AnswerBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"AnswerBtnCell" owner:nil options:nil]lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (!self.currentQuestionModel.isPrepareAnswered) {
                cell.answerButtom.backgroundColor = [UIColor lightGrayColor];
                cell.answerButtom.userInteractionEnabled = NO;
                
            }else
            {
                cell.answerButtom.backgroundColor = [UIColor colorWithHexString:@"fe5e5d"];
                cell.answerButtom.userInteractionEnabled = YES;
                
            }
            cell.questionModel = self.currentQuestionModel;
            cell.delegate = self;
            return cell;
        }
    }
    else
    {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                static NSString *identify = @"ExamQuestionTopCell";
                ExamQuestionTopCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
                if (!cell) {
                    cell = [[ExamQuestionTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                //TODU
                cell.contentLabel.text = self.currentQuestionModel.name_bin;
                cell.questionModel = self.currentQuestionModel;
                if (self.currentQuestionModel.multi_radio == 1) {
                    [cell.multi_radioBtn setTitle:@"单选" forState:UIControlStateNormal];
                }
                if (self.currentQuestionModel.multi_radio == 2) {
                    [cell.multi_radioBtn setTitle:@"多选" forState:UIControlStateNormal];
                }
                if (self.currentQuestionModel.multi_radio == 3) {
                    [cell.multi_radioBtn setTitle:@"判断" forState:UIControlStateNormal];
                }
                return cell;
            }
            else
            {
                static NSString *identify = @"ExamQuestionCell";
                ExamQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
                if (!cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"ExamQuestionCell" owner:nil options:nil]lastObject];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = [UIColor whiteColor];
                NSArray *options = [self.currentQuestionModel.option componentsSeparatedByString:@"；"];
                [cell.optionBtn setTitle:self.optionArray[indexPath.row-1] forState:UIControlStateNormal];
                cell.titleLabel.text = options[indexPath.row-1];
                cell.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
                [cell.optionBtn setBackgroundImage:[UIImage imageNamed:@"科一做题_椭圆-1"] forState:UIControlStateNormal];
                [cell.optionBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];

                if (!self.isExamination) {//不是模考模式
                    if (self.currentQuestionModel.isAnswered) {
                        
                        //先设置已经选择的几行是否正确的属性
                        for (int i = 0; i<self.currentQuestionModel.selectedIndexPathArray.count; i++)
                        {
                            NSIndexPath *index = self.currentQuestionModel.selectedIndexPathArray[i];
                            if (indexPath == index) {
                                if ([self isCorrectWithIndexPath:index]) {
                                    cell.titleLabel.textColor = [UIColor colorWithHexString:@"7bcc20"];
                                    [cell.optionBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-zhengque-2"] forState:UIControlStateNormal];
                                    [cell.optionBtn setTitle:@"" forState:UIControlStateNormal];
                                    if (self.currentQuestionModel.answerState != 2) {//不是做错
                                        self.currentQuestionModel.answerState = 1;
                                    }
                                }
                                else
                                {
                                    cell.titleLabel.textColor = [UIColor redColor];
                                    [cell.optionBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-cuowu-2"] forState:UIControlStateNormal];
                                    [cell.optionBtn setTitle:@"" forState:UIControlStateNormal];
                                    self.currentQuestionModel.answerState = 2;
                                }
                            }
                        }
                        //再设置正确的答案的高亮显示
                        if ([self isCorrectWithIndexPath:indexPath]) {
                            cell.titleLabel.textColor = [UIColor colorWithHexString:@"7bcc20"];
                            [cell.optionBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-zhengque-2"] forState:UIControlStateNormal];
                            [cell.optionBtn setTitle:@"" forState:UIControlStateNormal];
                        }
                    }
                }
                else//是模考模式
                {
                    cell.contentView.backgroundColor = [UIColor clearColor];

                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                    if (self.currentQuestionModel.isAnswered) {
                
                        for (int i = 0; i<self.currentQuestionModel.selectedIndexPathArray.count; i++)
                        {
                            NSIndexPath *index = self.currentQuestionModel.selectedIndexPathArray[i];
                            //答题选择的indexPath
                            if (indexPath == index) {
                                if ([self isCorrectWithIndexPath:index]) {//不是做错
                                    
                                    [cell.optionBtn setBackgroundImage:[UIImage imageNamed:@"科一做题_椭圆-3"] forState:UIControlStateNormal];
                                }
                                else
                                {
                                    [cell.optionBtn setBackgroundImage:[UIImage imageNamed:@"科一做题_椭圆-6"] forState:UIControlStateNormal];
                                }
                                [cell.optionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            }
                        }
                    }
                }
                return cell;
            }
        }
        
        if (indexPath.section == 1) {
            
            ExamQuestionAnalyseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExamQuestionAnalyseCell" forIndexPath:indexPath];
            cell.answerLabel.text = [NSString stringWithFormat:@"答案:%@",[self getAnswerWithAnswerString:self.currentQuestionModel.answer]];
            //TODU
            cell.test_answerLabel.text = self.currentQuestionModel.test_answer_bin;
            CGFloat radio = 0;
            //TODU
            radio = self.currentQuestionModel.err_rate;
            //TODU
            cell.incorrectRadioLabel.attributedText = [cell getStringWithRadio:[NSString stringWithFormat:@"%.2f%%",radio]];
            
            return cell;
            
        }
        if (indexPath.section == 2) {
            
            if (indexPath.row == 0) {
                
                static NSString *identify = @"TuCaoHeaderCell";
                TuCaoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"TuCaoHeaderCell" owner:nil options:nil]lastObject];
                }
                
                return cell;
            } else if(indexPath.row ==self.currentQuestionModel.commentArray.count+1) {
                static NSString *identify = @"TuCaoFooterCell";
                TuCaoFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"TuCaoFooterCell" owner:nil options:nil]lastObject];
                }
                [cell.moreTuCaoBtn setTitle:[NSString stringWithFormat:@"查看全部%d位学员分析",self.currentQuestionModel.commentTotalNum] forState:UIControlStateNormal];
                cell.delegate = self;
                return cell;
            } else {
                TuCaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TuCaoCell" forIndexPath:indexPath];
                cell.commentModel = self.currentQuestionModel.commentArray[indexPath.row-1];
                cell.delegate = self;
                return cell;
            }
        }
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.currentQuestionModel.multi_radio == 2) {//多选题
        if (!self.currentQuestionModel.isAnswered) {
            
            if (indexPath.section == 0) {
                if (indexPath.row != 0) {
                    for (NSIndexPath *indexPath1 in self.currentQuestionModel.selectedIndexPathArray) {
                        if (indexPath1.row == indexPath.row) {//改行已经选中
                            [self.currentQuestionModel.selectedIndexPathArray removeObject:indexPath1];
                            if (self.currentQuestionModel.selectedIndexPathArray.count >=2) {
                                AnswerBtnCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                                cell.answerButtom.backgroundColor = [UIColor colorWithHexString:@"fe5e5d"];
                                cell.answerButtom.userInteractionEnabled = YES;
                                self.currentQuestionModel.isPrepareAnswered = YES;
                            }
                            else
                            {
                                AnswerBtnCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                                cell.answerButtom.backgroundColor = [UIColor lightGrayColor];
                                cell.answerButtom.userInteractionEnabled = NO;
                                self.currentQuestionModel.isPrepareAnswered = NO;
                            }
                            NSArray *options = [self.currentQuestionModel.option componentsSeparatedByString:@"；"];
                            
                            for (int i = 0; i<options.count; i++) {
                                ExamQuestionCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0]];
                                cell.contentView.backgroundColor = [UIColor whiteColor];
                            }
                            for (NSIndexPath *index in self.currentQuestionModel.selectedIndexPathArray) {
                                
                                ExamQuestionCell *cell = [tableView cellForRowAtIndexPath:index];
                                cell.contentView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
                            }

                            return;
                        }
                    }
                    
                    [self.currentQuestionModel.selectedIndexPathArray addObject:indexPath];
                    
                    if (self.currentQuestionModel.selectedIndexPathArray.count >=2) {
                        AnswerBtnCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                        cell.answerButtom.backgroundColor = [UIColor colorWithHexString:@"fe5e5d"];
                        cell.answerButtom.userInteractionEnabled = YES;
                        
                        self.currentQuestionModel.isPrepareAnswered = YES;
                    }
                    
                    NSArray *options = [self.currentQuestionModel.option componentsSeparatedByString:@"；"];
                    
                    for (int i = 0; i<options.count; i++) {
                        ExamQuestionCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0]];
                        cell.contentView.backgroundColor = [UIColor whiteColor];
                    }
                    for (NSIndexPath *index in self.currentQuestionModel.selectedIndexPathArray) {
                        
                        ExamQuestionCell *cell = [tableView cellForRowAtIndexPath:index];
                        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
                        
                    }
                }
            }
        }
    }
    
    if(self.currentQuestionModel.multi_radio == 1||self.currentQuestionModel.multi_radio == 3) {//单选题或判断题
        if (!self.currentQuestionModel.isAnswered) {
            
            if (indexPath.section == 0) {
                if (indexPath.row != 0) {

                    for (NSIndexPath *indexPath1 in self.currentQuestionModel.selectedIndexPathArray) {
                        if (indexPath1.row == indexPath.row) {
                            return;
                        }
                    }
                    [self.currentQuestionModel.selectedIndexPathArray removeAllObjects];
                    [self.currentQuestionModel.selectedIndexPathArray addObject:indexPath];
                    
                    AnswerBtnCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                    
                    cell.answerButtom.backgroundColor = [UIColor colorWithHexString:@"fe5e5d"];
                    
                    cell.answerButtom.userInteractionEnabled = YES;
                    
                    self.currentQuestionModel.isPrepareAnswered = YES;
                    
                    NSArray *options = [self.currentQuestionModel.option componentsSeparatedByString:@"；"];

                    for (int i = 0; i<options.count; i++) {
                        ExamQuestionCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0]];
                        cell.contentView.backgroundColor = [UIColor whiteColor];
                    }
                    for (NSIndexPath *index in self.currentQuestionModel.selectedIndexPathArray) {
                        
                        ExamQuestionCell *cell = [tableView cellForRowAtIndexPath:index];
                        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
                    }
                    //提交
                    [self answerBtnCell:nil didClickBtnWithModel:self.currentQuestionModel];
   
                }
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(BOOL)isCorrectWithIndexPath:(NSIndexPath *)indexPath {
    NSArray *options = [self.currentQuestionModel.option componentsSeparatedByString:@"；"];
    NSArray *anwserArr = [self.currentQuestionModel.answer componentsSeparatedByString:@"；"];
    NSString *indexPathText = options[indexPath.row-1];
    indexPathText = [indexPathText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    for (NSString *answer in anwserArr) {
        NSString *trimAnswer = [answer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([trimAnswer isEqualToString:indexPathText]) {
            return YES;
        }
    }
    
    return NO;
}

-(NSString *)getAnswerWithAnswerString:(NSString *)str {
    NSArray *options = [self.currentQuestionModel.option componentsSeparatedByString:@"；"];
    
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:4];
    NSArray *answerArr = [str componentsSeparatedByString:@"；"];
    for (int i = 0; i<options.count; i++) {
        NSString *option = options[i];
        option = [option stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        for (NSString *answer in answerArr) {
            NSString *trimAnswer = [answer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([option isEqualToString:trimAnswer]) {
                [result appendString:[NSString stringWithFormat:@" %@",self.optionArray[i]]] ;
            }
        }
    }
    
    return result;
}

-(void)answerBtnCell:(AnswerBtnCell *)cell didClickBtnWithModel:(ExamQuestionModel *)questionModel
{
    questionModel.isAnswered = YES;

    if (self.currentQuestionModel.isAnswered) {
        BOOL result = YES;
        NSArray *answerArray = [self.currentQuestionModel.answer componentsSeparatedByString:@"；"];
        if (self.currentQuestionModel.selectedIndexPathArray.count != answerArray.count) {
            result = NO;
        } else {
            //先设置已经选择的几行是否正确的属性
            for (int i = 0; i<self.currentQuestionModel.selectedIndexPathArray.count; i++) {
                NSIndexPath *index = self.currentQuestionModel.selectedIndexPathArray[i];
                result = result && [self isCorrectWithIndexPath:index];
            }
        }
        
        if (result) {
            if (self.currentQuestionModel.answerState != 2) {//答对
                self.currentQuestionModel.answerState = 1;
                if (self.isDeleteFromDBWhenAnswerCorrect) {
                    //TODU
                    [[MistakeQuestionDataBase shareInstance]deleteDataWithModel:self.currentQuestionModel];
                }
            }
        } else {
            self.currentQuestionModel.answerState = 2;
            //是模考
            if (self.isExamination) {
                self.currentQuestionModel.mistakeType = 2;
            }
            else//不是模考
            {
                self.currentQuestionModel.mistakeType = 1;
            }
            //TODU
            [[MistakeQuestionDataBase shareInstance] insertDataWithModel:self.currentQuestionModel];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(subjectExamCollectionCell:didClickSubmitBtnWithExamQuestionModel:)])
    {
        [self.delegate subjectExamCollectionCell:self didClickSubmitBtnWithExamQuestionModel:self.currentQuestionModel];
    }
    
    
    //是模考模式
    if (self.isExamination) {
        [self.bottomTableView reloadData];
        return;
    }

    //获取评论
    [self loadCommentList];
}

-(void)tuCaoCell:(TuCaoCell *)cell didClickZanBtnWithModel:(QuestionCommentModel *)model
{
    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    NSString *url = self.interfaceManager.commentLikeUrl;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/questions/commentLike" time:time];
    param[@"deviceInfo"] =[HttpParamManager getDeviceInfo];
    param[@"commentsId"] = @(model.commentsId);
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {
            
            [self.hudManager showSuccessSVHudWithTitle:msg hideAfterDelay:1.0 animaton:YES];
            
            [self loadNoHudCommentList];
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];
}

-(void)loadNoHudCommentList
{
    NSString *url = self.interfaceManager.questionsCommentList;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/questions/commentList" time:time];
    param[@"deviceInfo"] =[HttpParamManager getDeviceInfo];
    param[@"questionId"] = @(self.currentQuestionModel.idNum);
    param[@"pageId"] = @(1);
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {
            
            NSArray *arr1 = dict[@"info"][@"data"];
            self.currentQuestionModel.commentArray = [QuestionCommentModel mj_objectArrayWithKeyValuesArray:arr1];
            NSNumber *num = dict[@"info"][@"total"];
            self.currentQuestionModel.commentTotalNum = num.intValue;
            [self.bottomTableView reloadData];
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];
}

-(void)loadCommentList
{
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
    NSString *url = self.interfaceManager.questionsCommentList;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/questions/commentList" time:time];
    param[@"deviceInfo"] =[HttpParamManager getDeviceInfo];
    param[@"questionId"] = @(self.currentQuestionModel.idNum);
    param[@"pageId"] = @(1);

    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {
            
            NSArray *arr1 = dict[@"info"][@"data"];
            self.currentQuestionModel.commentArray = [QuestionCommentModel mj_objectArrayWithKeyValuesArray:arr1];
            NSNumber *num = dict[@"info"][@"total"];
            self.currentQuestionModel.commentTotalNum = num.intValue;
            [self.bottomTableView reloadData];
            [self.hudManager dismissSVHud];
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];
}

-(void)tuCaoFooterCellDidClickMoreBtn:(TuCaoFooterCell *)cell {
    if ([self.delegate respondsToSelector:@selector(subjectExamCollectionCell:didClickMoreCommentBtnWithExamQuestionModel:)])
    {
        [self.delegate subjectExamCollectionCell:self didClickMoreCommentBtnWithExamQuestionModel:self.currentQuestionModel];
    }
}

@end
