//
//  SubjectExamController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/15.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SubjectExamController.h"
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
@interface SubjectExamController ()<UITableViewDelegate,UITableViewDataSource,QuestionBottomViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,AnswerBtnCellDelegate,TuCaoFooterCellDelegate>

@property(nonatomic,strong)UIView * topView;

@property(nonatomic,strong)TopButton * currentBtn;

@property (nonatomic, assign)CGPoint startPoint;

@property(nonatomic,strong)UITableView * currentTableView;//当前显示的tableView
@property(nonatomic,strong)UITableView * bottomTableView;//底部隐藏的tableView
@property(nonatomic,strong)UIPanGestureRecognizer * currentTablePan;//当前显示的tableView手势
@property(nonatomic,strong)UIPanGestureRecognizer * bottomTablePan;//底部隐藏的tableView手势
@property(nonatomic,strong)QuestionBottomView * bottomView;

@property(nonatomic,strong)CoverView * cover;//蒙版

@property(nonatomic,strong)NSMutableArray * totalQuestionArr;

@property(nonatomic,strong)TotalQuestionView * totalQuestionView;

@property(nonatomic,strong)SubjectExamPopView * popView;

@property(nonatomic,strong)UIImageView * anchorImageView;//三角形

@property(nonatomic,strong)NSMutableArray * allDataArray;

@property(nonatomic,strong)NSMutableArray * selectedIndexPathArray;

@property(nonatomic,strong)ExamQuestionModel *currentQuestionModel;

@property(nonatomic,strong)NSMutableArray * optionArray;

@property(nonatomic,assign)int currentPage;

@property(nonatomic,assign)BOOL isLeft;

@end

@implementation SubjectExamController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.currentPage = 0;
    
    self.selectedIndexPathArray = [NSMutableArray array];
    
    self.optionArray = [NSMutableArray arrayWithObjects:@"A",@"B",@"C",@"D", nil];

    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f7f6"];
    
    self.jt_navigationController.fullScreenPopGestureEnabled = NO;
    
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"科一试题库"];
    
    self.allDataArray = [NSMutableArray array];
    
    self.allDataArray = [[ExamQuestionDataBase shareInstance] query].mutableCopy;
    
    self.currentQuestionModel = self.allDataArray[self.currentPage];
    
    [self createUI];
}

-(void)viewDidDisappear:(BOOL)animated {
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
    
    //创建底部的tableView
    UITableView *bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,40,kScreenWidth,kScreenHeight-kNavHeight-40-50) style:UITableViewStylePlain];
    self.bottomTableView = bottomTableView;
    self.bottomTableView.delegate = self;
    self.bottomTableView.dataSource = self;

    bottomTableView.backgroundColor = [UIColor blueColor];
    [bottomTableView setExtraCellLineHidden];
    [bottomTableView setCellLineFullInScreen];
    bottomTableView.separatorColor = [UIColor colorWithHexString:@"ececec"];
    [self.view addSubview:bottomTableView];
    [bottomTableView registerNib:[UINib nibWithNibName:@"ExamQuestionAnalyseCell" bundle:nil] forCellReuseIdentifier:@"ExamQuestionAnalyseCell"];
    [bottomTableView registerNib:[UINib nibWithNibName:@"TuCaoCell" bundle:nil] forCellReuseIdentifier:@"TuCaoCell"];
    //阴影
    bottomTableView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    bottomTableView.layer.shadowOffset =CGSizeMake(4,0);
    bottomTableView.layer.shadowOpacity = 0.5;
    bottomTableView.clipsToBounds = NO;
    bottomTableView.bounces = NO;
    UIPanGestureRecognizer *pan1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(bottomTablePan:)];
    pan1.delegate = self;
    self.bottomTablePan = pan1;
    [bottomTableView addGestureRecognizer:pan1];
    
    
    //创建currentTableView
    UITableView *currentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,40,kScreenWidth,kScreenHeight-kNavHeight-40-50) style:UITableViewStyleGrouped];
    self.currentTableView = currentTableView;
    self.currentTableView.delegate = self;
    self.currentTableView.dataSource = self;
    currentTableView.bounces = NO;
    currentTableView.backgroundColor = [UIColor orangeColor];
    [currentTableView setExtraCellLineHidden];
    [currentTableView setCellLineFullInScreen];
    currentTableView.separatorColor = [UIColor colorWithHexString:@"ececec"];
    [self.view addSubview:currentTableView];
    [currentTableView registerNib:[UINib nibWithNibName:@"ExamQuestionAnalyseCell" bundle:nil] forCellReuseIdentifier:@"ExamQuestionAnalyseCell"];
    [currentTableView registerNib:[UINib nibWithNibName:@"TuCaoCell" bundle:nil] forCellReuseIdentifier:@"TuCaoCell"];
    //阴影
    currentTableView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    currentTableView.layer.shadowOffset = CGSizeMake(4,0);
    currentTableView.layer.shadowOpacity = 0.5;
    currentTableView.clipsToBounds = NO;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(currentTablePan:)];
    pan.delegate = self;
    self.currentTablePan = pan;
    [currentTableView addGestureRecognizer:pan];

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
    //保证只有一条右边阴影
    [self.view bringSubviewToFront:bottomView];
    [self.view bringSubviewToFront:topView];



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
    
    self.totalQuestionArr = [NSMutableArray array];
    
    for (int i = 0; i<100; i++) {
        [_totalQuestionArr addObject:@(i)];
    }
    self.bottomView.totalQuestionArr = _totalQuestionArr;
    
    
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
#pragma mark - 手势冲突处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        
        return YES;
    }

    return NO;
}
#pragma mark -currentTable拖动手势
-(void)currentTablePan:(UIPanGestureRecognizer *)pan
{
    

    if (pan.state == UIGestureRecognizerStateBegan) {//开始
        
        
        NSLog(@"UIGestureRecognizerStateBegan");
        
        self.startPoint = [pan locationInView:self.view];
        
        CGPoint point = [pan translationInView:self.view];
        
        if (point.x>0) {//向右拖动
            
            self.currentPage --;
            
            if (self.currentPage < 0) {
                [self.hudManager showErrorSVHudWithTitle:@"已经是第一题" hideAfterDelay:1.0];
                return;
            }

            self.selectedIndexPathArray = [NSMutableArray array];

         
            self.currentQuestionModel = self.allDataArray[self.currentPage];
            
            [self.bottomTableView reloadData];
            
        }
        else if(point.x<0)//向左移动
        {
            self.currentPage ++;
            if (self.currentPage >= (int)self.allDataArray.count) {
                self.currentPage = (int)self.allDataArray.count-1;
                return;
            }
            if (self.currentPage <0) {
                self.currentPage = 1;
            }
            self.selectedIndexPathArray = [NSMutableArray array];

            self.currentQuestionModel = self.allDataArray[self.currentPage];
            
            [self.bottomTableView reloadData];

        
        }
        else if (point.x == 0 && self.startPoint.x>kScreenWidth/2)
        {
            self.currentPage ++;
            if (self.currentPage >= (int)self.allDataArray.count) {
                self.currentPage = (int)self.allDataArray.count-1;
                return;
            }
            if (self.currentPage <0) {
                self.currentPage = 1;
            }
            self.selectedIndexPathArray = [NSMutableArray array];

            self.currentQuestionModel = self.allDataArray[self.currentPage];
            
            [self.bottomTableView reloadData];
        
        }
        else if (point.x == 0 && self.startPoint.x<=kScreenWidth/2)
        {
            self.currentPage --;
            
            if (self.currentPage < 0) {
                [self.hudManager showErrorSVHudWithTitle:@"已经是第一题" hideAfterDelay:1.0];
                return;
            }
            
            self.selectedIndexPathArray = [NSMutableArray array];

            self.currentQuestionModel = self.allDataArray[self.currentPage];
            
            [self.bottomTableView reloadData];
            
        }
        
        
        
        
    }
    
    else if (pan.state == UIGestureRecognizerStateChanged) {//拖动
        
        if (self.currentPage < 0) {
            return;
        }
        if (self.currentPage >= (int)self.allDataArray.count) {
            return;
        }
        NSLog(@"UIGestureRecognizerStateChanged");
        
        CGPoint point = [pan locationInView:self.view];
        
        CGFloat width = point.x-_startPoint.x;
        
        _currentTableView.scrollEnabled  = NO;

        
        if (width<0) {//向左移动

            CGFloat marginY = point.y- _startPoint.y;
            
            if (ABS(marginY)<25) {//垂直方向小于20才开始改变frame
                self.currentTableView.x =  width;
                if (self.currentTableView.x==-20.0) {
                    NSLog(@"dfvdfv");
                }
                [self.view bringSubviewToFront:_currentTableView];
                [self.view bringSubviewToFront:_bottomView];
                [self.view bringSubviewToFront:_topView];
            }
            
        }else{//向右拖动

            CGFloat marginY = point.y- _startPoint.y;
            
            NSLog(@"-------%f",self.bottomTableView.x);
            
            if (ABS(marginY)<25) {//垂直方向小于20才开始改变frame
                
                self.bottomTableView.x =  -kScreenWidth+width;
                
                [self.view bringSubviewToFront:_bottomTableView];
                [self.view bringSubviewToFront:_bottomView];
                [self.view bringSubviewToFront:_topView];
            }
            
            
        }
        
        
        
    }
    
    else  {//手势结束
        
        _currentTableView.scrollEnabled  = YES;
        
        CGPoint point = [pan locationInView:self.view];
        
        CGFloat width = point.x-_startPoint.x;
        
        if (width<0) {//向左移动
            
            if (self.currentTableView.x == 0) {
                return;
            }
            
            if (self.currentTableView.x<-kScreenWidth*1/4) {
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.currentTableView.x = -kScreenWidth;
                } completion:^(BOOL finished) {
                    
                    self.currentTableView.x = 0;
                    self.bottomTableView.x = 0;
                    
                    [self.view bringSubviewToFront:_bottomTableView];
                    [self.view bringSubviewToFront:_bottomView];
                    [self.view bringSubviewToFront:_topView];
                    
                }];
                
            }else
            {
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.currentTableView.x = 0;
                    
                } completion:^(BOOL finished) {
                    self.bottomTableView.x = 0;
                    
                    [self.view bringSubviewToFront:_currentTableView];
                    [self.view bringSubviewToFront:_bottomView];
                    [self.view bringSubviewToFront:_topView];
                }];
                
            }
            
            
        }else{//向右拖动
            
            if (self.bottomTableView.x == 0) {
                return;
            }
            
            if (self.bottomTableView.x<-kScreenWidth*3/4) {
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.bottomTableView.x = -kScreenWidth;
                } completion:^(BOOL finished) {
                    self.bottomTableView.x = 0;
                    self.currentTableView.x = 0;
                    [self.view bringSubviewToFront:_currentTableView];
                    [self.view bringSubviewToFront:_bottomView];
                    [self.view bringSubviewToFront:_topView];
                }];
                
                
            }else
            {
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.bottomTableView.x = 0;
                    
                } completion:^(BOOL finished) {
                    self.currentTableView.x = 0;
                    [self.view bringSubviewToFront:_bottomTableView];
                    [self.view bringSubviewToFront:_bottomView];
                    [self.view bringSubviewToFront:_topView];
                }];
                
                
            }
            
            
            
        }
        
    }
    
}
#pragma mark -bottomTable拖动手势
-(void)bottomTablePan:(UIPanGestureRecognizer *)pan
{

    
    if (pan.state == UIGestureRecognizerStateBegan) {//开始
        
        NSLog(@"UIGestureRecognizerStateBegan");
        
        self.startPoint = [pan locationInView:self.view];

        CGPoint point = [pan translationInView:self.view];
        
        if (point.x>0) {//向右拖动
            
            self.currentPage --;
            
            if (self.currentPage < 0) {
                [self.hudManager showErrorSVHudWithTitle:@"已经是第一题" hideAfterDelay:1.0];

                return;
            }
            self.selectedIndexPathArray = [NSMutableArray array];

            
            self.currentQuestionModel = self.allDataArray[self.currentPage];
            
            [self.currentTableView reloadData];
            
        }
        else if(point.x<0)//向左移动
        {
            self.currentPage ++;
            if (self.currentPage >= (int)self.allDataArray.count) {
                self.currentPage = (int)self.allDataArray.count-1;
                return;
            }
            if (self.currentPage <0) {
                self.currentPage = 1;
            }
            self.selectedIndexPathArray = [NSMutableArray array];

            self.currentQuestionModel = self.allDataArray[self.currentPage];
            
            [self.currentTableView reloadData];
            
            
        }
        
        else if (point.x == 0 && self.startPoint.x>kScreenWidth/2)
        {
            self.currentPage ++;
            if (self.currentPage >= (int)self.allDataArray.count) {
                self.currentPage = (int)self.allDataArray.count-1;
                return;
            }
            if (self.currentPage <0) {
                self.currentPage = 1;
            }
            self.selectedIndexPathArray = [NSMutableArray array];

            self.currentQuestionModel = self.allDataArray[self.currentPage];
            
            [self.currentTableView reloadData];
            
        }
        else if (point.x == 0 && self.startPoint.x<=kScreenWidth/2)
        {
            self.currentPage --;
            
            if (self.currentPage < 0) {
                [self.hudManager showErrorSVHudWithTitle:@"已经是第一题" hideAfterDelay:1.0];
                return;
            }
            
            self.selectedIndexPathArray = [NSMutableArray array];

            self.currentQuestionModel = self.allDataArray[self.currentPage];
            
            [self.currentTableView reloadData];
            
        }
        
    }
    
    else if (pan.state == UIGestureRecognizerStateChanged) {//拖动
        
        if (self.currentPage < 0) {
            return;
        }
        if (self.currentPage >= (int)self.allDataArray.count) {
            return;
        }
        NSLog(@"UIGestureRecognizerStateChanged");
        
        CGPoint point = [pan locationInView:self.view];
        
        CGFloat width = point.x-_startPoint.x;
        
        _bottomTableView.scrollEnabled  = NO;
        
        if (width<0) {//向左移动
            
           
            
            CGFloat marginY = point.y- _startPoint.y;
            
            if (ABS(marginY)<25) {//垂直方向小于20才开始改变frame
            
                self.bottomTableView.x =  width;
                
                [self.view bringSubviewToFront:_bottomTableView];
                [self.view bringSubviewToFront:_bottomView];
                [self.view bringSubviewToFront:_topView];
                
            }
            
        }else{//向右拖动
            
            CGFloat marginY = point.y- _startPoint.y;

            if (ABS(marginY)<25) {//垂直方向小于20才开始改变frame

                self.currentTableView.x =  -kScreenWidth+width;
                
                [self.view bringSubviewToFront:self.currentTableView];
                [self.view bringSubviewToFront:_bottomView];
                [self.view bringSubviewToFront:_topView];
         
            }
        }
        
        
        
    }
    
    else  {//手势结束
        _bottomTableView.scrollEnabled  = YES;

        
        CGPoint point = [pan locationInView:self.view];
        
        CGFloat width = point.x-_startPoint.x;
        
        if (width<0) {//向左移动
            
            if (self.bottomTableView.x == 0) {
                return;
            }
            
            if (self.bottomTableView.x<-kScreenWidth*1/4) {
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.bottomTableView.x = -kScreenWidth;
                } completion:^(BOOL finished) {
                    self.bottomTableView.x = 0;
                    self.currentTableView.x = 0;
                    [self.view bringSubviewToFront:_currentTableView];
                    [self.view bringSubviewToFront:_bottomView];
                    [self.view bringSubviewToFront:_topView];
                }];
                
                
            }else
            {
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.bottomTableView.x = 0;
                    
                } completion:^(BOOL finished) {
                    self.currentTableView.x = 0;

                    [self.view bringSubviewToFront:_bottomTableView];
                    [self.view bringSubviewToFront:_bottomView];
                    [self.view bringSubviewToFront:_topView];
                }];
                
            }
            
            
        }else{//向右拖动
            
            if (self.currentTableView.x == 0) {
                return;
            }
            
            
            if (self.currentTableView.x<-kScreenWidth*3/4) {
                
                [UIView animateWithDuration:0.25 animations:^{
                    self.currentTableView.x = -kScreenWidth;
                } completion:^(BOOL finished) {
                    self.currentTableView.x = 0;
                    self.bottomTableView.x = 0;

                    [self.view bringSubviewToFront:_bottomTableView];
                    [self.view bringSubviewToFront:_bottomView];
                    [self.view bringSubviewToFront:_topView];
                    
                }];
                
            }else
            {
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.currentTableView.x = 0;
                    
                } completion:^(BOOL finished) {
                    self.bottomTableView.x = 0;

                    [self.view bringSubviewToFront:_currentTableView];
                    [self.view bringSubviewToFront:_bottomView];
                    [self.view bringSubviewToFront:_topView];
                }];
                
                
            }
            
            
            
        }
        
    }
    



}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{

    self.currentTablePan.enabled = YES;
    
    self.bottomTablePan.enabled = YES;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentTablePan.enabled = YES;
    
    self.bottomTablePan.enabled = YES;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.currentTablePan.enabled = YES;
    
    self.bottomTablePan.enabled = YES;

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    self.currentTablePan.enabled = NO;

    self.bottomTablePan.enabled = NO;

}
-(void)questionBottomView:(QuestionBottomView *)bottomView didClickTuCaoButtonWithQuestionId:(int)questionId
{
    bottomView.questionHudBtn.hidden = YES;
    
    bottomView.correctBtn.hidden = YES;
    
    bottomView.incorrectBtn.hidden = YES;
    
    bottomView.inputTextField.hidden = NO;
    
    bottomView.inputTextField.delegate = self;
    
    [bottomView.inputTextField becomeFirstResponder];
    


}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _bottomView.questionHudBtn.hidden = NO;
    
    _bottomView.correctBtn.hidden = NO;
    
    _bottomView.incorrectBtn.hidden = NO;
    
    _bottomView.inputTextField.hidden = YES;
    
    _bottomView.inputTextField.text = nil;

}

-(void)questionBottomView:(QuestionBottomView *)bottomView didClickQuestionHudBtnWithTotalQuestionArr:(NSMutableArray *)totalQuestionArr
{
    [self.view bringSubviewToFront:self.cover];
    
    self.cover.alpha = 0.5;
    
    self.totalQuestionView.totalQuestionArr = totalQuestionArr;

    [self.totalQuestionView show];

}

#pragma mark - TableViewDelegate & DataSoure
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.currentQuestionModel.isAnswered) {
        if (section == 1) {
            return 10;
        }
        if (section == 2) {
            return 10;
        }
    }
    else
    {
        return CGFLOAT_MIN;

    }
    
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentQuestionModel.isAnswered) {
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0 ) {
                ExamQuestionTopCell *cell = (ExamQuestionTopCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
                return cell.cellHeight;
            }
            else
            {
                return 55;
            }
        }
        
        if (indexPath.section == 1) {
            CGFloat height =  [tableView fd_heightForCellWithIdentifier:@"ExamQuestionAnalyseCell" cacheByIndexPath:indexPath configuration:^(id cell) {
                
            }];
            return height;
        }
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                return 44;
            }
            else if(indexPath.row == 4)
            {
                return 44;
            }
            else
            {
                CGFloat height =  [tableView fd_heightForCellWithIdentifier:@"TuCaoCell" cacheByIndexPath:indexPath configuration:^(id cell) {
                    
                }];
                return height;
                
            }
        }
        
        
        
    }
    else
    {
        if (indexPath.section == 0) {
            if (indexPath.row == 0 ) {
                ExamQuestionTopCell *cell = (ExamQuestionTopCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
                return cell.cellHeight;
            }
            else
            {
                return 55;
            }
        }
        else
        {
            return 55;
        }
  
    }
    
    return 0;
    
  
}
/**
 返回每一行的估计高度（IOS7以及以后）(使用UITableView+FDTemplateLayoutCell必须添加)
 只返回了估计高度，那么就会先调用tableView:cellForRowIndexPath:方法创建cell，在调
 用tableView heightForRowAtIndexPath:方法获取cell的真实高度。
 */
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.currentQuestionModel.isAnswered) {
        if (section == 0) {
            NSArray *options = [self.currentQuestionModel.option componentsSeparatedByString:@"；"];
            return options.count + 1;
        }
        if (section == 1) {
            return 1;
        }
        if (section == 2) {
            return 5;
        }
    }
    else
    {
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.currentQuestionModel.isAnswered) {
        return 3;
    }
    return 2;
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
                cell.contentLabel.text = self.currentQuestionModel.name_bin;
                
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
                    
                    UIImageView *imageView = [[UIImageView alloc]init];
                    imageView.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"EEEEEE"]];
                    cell.selectedBackgroundView = imageView;
                    
                }
                NSArray *options = [self.currentQuestionModel.option componentsSeparatedByString:@"；"];

                [cell.optionBtn setTitle:self.optionArray[indexPath.row-1] forState:UIControlStateNormal];
                cell.titleLabel.text = options[indexPath.row-1];
                
                return cell;
                
            }

        }
        else
        {
            static NSString *identify = @"AnswerBtnCell";
            AnswerBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"AnswerBtnCell" owner:nil options:nil]lastObject];
            }
            if (!self.currentQuestionModel.isAnswered) {
                cell.answerButtom.backgroundColor = [UIColor lightGrayColor];
                cell.answerButtom.userInteractionEnabled = NO;

            }else
            {
                cell.answerButtom.backgroundColor = [UIColor redColor];
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
                NSArray *options = [self.currentQuestionModel.option componentsSeparatedByString:@"；"];
                
                [cell.optionBtn setTitle:self.optionArray[indexPath.row-1] forState:UIControlStateNormal];
                cell.titleLabel.text = options[indexPath.row-1];
                cell.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];

                if (self.currentQuestionModel.isAnswered) {
                    
                    //先设置已经选择的几行是否正确的属性
                    for (int i = 0; i<self.selectedIndexPathArray.count; i++)
                    {
                        NSIndexPath *index = self.selectedIndexPathArray[i];
                        if (indexPath == index) {
                            if ([self isCorrectWithIndexPath:index]) {
                                cell.titleLabel.textColor = [UIColor colorWithHexString:@"7bcc20"];
                                [cell.optionBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-zhengque-2"] forState:UIControlStateNormal];
                                [cell.optionBtn setTitle:@"" forState:UIControlStateNormal];
                            }
                            else
                            {
                                cell.titleLabel.textColor = [UIColor redColor];
                                [cell.optionBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-cuowu-2"] forState:UIControlStateNormal];
                                [cell.optionBtn setTitle:@"" forState:UIControlStateNormal];


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
            }
            else if(indexPath.row ==4)
            {
                
                static NSString *identify = @"TuCaoFooterCell";
                TuCaoFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"TuCaoFooterCell" owner:nil options:nil]lastObject];
                }
                cell.delegate = self;
                return cell;
            }
            else
            {
                TuCaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TuCaoCell" forIndexPath:indexPath];
                
                return cell;
                
            }
        }
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.currentQuestionModel.isAnswered) {
        
        if (indexPath.section == 0) {
            if (indexPath.row != 0) {

            ExamQuestionCell *cell1 =[tableView cellForRowAtIndexPath:indexPath];
            cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.currentQuestionModel.multi_radio == 2) {//多选题
        if (!self.currentQuestionModel.isAnswered) {
            
            if (indexPath.section == 0) {
                if (indexPath.row != 0) {
                    ExamQuestionCell *cell1 =[tableView cellForRowAtIndexPath:indexPath];
                    cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
                    for (NSIndexPath *indexPath1 in self.selectedIndexPathArray) {
                        if (indexPath1.row == indexPath.row) {
                            return;
                        }
                    }
                    
                    [self.selectedIndexPathArray addObject:indexPath];
                    
                    if (self.selectedIndexPathArray.count >=2) {
                        AnswerBtnCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                        cell.answerButtom.backgroundColor = [UIColor redColor];
                        cell.answerButtom.userInteractionEnabled = YES;
                    }
                }
            }
        }
    }
    
    if(self.currentQuestionModel.multi_radio == 1) {//单选题
        if (!self.currentQuestionModel.isAnswered) {
            
            if (indexPath.section == 0) {
                if (indexPath.row != 0) {
                    ExamQuestionCell *cell1 =[tableView cellForRowAtIndexPath:indexPath];
                    cell1.contentView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
                    for (NSIndexPath *indexPath1 in self.selectedIndexPathArray) {
                        if (indexPath1.row == indexPath.row) {
                            return;
                        }
                    }
                    
                    [self.selectedIndexPathArray addObject:indexPath];
                    
                    
                    AnswerBtnCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                    
                    cell.answerButtom.backgroundColor = [UIColor redColor];
                    
                    cell.answerButtom.userInteractionEnabled = YES;
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

-(void)answerBtnCell:(AnswerBtnCell *)cell didClickBtnWithModel:(ExamQuestionModel *)questionModel {
    questionModel.isAnswered = YES;
    
    [self.bottomTableView reloadData];
    
    [self.currentTableView reloadData];
}

-(void)tuCaoFooterCellDidClickMoreBtn:(TuCaoFooterCell *)cell {
    MoreMistakeAnalyseVC *moreVC = [[MoreMistakeAnalyseVC alloc]init];
    
    [self.navigationController pushViewController:moreVC animated:YES];
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
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end



@implementation TopButton
/**
 *  代码创建
 *
 *  @return instancetype
 */
-(instancetype)init
{
    if (self = [super init]) {
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return self;
    
}
/**
 *  XIB创建
 *
 *  @param aDecoder aDecoder
 *
 *  @return instancetype
 */
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return self;
    
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = contentRect.size.width/8;
    
    CGFloat y = contentRect.size.height/4-3;
    
    CGFloat width = contentRect.size.width*3/4 ;
    
    CGFloat height = contentRect.size.height/2+6 ;
    
    return CGRectMake(x, y, width, height);
    
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 0;
    
    CGFloat y =  0 ;
    
    CGFloat width = contentRect.size.width;
    
    CGFloat height = contentRect.size.height ;
    
    return CGRectMake(x, y, width, height);
    
}


@end
