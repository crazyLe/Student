//
//  SubjectExamCollectionVC.m
//  学员端
//
//  Created by zuweizhong  on 16/8/4.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.

#import "MistakeQuestionController.h"
#import "ExamQuestionCell.h"
#import "ExamQuestionTopCell.h"
#import "QuestionBottomView.h"
#import "TotalQuestionView.h"
#import "SubjectExamPopView.h"
#import "CoverView.h"
#import "ExamQuestionDataBase.h"
#import <UIViewController+JTNavigationExtension.h>
#import "TuCaoCell.h"
#import "ExamQuestionAnalyseCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "AnswerBtnCell.h"
#import "TuCaoFooterCell.h"
#import "TuCaoHeaderCell.h"
#import "MoreMistakeAnalyseVC.h"
#import "SubjectExamCollectionCell.h"
#import <IQUIView+IQKeyboardToolbar.h>
#import "HYEdgeInsetsButton.h"
#import "NSString+SecondsToTime.h"
#import "CLAlertView.h"
#import "ExamRecordController.h"
@interface MistakeQuestionController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,QuestionBottomViewDelegate,UITextFieldDelegate,SubjectExamCollectionCellDelegate,TotalQuestionViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UIView * topView;
@property(nonatomic,strong)TopButton * currentBtn;
@property(nonatomic,strong)TotalQuestionView * totalQuestionView;//吐槽总个试题答对情况弹出view
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)QuestionBottomView * bottomView;
@property(nonatomic,strong)CoverView * cover;//蒙版
@property(nonatomic,strong)SubjectExamPopView * popView;
@property(nonatomic,strong)NSMutableArray * totalQuestionArr;
@property(nonatomic,strong)NSMutableArray * correctQuestionArr;
@property(nonatomic,strong)NSMutableArray * inCorrectQuestionArr;

@property(nonatomic,strong)UIImageView * anchorImageView;//三角形
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSMutableArray * classTypeTitleArray;
@property(nonatomic,strong)NSMutableArray * classTypeNumArray;
@property(nonatomic,assign)int currentIndexPathRow;
@property(nonatomic,assign)int currentQuestionId;
@property(nonatomic,strong)ExamQuestionModel * currentModel;
@property(nonatomic,strong)UILabel * titleTimeLabel;

@end

@implementation MistakeQuestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f7f6"];
    self.jt_navigationController.fullScreenPopGestureEnabled = NO;
    
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:_titleString];

    [self createUI];
    
    
    
    
}
-(void)doneAction:(id)item
{
    if ([self.bottomView.inputTextField.text isEqualToString:@""]||self.bottomView.inputTextField.text == nil) {
        [self.hudManager showErrorSVHudWithTitle:@"评论不能为空" hideAfterDelay:1.0];
        return;
    }
    [self.bottomView.inputTextField resignFirstResponder];
    
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在评论..."];
    NSString *url = self.interfaceManager.questionSayUrl;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/questions/questionSay" time:time];
    param[@"deviceInfo"] =[HttpParamManager getDeviceInfo];
    param[@"questionId"] = @(self.currentQuestionId);
    param[@"content"] = self.bottomView.inputTextField.text;
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {
            
            _bottomView.questionHudBtn.hidden = NO;
            
            _bottomView.correctBtn.hidden = NO;
            
            _bottomView.incorrectBtn.hidden = NO;
            
            _bottomView.inputTextField.hidden = YES;
            
            [self.hudManager showSuccessSVHudWithTitle:@"评论成功" hideAfterDelay:1.0 animaton:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadCommentList];
            });
            
            
        }
        else if(code == 2)
        {
            //验证失败，去登录
            LoginGuideController *loginVC = [[LoginGuideController alloc]init];
            JTNavigationController *loginnavC = [[JTNavigationController alloc] initWithRootViewController:loginVC];
            loginnavC.fullScreenPopGestureEnabled = YES;
            self.view.window.rootViewController = loginnavC;
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            
        }
        
        
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];
    
    _bottomView.inputTextField.text = nil;
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.jt_navigationController.fullScreenPopGestureEnabled = YES;
    [self.totalQuestionView dismiss];
    
}

-(void)createUI
{
    UIView *topView = [[UIView alloc]init];
    
    self.topView = topView;
    
    self.topView.backgroundColor = [UIColor  colorWithHexString:@"#fcfcfc"];
    
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, 40);
    
    [self.view addSubview:self.topView];
    
    
    NSMutableArray *titleArr = [NSMutableArray arrayWithObjects:@"全部",@"标志",@"灯光",@"信号灯",@"更多", nil];
    
    CGFloat btnWidth = kScreenWidth/5;
    
    for (int i = 0; i<5; i++) {
        TopButton *btn = [[TopButton alloc]init];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setImage:[UIImage resizedImageWithName:@"科一做题_单选"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:@"c8c8c8"] forState:UIControlStateNormal];
        btn.tag = 2000+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.frame = CGRectMake(btnWidth*i, 0, btnWidth, 40);
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:btn];
        if (i==0) {
            [self topBtnClick:btn];
        }
    }
    
    
    
    
    //创建Line
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    line.frame = CGRectMake(0, 40-LINE_HEIGHT, kScreenWidth, LINE_HEIGHT);
    [self.topView addSubview:line];
    
    //创建主体的collectionView
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight - 50) collectionViewLayout:layout];
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = BG_COLOR;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[SubjectExamCollectionCell class] forCellWithReuseIdentifier:@"SubjectExamCollectionCell"];
    
    
    //创建底部的BottomView（底部吐槽栏）
    QuestionBottomView *bottomView = [[[NSBundle mainBundle]loadNibNamed:@"QuestionBottomView" owner:nil options:nil]lastObject];
    self.bottomView = bottomView;
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
        make.height.equalTo(@50);
    }];
    [self.bottomView.inputTextField addDoneOnKeyboardWithTarget:self action:@selector(doneAction:)];
    
    //蒙版
    self.cover = [[CoverView alloc] initWithFrame:self.view.bounds];
    _cover.backgroundColor = [UIColor blackColor];
    _cover.alpha = 0.0;
    __weak typeof(self) weakSelf = self;
    _cover.touchBlock = ^{
        
        [weakSelf.totalQuestionView dismiss];
        
        [weakSelf.popView dismissWithDismissCompletionBlock:^{
            weakSelf.popView = nil;
        }];
        
    };
    
    [self.view addSubview:_cover];
    
    
    [self updateQuestionBottomViewWithIndex:1];
    
    
    //试题view弹出框
    self.totalQuestionView = [[TotalQuestionView alloc]init];
    
    self.totalQuestionView.dismissBlock = ^(){
        
        weakSelf.cover.alpha = 0.0;
        [weakSelf.popView dismissWithDismissCompletionBlock:^{
            weakSelf.popView = nil;
        }];
    };

    
    
}
#pragma mark -- collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"SubjectExamCollectionCell";
    SubjectExamCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.isExamination = !self.isShowComment;
    cell.isDeleteFromDBWhenAnswerCorrect = self.isDeleteWhenAnswerCorrect;
    self.currentIndexPathRow = (int)indexPath.row+1;
    cell.delegate = self;
    cell.currentQuestionModel = self.dataArray[indexPath.row];
    cell.isIminiteShowComment = self.isIminiteShowComment;
    return cell;
    
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self updateQuestionBottomViewWithIndex:self.currentIndexPathRow];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //image是正方形,此时高度要自适应
    CGSize size = CGSizeMake(kScreenWidth,  kScreenHeight - kNavHeight - 40-50);
    
    return size;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
}
-(void)questionBottomView:(QuestionBottomView *)bottomView didClickTuCaoButtonWithQuestionId:(ExamQuestionModel *)questionModel
{
    self.currentModel = questionModel;
    
    self.currentQuestionId = questionModel.idNum;
    
    bottomView.questionHudBtn.hidden = YES;
    
    bottomView.correctBtn.hidden = YES;
    
    bottomView.incorrectBtn.hidden = YES;
    
    bottomView.inputTextField.hidden = NO;
    
    bottomView.inputTextField.delegate = self;
    
    [bottomView.inputTextField becomeFirstResponder];
    
}
-(void)subjectExamCollectionCell:(SubjectExamCollectionCell *)cell didClickMoreCommentBtnWithExamQuestionModel:(ExamQuestionModel *)model
{
    MoreMistakeAnalyseVC *moreVC = [[MoreMistakeAnalyseVC alloc]init];
    moreVC.currentQuestionModel = model;
    [self.navigationController pushViewController:moreVC animated:YES];
}
-(void)subjectExamCollectionCell:(SubjectExamCollectionCell *)cell didClickSubmitBtnWithExamQuestionModel:(ExamQuestionModel *)model
{
    [self updateQuestionBottomViewWithIndex:self.currentIndexPathRow];
    
}
-(void)updateQuestionBottomViewWithIndex:(int)row
{
    self.totalQuestionArr = [NSMutableArray array];
    
    for (int i = 0; i<self.dataArray.count; i++) {
        [_totalQuestionArr addObject:@(i)];
    }
    self.bottomView.totalQuestionArr = _totalQuestionArr;
    
    if (row != 0) {
        
        self.bottomView.questionModel = self.dataArray[row-1];
        
    }
    else
    {
        self.bottomView.questionModel = nil;
        
    }
    [self.bottomView.questionHudBtn setTitle:[NSString stringWithFormat:@"%d/%ld",row,_totalQuestionArr.count] forState:UIControlStateNormal];
    NSMutableArray *temp1 = [NSMutableArray array];
    NSMutableArray *temp2 = [NSMutableArray array];
    self.correctQuestionArr = [NSMutableArray array];
    self.inCorrectQuestionArr = [NSMutableArray array];
    for (int i = 0; i<self.dataArray.count; i++) {
        ExamQuestionModel *model = self.dataArray[i];
        if (model.answerState == 1) {
            [temp1 addObject:model];
            [self.correctQuestionArr addObject:@(i)];
        }
        if (model.answerState == 2) {
            [temp2 addObject:model];
            [self.inCorrectQuestionArr addObject:@(i)];
        }
    }
    [self.bottomView.correctBtn setTitle:[NSString stringWithFormat:@"%ld",temp1.count] forState:UIControlStateNormal];
    [self.bottomView.incorrectBtn setTitle:[NSString stringWithFormat:@"%ld",temp2.count] forState:UIControlStateNormal];
    
    
}

-(void)loadCommentList
{
    NSString *url = self.interfaceManager.questionsCommentList;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/questions/commentList" time:time];
    param[@"deviceInfo"] =[HttpParamManager getDeviceInfo];
    param[@"questionId"] = @(self.currentQuestionId);
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {
            
            NSArray *arr1 = dict[@"info"][@"data"];
            self.currentModel.commentArray = [QuestionCommentModel mj_objectArrayWithKeyValuesArray:arr1];
            NSNumber *num = dict[@"info"][@"total"];
            self.currentModel.commentTotalNum = num.intValue;
            
            [self.collectionView reloadData];
            
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
        
        
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];
    
    
    
}

-(void)questionBottomView:(QuestionBottomView *)bottomView didClickQuestionHudBtnWithTotalQuestionArr:(NSMutableArray *)totalQuestionArr
{
    [self.view bringSubviewToFront:self.cover];
    
    self.cover.alpha = 0.5;
    
    self.totalQuestionView.totalQuestionArr = totalQuestionArr;
    
    self.totalQuestionView.correctIndexArray = self.correctQuestionArr;
    
    self.totalQuestionView.incorrectIndexArray = self.inCorrectQuestionArr;
    
    self.totalQuestionView.delegate = self;
    
    [self.totalQuestionView.scrollView setContentOffset:CGPointZero];
    
    [self.totalQuestionView show];
    
}
-(void)totalQuestionView:(TotalQuestionView *)totalView didSelectIndex:(int)index
{
    
    self.currentIndexPathRow = index+1;
    
    [totalView dismiss];
    
    [self.collectionView setContentOffset:CGPointMake(kScreenWidth*(index), 0)];
    
    [self updateQuestionBottomViewWithIndex:self.currentIndexPathRow];
    
    
}


-(void)topBtnClick:(TopButton *)btn
{
    self.currentBtn.selected = NO;
    
    btn.selected = YES;
    
    self.currentBtn = btn;
    
    if (btn.tag == 2004) {
        if (!self.popView) {//弹出
            //右上角弹框
            SubjectExamPopView *popView = [[SubjectExamPopView alloc]init];
            popView.contentController = self;
            __weak typeof(self) weakSelf = self;
            popView.clickItemBlock = ^(PopItemRowView *view,NSMutableArray *classTypeArray){
                //回调
                weakSelf.cover.alpha = 0.0;
                weakSelf.dataArray = classTypeArray;
                if (self.dataArray.count == 0) {
                    [self updateQuestionBottomViewWithIndex:0];
                }else
                {
                    [self updateQuestionBottomViewWithIndex:1];
                }
                [weakSelf.collectionView setContentOffset:CGPointZero];
                [weakSelf.collectionView reloadData];
                [weakSelf.popView dismissWithDismissCompletionBlock:^{
                    weakSelf.popView = nil;
                }];
                
            };
            popView.classTypeTitleArray = self.classTypeTitleArray;
            popView.classTypeNumArray = self.classTypeNumArray;
            popView.frame = CGRectMake(0, 40, kScreenWidth, 335);
            self.popView = popView;
            [self.view bringSubviewToFront:self.cover];
            [self.view bringSubviewToFront:self.anchorImageView];
            [self.popView showWithCompletionBlock:^{
                self.cover.alpha = 0.2;
            }];
        }else//消失
        {
            [self.popView dismissWithDismissCompletionBlock:^{
                self.cover.alpha = 0.0;
                self.popView = nil;
            }];
            
        }
        
        return;
        
    }
    if (btn.tag == 2000) {
        self.dataArray = self.allDataArray;
        [self.collectionView setContentOffset:CGPointZero];
        [self updateQuestionBottomViewWithIndex:1];
        [self.collectionView reloadData];
        return;
    }
    NSString *key = btn.titleLabel.text;
    self.dataArray = [[ExamQuestionDataBase shareInstance]queryExamOneQuestionWithClassType:key].mutableCopy;
    [self.collectionView setContentOffset:CGPointZero];
    [self.collectionView reloadData];
    if (self.dataArray.count == 0) {
        [self updateQuestionBottomViewWithIndex:0];
    }else
    {
        [self updateQuestionBottomViewWithIndex:1];
    }
    
    
    
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end



