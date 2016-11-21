//
//  PartnerTrainResultController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PartnerTrainResultController.h"
#import "PartnerTrainSubmitCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "PartnerTrainWaitCell.h"
#import "PartnerTrainSuccessCell.h"
#import "PartnerTrainFailCell.h"
@interface PartnerTrainResultController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;


@end

@implementation PartnerTrainResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self createUI];
    
    
}
-(void)createUI
{
    //创建UITableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-kNavHeight) style:UITableViewStylePlain];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    tableView.backgroundColor = BG_COLOR;
    [tableView setExtraCellLineHidden];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    [tableView registerClass:[PartnerTrainSubmitCell class] forCellReuseIdentifier:@"PartnerTrainSubmitCell"];
    [tableView registerClass:[PartnerTrainWaitCell class] forCellReuseIdentifier:@"PartnerTrainWaitCell"];
    [tableView registerClass:[PartnerTrainFailCell class] forCellReuseIdentifier:@"PartnerTrainFailCell"];
    [tableView registerNib:[UINib nibWithNibName:@"PartnerTrainSuccessCell" bundle:nil] forCellReuseIdentifier:@"PartnerTrainSuccessCell"];
    [self.view addSubview:tableView];
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainSubmitCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainSubmitCell * cell) {
            cell.fd_enforceFrameLayout = YES;
            cell.contentString = @"学时陪练提交成功";
            cell.timeString = @"";

        }];
    }
    if (indexPath.row == 1) {
        return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainWaitCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainWaitCell * cell) {
            cell.fd_enforceFrameLayout = YES;
            cell.contentString = @"等待教练确认......";
        }];
    }
    if (indexPath.row == 2) {
        return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainSuccessCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainSuccessCell * cell) {
        }];
    }
    if (indexPath.row == 3) {
        return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainFailCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainFailCell * cell) {
            cell.fd_enforceFrameLayout = YES;
            cell.titleString = @"预约失败";
            cell.subTitleString = @"原因:教练确认超时";
            cell.zhuanDouString = @"赚豆已退还账户";
            cell.timeString = @"";

        }];
    }
    
    return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *identify = @"PartnerTrainSubmitCell";
        PartnerTrainSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        cell.fd_enforceFrameLayout = YES;//是Frame布局
        cell.contentString = @"学时陪练提交成功";
        cell.timeString = @"";
        return cell;
    }
    if (indexPath.row == 1) {
        static NSString *identify = @"PartnerTrainWaitCell";
        PartnerTrainWaitCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        cell.fd_enforceFrameLayout = YES;//是Frame布局
        cell.contentString = @"等待教练确认......";
        return cell;
        
    }
    if (indexPath.row == 2) {
        static NSString *identify = @"PartnerTrainSuccessCell";
        PartnerTrainSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];

        return cell;
        
    }
    if (indexPath.row == 3) {
        static NSString *identify = @"PartnerTrainFailCell";
        PartnerTrainFailCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
        cell.fd_enforceFrameLayout = YES;
        cell.titleString = @"预约失败";
        cell.subTitleString = @"原因:教练确认超时";
        cell.zhuanDouString = @"赚豆已退还账户";
        cell.timeString = @"";
        return cell;
        
    }
    return nil;
    
}

- (void)configNav {
    
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back)  andCenterTitle:@"订单结果"];
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
