//
//  SubjectOneExamHomeVC.m
//  学员端
//
//  Created by gaobin on 16/7/16.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SubjectOneExamHomeVC.h"
#import "SubjectExamController.h"
#import "SubjectOneExamCell.h"
#import "SubjectExamCollectionVC.h"
#import "ExamRecordController.h"
#import "ExamRankController.h"
#import <JTNavigationController.h>
@interface SubjectOneExamHomeVC ()<UITableViewDelegate,UITableViewDataSource,SubjectOneExamCellDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * titleArr;
@property (nonatomic, strong) NSArray * detailArr;


@end

@implementation SubjectOneExamHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.subjectNum isEqualToString:@"一"]) {
        
        [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"科一模考"];

    }
    else
    {
        [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"科四模考"];
    }
    
    self.view.backgroundColor = BG_COLOR;
    
    [self createUI];
    
}
- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight - 52) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setCellLineFullInScreen];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"SubjectOneExamCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SubjectOneExamCell"];
    
 
    //创建底部的两个按钮
    UIView * historyView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight -kNavHeight - 52, kScreenWidth/2, 52)];
    historyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:historyView];
    UIImageView * historyImgView = [[UIImageView alloc] init];
    historyImgView.image = [UIImage imageNamed:@"iconfont-hegebiaozhun"];
    [historyView addSubview:historyImgView];
    [historyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(historyView);
        make.width.offset(18);
        make.height.offset(18);
        
    }];
    
    UILabel * historyLab = [[UILabel alloc] init];
    historyLab.text = @"查看历史模考记录";
    historyLab.textColor = [UIColor colorWithHexString:@"#999999"];
    historyLab.font = [UIFont systemFontOfSize:13];
    [historyView addSubview:historyLab];
    [historyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(110);
        make.centerY.equalTo(historyImgView);
        make.right.offset(-(kScreenWidth/2 - 18 - 110 -5)/2);
        make.left.equalTo(historyImgView.mas_right).offset(5);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(historyTapGesture)];
    [historyView addGestureRecognizer:tap];
    
    UIView * rankView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2, kScreenHeight - kNavHeight - 52, kScreenWidth/2, 52)];
    rankView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rankView];

    UIImageView * rankImgView = [[UIImageView alloc] init];
    rankImgView.image = [UIImage imageNamed:@"iconfont-paixing"];
    [rankView addSubview:rankImgView];
    [rankImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(18);
        make.centerY.equalTo(rankView);
    }];
    UILabel * rankLab = [[UILabel alloc] init];
    rankLab.text = [NSString stringWithFormat:@"科%@模考排行榜",self.subjectNum];
    rankLab.textColor = [UIColor colorWithHexString:@"#999999"];
    rankLab.font = [UIFont systemFontOfSize:13];
    [rankView addSubview:rankLab];
    [rankLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(110);
        make.centerY.equalTo(rankView);
        make.right.offset(-(kScreenWidth/2 - 110- 18 - 5)/2);
        make.left.equalTo(rankImgView.mas_right).offset(5);
    }];
    UITapGestureRecognizer * rankTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rankTapGexture)];
    [rankView addGestureRecognizer:rankTap];
    
    UIView * horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kNavHeight - 52.5, kScreenWidth, 0.5)];
    horizontalLine.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [self.view addSubview:horizontalLine];
    UIView * verticalLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2, kScreenHeight - kNavHeight - 52, 0.5, 52)];
    verticalLine.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
    [self.view addSubview:verticalLine];
    
    
}
//查看历史模考记录
- (void)historyTapGesture {

    if ([_subjectNum isEqualToString:@"一"]) {
        
        ExamRecordController * vc = [[ExamRecordController alloc] init];
        
        vc.subjectNum = @"一";
        
        JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
        
        [self presentViewController:nav animated:YES completion:nil];
        
    }else {
        
        ExamRecordController * vc = [[ExamRecordController alloc] init];
        
        vc.subjectNum = @"四";
        
        JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
        
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
}
//科一模考排行榜
- (void)rankTapGexture {
    
    ExamRankController *vc = [[ExamRankController alloc]init];
    
    if ([self.subjectNum isEqualToString:@"一"]) {
        vc.urlString = [NSString stringWithFormat:@"%@?uid=%@&subjectId=1&app=1",self.interfaceManager.rankUrl,kUid];
    }
    else
    {
        vc.urlString = [NSString stringWithFormat:@"%@?uid=%@&subjectId=4&app=1",self.interfaceManager.rankUrl,kUid];

    }
    vc.subjectNum = self.subjectNum;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -- tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"SubjectOneExamCell";
    
    SubjectOneExamCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.subjectNum = self.subjectNum;
    cell.backgroundColor = BG_COLOR;
    cell.delegate = self;
    return cell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 590;
}
-(void)subjectOneExamCellDidClickStartBtn:(SubjectOneExamCell *)cell
{
    SubjectExamCollectionVC *examCollection = [[SubjectExamCollectionVC alloc]init];
    
    examCollection.isExamination = YES;
    
    if ([self.subjectNum isEqualToString:@"一"]) {
        examCollection.isSubjectOne = YES;
    }
    else
    {
        examCollection.isSubjectOne = NO;
    }
    
    [self.navigationController pushViewController:examCollection animated:YES];
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
