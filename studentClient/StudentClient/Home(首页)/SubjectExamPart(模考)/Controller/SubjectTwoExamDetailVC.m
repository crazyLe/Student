//
//  SubjectTwoExamDetailVC.m
//  学员端
//
//  Created by zuweizhong  on 16/7/19.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SubjectTwoExamDetailVC.h"
#import "SubjectOneDetailCell1.h"
#import "SubjectOneDetailCell2.h"

@interface SubjectTwoExamDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)UIButton * confirmBtn;

@end

@implementation SubjectTwoExamDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"合肥南岗机场"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f7f6"];
    
    [self createUI];

}
-(void)createUI
{
    //创建UITableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-kNavHeight) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setExtraCellLineHidden];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    [self.view addSubview:tableView];    
}
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    
    return 10;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return CGFLOAT_MIN;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 125;
    }
    
    if (indexPath.section == 1) {
        
        SubjectOneDetailCell2 *cell = (SubjectOneDetailCell2 *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        [cell setNeedsLayout];
        
        [cell layoutIfNeeded];
        
        return cell.cellHeight;

    }
    return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
    
        static NSString *identify = @"SubjectOneDetailCell1";
        
        SubjectOneDetailCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SubjectOneDetailCell1" owner:nil options:nil]lastObject];
        }
        
        return cell;
    }
    if (indexPath.section == 1) {
        
        static NSString *identify = @"SubjectOneDetailCell2";
        
        SubjectOneDetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (!cell) {
            cell = [[SubjectOneDetailCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        return cell;
    }

    return nil;
    
    
}
@end
