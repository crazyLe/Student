//
//  SubjectExamCollectionVC.m
//  学员端
//
//  Created by zuweizhong  on 16/8/4.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

//
//  SubjectExamController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/15.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SubjectExamCollectionVC.h"
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
@interface SubjectExamCollectionVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,QuestionBottomViewDelegate,UITextFieldDelegate,SubjectExamCollectionCellDelegate,TotalQuestionViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UIView * topView;
@property(nonatomic,strong)TopButton * currentBtn;
@property(nonatomic,strong)TotalQuestionView * totalQuestionView;
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
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)int startSecond;
@property(nonatomic,strong)UILabel * titleTimeLabel;

@property (nonatomic, assign) BOOL isKeyboardShow;

@end

@implementation SubjectExamCollectionVC
#pragma mark -- lifecycle
- (void)dealloc {
    [self removeObservers];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.jt_navigationController.fullScreenPopGestureEnabled = YES;
    [self.totalQuestionView dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f7f6"];
    self.jt_navigationController.fullScreenPopGestureEnabled = NO;
    self.startSecond = 2700;//45分钟
    if (self.isExamination) {//是模考模式
        [self configNav];
    } else {
        if (self.isSubjectOne) {
            [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"科一试题库"];
        } else {
            [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"科四试题库"];
        }
    }

    if (self.isSubjectOne) {//是科目一
        if (self.isExamination) {//科目一模考
            self.allDataArray = [NSMutableArray array];
            self.allDataArray = [[ExamQuestionDataBase shareInstance]query100ExamOneQuestions].mutableCopy;
        }
        else//科目一做题
        {
            self.classTypeNumArray = [NSMutableArray array];
            self.classTypeTitleArray = [NSMutableArray arrayWithObjects:@"距离",@"罚款",@"速度",@"记分",@"手势",@"酒驾",@"仪表",@"装置",@"路况", nil];
            self.allDataArray = [NSMutableArray array];
            self.allDataArray = [[ExamQuestionDataBase shareInstance]queryExamOneQuestion].mutableCopy;
            for (int i = 0; i<self.classTypeTitleArray.count; i++) {
                NSString *key = self.classTypeTitleArray[i];
                NSMutableArray *temp = [[ExamQuestionDataBase shareInstance]queryExamOneQuestionWithClassType:key].mutableCopy;
                [self.classTypeNumArray addObject:temp];
            }
        }
    }
    else//是科目四
    {
        if (self.isExamination) {//科目四模考
            self.allDataArray = [NSMutableArray array];
            self.allDataArray = [[ExamQuestionDataBase shareInstance]query50ExamFourQuestions].mutableCopy;
        }
        else//科目四做题
        {
            self.classTypeNumArray = [NSMutableArray array];
            self.classTypeTitleArray = [NSMutableArray arrayWithObjects:@"时间",@"距离",@"速度",@"手势",@"酒驾",@"装置",@"路况",@"信号", nil];
            self.allDataArray = [NSMutableArray array];
            self.allDataArray = [[ExamQuestionDataBase shareInstance]queryExamFourQuestion].mutableCopy;
            for (int i = 0; i<self.classTypeTitleArray.count; i++) {
                NSString *key = self.classTypeTitleArray[i];
                NSMutableArray *temp = [[ExamQuestionDataBase shareInstance]queryExamFourQuestionWithClassType:key].mutableCopy;
                [self.classTypeNumArray addObject:temp];
            }
        }
    }

    [self createUI];
    [self addObservers];
}

-(void)configNav {
    //创建左边的按钮
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.frame = CGRectMake(0,10, 20, 20);
    
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    //创建中间的title
    UIView *titleView = [[UIView alloc]init];
    titleView.frame = CGRectMake(kScreenWidth/2-10, 10, 30, 35);
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.image = [UIImage imageNamed:@"iconfont-naozhong"];
    imgView.frame = CGRectMake(5, 0, titleView.width-10, 20);
    [titleView addSubview:imgView];
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:10];
    label.text = [NSString timeFormatFromSeconds:self.startSecond];
    label.textColor = [UIColor whiteColor];
    self.titleTimeLabel = label;
    label.frame = CGRectMake(0, 25, titleView.width, 10);
    label.textAlignment = NSTextAlignmentCenter;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    [titleView addSubview:label];

    self.navigationItem.titleView = titleView;

    //创建右边的按钮
    UIView *rightBtnView = [[UIView alloc]init];
    rightBtnView.frame = CGRectMake(kScreenWidth/2-10, 10, 30, 35);
    [rightBtnView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {

        [self submit];

    }]];
    
    UIImageView *imgView1 = [[UIImageView alloc]init];
    imgView1.image = [UIImage imageNamed:@"iconfont-shijuan"];
    imgView1.frame = CGRectMake(5, 0, titleView.width-10, 20);
    [rightBtnView addSubview:imgView1];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.font = [UIFont systemFontOfSize:10];
    label1.text = @"交卷";
    label1.textColor = [UIColor whiteColor];
    label1.frame = CGRectMake(0, 25, titleView.width, 10);
    label1.textAlignment = NSTextAlignmentCenter;
    [rightBtnView addSubview:label1];

    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtnView];

    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

- (void)addObservers {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter  addObserver:self selector:@selector(keyboardDidShow)  name:UIKeyboardDidShowNotification  object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardWillHide)  name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark -- keyboard action
- (void)keyboardDidShow {
    self.isKeyboardShow = YES;
}

- (void)keyboardWillHide {
    self.isKeyboardShow = NO;
}

-(void)submit {
    [self.timer invalidate];
    self.timer = nil;
    NSUInteger unDoNum = self.dataArray.count - self.inCorrectQuestionArr.count-self.correctQuestionArr.count;
    NSString *msg = nil;
    if (unDoNum == 0) {
        msg = @"时间到了,确认交卷?";
    } else {
        msg = [NSString stringWithFormat:@"还有%ld题未做,是否交卷?",unDoNum];
    }
    //初始化AlertView
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"交卷", nil];
    [alertView show];
}

-(void)timeChange {
    self.startSecond = self.startSecond - 1;
    
    if (self.startSecond == 0) {
        
        [self submit];
        [self.timer invalidate];
        self.timer = nil;
    }
 
    NSString *time = [NSString timeFormatFromSeconds:self.startSecond];
    
    self.titleTimeLabel.text = time;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"交卷");
        [self.hudManager showNormalStateSVHUDWithTitle:@"正在提交..."];
        NSString *url = self.interfaceManager.synchronousScoreUrl;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSString *time = [HttpParamManager getTime];
        param[@"uid"] = kUid;
        param[@"time"] = time;
        param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/questions/synchronousScore" time:time];
        param[@"deviceInfo"] =[HttpParamManager getDeviceInfo];
        param[@"subject"] = self.isSubjectOne==YES?@"1":@"4";
        param[@"score"] = [NSString stringWithFormat:@"%ld",self.correctQuestionArr.count];
        param[@"timeUsed"] = @(2700-self.startSecond);
        
        NSMutableDictionary *resultDict =[NSMutableDictionary dictionary];
        
        for (int i = 0; i<self.dataArray.count; i++) {
            ExamQuestionModel *model = self.dataArray[i];
            if (model.answerState == 1) {//做对
                [resultDict setObject:@(1) forKey:[NSString stringWithFormat:@"%d",model.idNum]];
            }
            if (model.answerState == 2) {//做错
                [resultDict setObject:@(0) forKey:[NSString stringWithFormat:@"%d",model.idNum]];
            }
        }
        NSString *json = resultDict.mj_JSONString;
        param[@"testResult"] = json;
        
        [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            HJLog(@"%@",dict);
            NSInteger code = [dict[@"code"] integerValue];
            NSString *msg = dict[@"msg"];
            
            if (code == 1) {
                
                [self.hudManager showSuccessSVHudWithTitle:msg hideAfterDelay:1.0 animaton:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    ExamRecordController *mistakeVC= [[ExamRecordController alloc]init];
                    if (self.isSubjectOne) {
                        mistakeVC.subjectNum = @"一";
                    }
                    else
                    {
                        mistakeVC.subjectNum = @"四";
                    }
                    JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:mistakeVC];
                    [self presentViewController:nav animated:YES completion:^{
                        [self.navigationController popViewControllerAnimated:NO];
                    }];
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
    }
    else
    {
        //重新计时考试
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

-(void)doneAction:(id)item {
    _bottomView.questionHudBtn.hidden = NO;
    _bottomView.correctBtn.hidden = NO;
    _bottomView.incorrectBtn.hidden = NO;
    _bottomView.inputTextField.hidden = YES;
    [self.bottomView.inputTextField resignFirstResponder];
}

-(void)createUI {
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
    
    if (self.isSubjectOne) {//科目一
        if (self.isExamination) {//科目一模考
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight - 50) collectionViewLayout:layout];

        }
        else//科目一做题
        {
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - kNavHeight - 40-50) collectionViewLayout:layout];
        }
    }
    else
    {
        if (self.isExamination) {//科目四模考
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight - 50) collectionViewLayout:layout];
            
        }
        else//科目四做题
        {
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - kNavHeight - 40-50) collectionViewLayout:layout];
        }
    
    }
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = BG_COLOR;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[SubjectExamCollectionCell class] forCellWithReuseIdentifier:@"SubjectExamCollectionCell"];

   
    //创建底部的BottomView
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
    
    if (self.isExamination) {//是模考模式
        self.bottomView.tuCaoBtn.hidden = YES;
        self.bottomView.correctBtnLeftPaddingConstraint.constant = kScreenWidth-200;
    }


    
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
    
    //三角形
    UIImageView *anchorImageView = [[UIImageView alloc]init];
    anchorImageView.image = [UIImage imageNamed:@"三角形"];
    self.anchorImageView = anchorImageView;
    anchorImageView.size = CGSizeMake(15, 7);
    anchorImageView.center = CGPointMake(kScreenWidth*0.9, 37);
    [self.view addSubview:anchorImageView];
}

#pragma mark -- collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"SubjectExamCollectionCell";
    SubjectExamCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.isExamination = self.isExamination;
    self.currentIndexPathRow = (int)indexPath.row+1;
    cell.delegate = self;
    cell.currentQuestionModel = self.dataArray[indexPath.row];
    cell.isIminiteShowComment = NO;
    return cell;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self updateQuestionBottomViewWithIndex:self.currentIndexPathRow];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //image是正方形,此时高度要自适应
    CGSize size = CGSizeMake(kScreenWidth,  kScreenHeight - kNavHeight - 40-50);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

-(void)questionBottomView:(QuestionBottomView *)bottomView didClickTuCaoButtonWithQuestionId:(ExamQuestionModel *)questionModel {
    self.currentModel = questionModel;
    self.currentQuestionId = questionModel.idNum;

    if (self.isKeyboardShow) {
        [self commitComplaint];
    } else {
        bottomView.questionHudBtn.hidden = YES;

        bottomView.correctBtn.hidden = YES;

        bottomView.incorrectBtn.hidden = YES;

        bottomView.inputTextField.hidden = NO;

        bottomView.inputTextField.delegate = self;

        [bottomView.inputTextField becomeFirstResponder];
    }
}

- (void)commitComplaint {
    if ([self.bottomView.inputTextField.text isEqualToString:@""]||self.bottomView.inputTextField.text == nil) {
        [self.hudManager showErrorSVHudWithTitle:@"评论不能为空" hideAfterDelay:1.0];
        return;
    }
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
            [_bottomView.inputTextField resignFirstResponder];
            _bottomView.inputTextField.hidden = YES;
            _bottomView.inputTextField.text = nil;

            [self.hudManager showSuccessSVHudWithTitle:@"评论成功" hideAfterDelay:1.0 animaton:YES];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadCommentList];
            });
        } else if(code == 2) {
            //验证失败，去登录
            LoginGuideController *loginVC = [[LoginGuideController alloc]init];
            JTNavigationController *loginnavC = [[JTNavigationController alloc] initWithRootViewController:loginVC];
            loginnavC.fullScreenPopGestureEnabled = YES;
            self.view.window.rootViewController = loginnavC;
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }

    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];
}

-(void)subjectExamCollectionCell:(SubjectExamCollectionCell *)cell didClickMoreCommentBtnWithExamQuestionModel:(ExamQuestionModel *)model {
    MoreMistakeAnalyseVC *moreVC = [[MoreMistakeAnalyseVC alloc]init];
    moreVC.currentQuestionModel = model;
    [self.navigationController pushViewController:moreVC animated:YES];
}

-(void)subjectExamCollectionCell:(SubjectExamCollectionCell *)cell didClickSubmitBtnWithExamQuestionModel:(ExamQuestionModel *)model
{
    if (self.isExamination) {//是模考
        if (self.collectionView.contentOffset.x == self.collectionView.contentSize.width-kScreenWidth) {
            
            [self updateQuestionBottomViewWithIndex:self.currentIndexPathRow];
            
            return;
        }
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x+kScreenWidth, self.collectionView.contentOffset.y) animated:YES];
    }
    if (model.answerState== 1 &&!self.isExamination) {//答对,不是模考
        if (self.collectionView.contentOffset.x == self.collectionView.contentSize.width-kScreenWidth) {
            
            [self updateQuestionBottomViewWithIndex:self.currentIndexPathRow];

            return;
        }
        [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x+kScreenWidth, self.collectionView.contentOffset.y) animated:YES];
    }
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
    
    //已答错11题，提示提交试题
    
    if (self.isSubjectOne ) {//是科目一
        if (self.isExamination) {
            if (self.inCorrectQuestionArr.count == 11) {
                
                NSString *msg = nil;
                msg = [NSString stringWithFormat:@"您已答错11题,成绩不合格,是否交卷?"];
                //初始化AlertView
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"继续答题" otherButtonTitles:@"交卷", nil];
                [alertView show];
                
            }
        }
       
    }
    else//是科目四
    {
        if (self.isExamination) {
            if (self.inCorrectQuestionArr.count == 6) {
                
                NSString *msg = nil;
                msg = [NSString stringWithFormat:@"您已答错6题,成绩不合格,是否交卷?"];
                //初始化AlertView
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"继续答题" otherButtonTitles:@"交卷", nil];
                [alertView show];
                
            }
        }
    }

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

- (void)back {
    if (self.timer == nil) {//已提交
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.isExamination) {
        [self submit];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end


