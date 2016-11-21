//
//  MistakeAnalyseVC.m
//  学员端
//
//  Created by gaobin on 16/7/19.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MistakeAnalyseVC.h"
#import "QuestionBottomView.h"
#import "ExamQuestionTopCell.h"
#import "ExamQuestionCell.h"
#import "ExamQuestionAnalyseCell.h"
#import "TuCaoHeaderCell.h"
#import "TuCaoCell.h"
#import "CoverView.h"
#import "TotalQuestionView.h"
#import "TuCaoFooterCell.h"
#import "MoreMistakeAnalyseVC.h"
#import <UITableView+FDTemplateLayoutCell.h>
@interface MistakeAnalyseVC ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,QuestionBottomViewDelegate,UITextFieldDelegate,TuCaoFooterCellDelegate>

@property(nonatomic,assign)CGPoint startPoint;

@property(nonatomic,strong)UITableView * currentTableView;//当前显示的tableView
@property(nonatomic,strong)UITableView * bottomTableView;//底部隐藏的tableView
@property(nonatomic,strong)UIPanGestureRecognizer * currentTablePan;//当前显示的tableView手势
@property(nonatomic,strong)UIPanGestureRecognizer * bottomTablePan;//底部隐藏的tableView手势
@property(nonatomic,strong)QuestionBottomView * bottomView;

@property(nonatomic,strong)CoverView * cover;//蒙版

@property(nonatomic,strong)NSMutableArray * totalQuestionArr;

@property(nonatomic,strong)TotalQuestionView * totalQuestionView;

@end

@implementation MistakeAnalyseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"错题分析"];
    
    [self createUI];
    
    
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.totalQuestionView dismiss];
    
}
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)createUI
{
    //创建底部的tableView
    UITableView *bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-kNavHeight-50) style:UITableViewStyleGrouped];
    self.bottomTableView = bottomTableView;
    self.bottomTableView.delegate = self;
    self.bottomTableView.dataSource = self;
    bottomTableView.backgroundColor = BG_COLOR;
    [bottomTableView setExtraCellLineHidden];
    [bottomTableView setCellLineFullInScreen];
    bottomTableView.separatorColor = [UIColor colorWithHexString:@"f0f0f0"];
    [self.view addSubview:bottomTableView];
    bottomTableView.fd_debugLogEnabled = YES;
    [bottomTableView registerNib:[UINib nibWithNibName:@"ExamQuestionAnalyseCell" bundle:nil] forCellReuseIdentifier:@"ExamQuestionAnalyseCell"];
    [bottomTableView registerNib:[UINib nibWithNibName:@"TuCaoCell" bundle:nil] forCellReuseIdentifier:@"TuCaoCell"];


    //阴影
    bottomTableView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    bottomTableView.layer.shadowOffset =CGSizeMake(4,0);
    bottomTableView.layer.shadowOpacity = 0.5;
    bottomTableView.clipsToBounds = NO;
    UIPanGestureRecognizer *pan1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(bottomTablePan:)];
    pan1.delegate = self;
    self.bottomTablePan = pan1;
    [bottomTableView addGestureRecognizer:pan1];
    
    
    //创建currentTableView
    UITableView *currentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-kNavHeight-50) style:UITableViewStyleGrouped];
    self.currentTableView = currentTableView;
    self.currentTableView.delegate = self;
    self.currentTableView.dataSource = self;
    currentTableView.backgroundColor = BG_COLOR;
    [currentTableView setExtraCellLineHidden];
    [currentTableView setCellLineFullInScreen];
    currentTableView.separatorColor = [UIColor colorWithHexString:@"f0f0f0"];
    [self.view addSubview:currentTableView];
    currentTableView.fd_debugLogEnabled = YES;
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
    bottomView.correctBtn.hidden = YES;
    bottomView.incorrectBtn.hidden = YES;
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
    
    //蒙版
    self.cover = [[CoverView alloc] initWithFrame:self.view.bounds];
    _cover.backgroundColor = [UIColor blackColor];
    _cover.alpha = 0.0;
    __weak typeof(self) weakSelf = self;
    _cover.touchBlock = ^{
        
        [weakSelf.totalQuestionView dismiss];
        
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

    };
    
    
    
    
  
}
#pragma mark - 手势冲突处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        
        return YES;
    }
    
    return NO;
}
#pragma mark -bottomTable拖动手势
-(void)bottomTablePan:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {//开始
        
        NSLog(@"UIGestureRecognizerStateBegan");
        
        self.startPoint = [pan locationInView:self.view];
        
        
    }
    
    else if (pan.state == UIGestureRecognizerStateChanged) {//拖动
        
        NSLog(@"UIGestureRecognizerStateChanged");
        
        CGPoint point = [pan locationInView:self.view];
        
        CGFloat width = point.x-_startPoint.x;
        
        _bottomTableView.scrollEnabled  =NO;
        
        if (width<0) {//向左移动
            
            CGFloat marginY = point.y- _startPoint.y;
            
            if (ABS(marginY)<25) {//垂直方向小于20才开始改变frame
                
                self.bottomTableView.x =  width;
                
                [self.view bringSubviewToFront:_bottomTableView];
                [self.view bringSubviewToFront:_bottomView];
                
            }
            
        }else{//向右拖动
            
            CGFloat marginY = point.y- _startPoint.y;
            
            if (ABS(marginY)<25) {//垂直方向小于20才开始改变frame
                
                self.currentTableView.x =  -kScreenWidth+width;
                
                [self.view bringSubviewToFront:self.currentTableView];
                [self.view bringSubviewToFront:_bottomView];
                
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
                }];
                
                
            }else
            {
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.bottomTableView.x = 0;
                    
                } completion:^(BOOL finished) {
                    self.currentTableView.x = 0;
                    
                    [self.view bringSubviewToFront:_bottomTableView];
                    [self.view bringSubviewToFront:_bottomView];
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
                    
                }];
                
            }else
            {
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.currentTableView.x = 0;
                    
                } completion:^(BOOL finished) {
                    self.bottomTableView.x = 0;
                    
                    [self.view bringSubviewToFront:_currentTableView];
                    [self.view bringSubviewToFront:_bottomView];
                }];
                
                
            }
            
            
            
        }
        
    }



}
#pragma mark -currentTable拖动手势
-(void)currentTablePan:(UIPanGestureRecognizer *)pan
{

    
    if (pan.state == UIGestureRecognizerStateBegan) {//开始
        
        
        NSLog(@"UIGestureRecognizerStateBegan");
        
        self.startPoint = [pan locationInView:self.view];
        
        
    }
    
    else if (pan.state == UIGestureRecognizerStateChanged) {//拖动
        
        NSLog(@"UIGestureRecognizerStateChanged");
        
        CGPoint point = [pan locationInView:self.view];
        
        CGFloat width = point.x-_startPoint.x;
        
        _currentTableView.scrollEnabled  = NO;
        
        
        if (width<0) {//向左移动
            CGFloat marginY = point.y- _startPoint.y;
            
            if (ABS(marginY)<25) {//垂直方向小于20才开始改变frame
                self.currentTableView.x =  width;
                [self.view bringSubviewToFront:_currentTableView];
                [self.view bringSubviewToFront:_bottomView];
            }
            
        }else{//向右拖动
            
            CGFloat marginY = point.y- _startPoint.y;
            
            NSLog(@"-------%f",self.bottomTableView.x);
            
            if (ABS(marginY)<25) {//垂直方向小于20才开始改变frame
                
                self.bottomTableView.x =  -kScreenWidth+width;
                
                [self.view bringSubviewToFront:_bottomTableView];
                [self.view bringSubviewToFront:_bottomView];
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
                    
                }];
                
            }else
            {
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.currentTableView.x = 0;
                    
                } completion:^(BOOL finished) {
                    self.bottomTableView.x = 0;
                    
                    [self.view bringSubviewToFront:_currentTableView];
                    [self.view bringSubviewToFront:_bottomView];
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
                }];
                
                
            }else
            {
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.bottomTableView.x = 0;
                    
                } completion:^(BOOL finished) {
                    self.currentTableView.x = 0;
                    [self.view bringSubviewToFront:_bottomTableView];
                    [self.view bringSubviewToFront:_bottomView];
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
-(void)questionBottomView:(QuestionBottomView *)bottomView didClickTuCaoButtonWithQuestionId:(ExamQuestionModel *)questionId
{
    bottomView.questionHudBtn.hidden = YES;
    
    bottomView.inputTextField.hidden = NO;
    
    bottomView.inputTextField.delegate = self;
    
    [bottomView.inputTextField becomeFirstResponder];
    
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _bottomView.questionHudBtn.hidden = NO;
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ExamQuestionTopCell *cell = (ExamQuestionTopCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.cellHeight;
        }else
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    if (section == 2) {
        return 10;
    }
    return CGFLOAT_MIN;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return 3+2;
    }
    
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *identify = @"ExamQuestionTopCell";
            ExamQuestionTopCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[ExamQuestionTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                imageView.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"fafafa"]];
                cell.selectedBackgroundView = imageView;
                
            }
            return cell;
            
        }

    }
    
    if (indexPath.section == 1) {
        
        ExamQuestionAnalyseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExamQuestionAnalyseCell" forIndexPath:indexPath];
        
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

    return nil;

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

-(void)tuCaoFooterCellDidClickMoreBtn:(TuCaoFooterCell *)cell
{
    MoreMistakeAnalyseVC *moreVC = [[MoreMistakeAnalyseVC alloc]init];
    [self.navigationController pushViewController:moreVC animated:YES];
    
    
}



@end
