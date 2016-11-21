//
//  SubjectOneMyMistakeVC.m
//  学员端
//
//  Created by gaobin on 16/7/18.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SubjectOneMyMistakeVC.h"
#import "SubOneMyMistakeCell.h"
#import "AutoDeleteCell.h"
#import "ClearAllMistakeCell.h"
#import "MistakeAnalyseVC.h"
#import "ExamQuestionModel.h"
#import "MistakeQuestionController.h"
#import "MistakeQuestionDataBase.h"
@interface SubjectOneMyMistakeVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;
/**
 *  做题时的错题
 */
@property(nonatomic,strong)NSMutableArray * dataArray1;
/**
 *  模拟时的错题
 */
@property(nonatomic,strong)NSMutableArray * dataArray2;

@property(nonatomic,assign)BOOL isDeleteWhenAnswerCorrect;

@end

@implementation SubjectOneMyMistakeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isDeleteWhenAnswerCorrect = YES;
    
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"我的错题"];
    [self createUI];
    
   

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//TODU
    self.dataArray1 = [[MistakeQuestionDataBase shareInstance]queryZuoTiMistakeDataWithSubject:self.subjectNum].mutableCopy;
    self.dataArray2 = [[MistakeQuestionDataBase shareInstance]queryTestMistakeDataWithSubject:self.subjectNum].mutableCopy;
    [self.tableView reloadData];

}
- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BG_COLOR;
    [_tableView setExtraCellLineHidden];
    [_tableView setSeparatorColor:[UIColor colorWithHexString:@"#f1f1f1"]];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"SubOneMyMistakeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SubOneMyMistakeCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"AutoDeleteCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AutoDeleteCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"ClearAllMistakeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ClearAllMistakeCell"];
    
    
    
}

#pragma mark -- tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 5;
    }else {
        return 1;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (indexPath.section == 0) {
        
        if (indexPath.row == 4) {
            static NSString * identifier = @"AutoDeleteCell";
            
            AutoDeleteCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.colorImgView.image = [UIImage imageNamed:@"科一做题_椭圆-5"];
            cell.titleLab.text = @"答对后自动删除该错题";
            cell.titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
            cell.autoDeleteSwitch.onTintColor = [UIColor colorWithHexString:@"#ff5f5e"];
            cell.autoDeleteSwitch.tintColor = [UIColor colorWithHexString:@"#f2f2f2"];
            [cell.autoDeleteSwitch removeAllTargets];
            [cell.autoDeleteSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            
        
            return cell;
            
        }else {
            
            static NSString * identifier = @"SubOneMyMistakeCell";
            
            SubOneMyMistakeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
            cell.numberLab.textColor = [UIColor colorWithHexString:@"#999999"];

            if (indexPath.row == 0) {
                
                cell.colorImgView.image = [UIImage imageNamed:@"科一做题_椭圆-2"];
                cell.titleLab.text = @"重新做题";
                cell.numberLab.text = [NSString stringWithFormat:@"%ld",self.dataArray1.count];
                
            }else if (indexPath.row == 1) {
                
                cell.colorImgView.image = [UIImage imageNamed:@"科一做题_椭圆-6"];
                cell.titleLab.text = @"错题分析";
                cell.numberLab.text = [NSString stringWithFormat:@"%ld",self.dataArray1.count];
                
            }else if (indexPath.row == 2){
                
                cell.colorImgView.image = [UIImage imageNamed:@"科一做题_椭圆-3"];
                cell.titleLab.text = @"自测错题";
                cell.numberLab.text = [NSString stringWithFormat:@"%ld",self.dataArray2.count];
                
            }else {
                
                cell.colorImgView.image = [UIImage imageNamed:@"科一做题_椭圆-4"];
                cell.titleLab.text = @"模拟错题";
                cell.numberLab.text = [NSString stringWithFormat:@"%ld",self.dataArray2.count];


                
            }
            return cell;
        }

    }else {
        
        static NSString * identifier = @"ClearAllMistakeCell";
        ClearAllMistakeCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.clearMistakeLab.text = @"清空全部错题";
        cell.clearMistakeLab.textColor = [UIColor colorWithHexString:@"#fb5f5b"];
        cell.topLineView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];

        return cell;
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 56;
    }else {
        return 52;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return CGFLOAT_MIN;
        
    }else {
        
        return kScreenHeight - kNavHeight - 56 * 5 - 52;
        
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        UIView * headerView = [[UIView alloc] init];
        headerView.backgroundColor = BG_COLOR;
        return headerView;
        
    }else {
        
        return nil;
    }
    
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            if (self.dataArray1.count == 0) {
                [self.hudManager showErrorSVHudWithTitle:@"暂无错题！" hideAfterDelay:1.0];
                return;
            }
            
            MistakeQuestionController * vc = [[MistakeQuestionController alloc] init];
            
            for (ExamQuestionModel *model in self.dataArray1) {
                model.isAnswered = NO;
            }
            vc.allDataArray = self.dataArray1;
            
            vc.isShowComment = YES;
            
            vc.titleString = @"重新错题";
            
            vc.isIminiteShowComment = NO;
            
            vc.isDeleteWhenAnswerCorrect = self.isDeleteWhenAnswerCorrect;

            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            
            if (self.dataArray1.count == 0) {
                [self.hudManager showErrorSVHudWithTitle:@"暂无错题！" hideAfterDelay:1.0];
                return;
            }
            
            MistakeQuestionController * vc = [[MistakeQuestionController alloc] init];
            
            for (ExamQuestionModel *model in self.dataArray1) {
                model.isAnswered = YES;
            }
            vc.allDataArray = self.dataArray1;
            
            vc.isShowComment = YES;
            
            vc.titleString = @"错题分析";
            
            vc.isIminiteShowComment = YES;

            vc.isDeleteWhenAnswerCorrect = self.isDeleteWhenAnswerCorrect;

            [self.navigationController pushViewController:vc animated:YES];
            
        }
        if (indexPath.row == 2) {
            if (self.dataArray2.count == 0) {
                [self.hudManager showErrorSVHudWithTitle:@"暂无错题！" hideAfterDelay:1.0];
                return;
            }
            MistakeQuestionController * vc = [[MistakeQuestionController alloc] init];
            
            for (ExamQuestionModel *model in self.dataArray2) {
                model.isAnswered = NO;
            }
            vc.allDataArray = self.dataArray2;
            
            vc.isShowComment = YES;
            
            vc.titleString = @"自测错题";
            
            vc.isIminiteShowComment = NO;

            vc.isDeleteWhenAnswerCorrect = self.isDeleteWhenAnswerCorrect;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 3)  {
            if (self.dataArray2.count == 0) {
                [self.hudManager showErrorSVHudWithTitle:@"暂无错题！" hideAfterDelay:1.0];
                return;
            }
            MistakeQuestionController * vc = [[MistakeQuestionController alloc] init];
            
            for (ExamQuestionModel *model in self.dataArray2) {
                model.isAnswered = YES;
            }
            vc.allDataArray = self.dataArray2;
            
            vc.isShowComment = YES;
            
            vc.titleString = @"模拟错题";
            
            vc.isIminiteShowComment = YES;

            vc.isDeleteWhenAnswerCorrect = self.isDeleteWhenAnswerCorrect;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 4) {
            
            NSLog(@"4");
        }
    }else {
        
        if ([self.subjectNum isEqualToString:@"1"]) {
            //TUDO
            [[MistakeQuestionDataBase shareInstance] deleteAllSubject1Data];
        }
        else
        {
            //TUDO
            [[MistakeQuestionDataBase shareInstance] deleteAllSubject4Data];
        }
        //TUDO
        self.dataArray1 = [[MistakeQuestionDataBase shareInstance]queryZuoTiMistakeDataWithSubject:self.subjectNum].mutableCopy;
        self.dataArray2 = [[MistakeQuestionDataBase shareInstance]queryTestMistakeDataWithSubject:self.subjectNum].mutableCopy;
        [self.tableView reloadData];
    }
    
    
    
    
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    if (indexPath.row == 4) {
        cell.separatorInset = UIEdgeInsetsMake(0, -50, 0, 320);
    }
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
- (void)switchValueChanged:(UISwitch *)autoDeleteSwitch {
    
    if (autoDeleteSwitch.isOn)
    {
        self.isDeleteWhenAnswerCorrect = YES;
    }
    else
    {
        self.isDeleteWhenAnswerCorrect = NO;
    }
    
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
