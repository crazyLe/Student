//
//  StagesApplyResultController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "StagesApplyResultController.h"
#import "PartnerTrainSubmitCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "PartnerTrainWaitCell.h"
#import "PartnerTrainSuccessCell.h"
#import "PartnerTrainFailCell.h"
#import "StagesApplySuccessCell.h"
@interface StagesApplyResultController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;

@end

@implementation StagesApplyResultController

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
    [tableView registerNib:[UINib nibWithNibName:@"StagesApplySuccessCell" bundle:nil] forCellReuseIdentifier:@"StagesApplySuccessCell"];
    [self.view addSubview:tableView];
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.stagesApplyStatus isEqualToString:@"0"]) {
        return 2;
    }
    if ([self.stagesApplyStatus isEqualToString:@"1"]) {
        return 3;
    }
    if ([self.stagesApplyStatus isEqualToString:@"2"]) {
        return 3;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.stagesApplyStatus isEqualToString:@"0"]) {
        if (indexPath.row == 0) {
            return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainSubmitCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainSubmitCell * cell) {
                cell.fd_enforceFrameLayout = YES;
                cell.contentString = @"学车分期申请提交成功";
                cell.timeString = @"今天16:00";
            }];
        }
        if (indexPath.row == 1) {
            return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainWaitCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainWaitCell * cell) {
                cell.fd_enforceFrameLayout = YES;
                cell.fd_enforceFrameLayout = YES;//是Frame布局
                cell.contentString = @"预计需要2个工作日,请等待工作人员审核,请保持电话畅通。";
                cell.bigBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            }];
        }
    }
    if ([self.stagesApplyStatus isEqualToString:@"1"]) {
        if (indexPath.row == 0) {
            return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainSubmitCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainSubmitCell * cell) {
                cell.fd_enforceFrameLayout = YES;
                cell.contentString = @"学车分期申请提交成功";
                cell.timeString = @"今天16:00";
            }];
        }
        if (indexPath.row == 1) {
            return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainWaitCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainWaitCell * cell) {
                cell.fd_enforceFrameLayout = YES;
                cell.fd_enforceFrameLayout = YES;//是Frame布局
                cell.contentString = @"预计需要2个工作日,请等待工作人员审核,请保持电话畅通。";
                cell.bigBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            }];
        }
        if (indexPath.row == 2) {
            CGFloat height =  [tableView fd_heightForCellWithIdentifier:@"StagesApplySuccessCell" cacheByIndexPath:indexPath configuration:^(StagesApplySuccessCell * cell) {
            }];
            
            return height;
        }
    }
    
    if ([self.stagesApplyStatus isEqualToString:@"2"]) {
        if (indexPath.row == 0) {
            return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainSubmitCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainSubmitCell * cell) {
                cell.fd_enforceFrameLayout = YES;
                cell.contentString = @"学车分期申请提交成功";
                cell.timeString = @"今天16:00";
            }];
        }
        if (indexPath.row == 1) {
            return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainWaitCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainWaitCell * cell) {
                cell.fd_enforceFrameLayout = YES;
                cell.fd_enforceFrameLayout = YES;//是Frame布局
                cell.contentString = @"预计需要2个工作日,请等待工作人员审核,请保持电话畅通。";
                cell.bigBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            }];
        }
        if (indexPath.row == 2) {
            return [tableView fd_heightForCellWithIdentifier:@"PartnerTrainFailCell" cacheByIndexPath:indexPath configuration:^(PartnerTrainFailCell * cell) {
                cell.fd_enforceFrameLayout = YES;
                cell.titleString = @"学车分期审核不通过";
                cell.subTitleString = @"原因:电话拒接";
                cell.zhuanDouString = @"赚豆已退还账户";
                cell.timeString = @"今天17:30";
                
            }];
        }
    }
   
    
    return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.stagesApplyStatus isEqualToString:@"0"]) {
        if (indexPath.row == 0) {
            static NSString *identify = @"PartnerTrainSubmitCell";
            PartnerTrainSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
            cell.fd_enforceFrameLayout = YES;//是Frame布局
            cell.contentString = @"学车分期申请提交成功";
            NSDate *date = [NSDate date];
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            df.dateFormat = @"HH:mm";
            NSString *dateStr = [df stringFromDate:date];
            cell.timeString = dateStr;
            return cell;
        }
        if (indexPath.row == 1) {
            static NSString *identify = @"PartnerTrainWaitCell";
            PartnerTrainWaitCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
            cell.fd_enforceFrameLayout = YES;//是Frame布局
            cell.contentString = @"预计需要2个工作日,请等待工作人员审核,请保持电话畅通。";
            cell.bigBtn.titleLabel.font = [UIFont systemFontOfSize:13*AutoSizeScaleX];
            return cell;
            
        }
    }
    
    if ([self.stagesApplyStatus isEqualToString:@"1"]) {
        if (indexPath.row == 0) {
            static NSString *identify = @"PartnerTrainSubmitCell";
            PartnerTrainSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
            cell.fd_enforceFrameLayout = YES;//是Frame布局
            cell.contentString = @"学车分期申请提交成功";
            cell.timeString = @"今天16:00";
            return cell;
        }
        if (indexPath.row == 1) {
            static NSString *identify = @"PartnerTrainWaitCell";
            PartnerTrainWaitCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
            cell.fd_enforceFrameLayout = YES;//是Frame布局
            cell.contentString = @"预计需要2个工作日,请等待工作人员审核,请保持电话畅通。";
            cell.bigBtn.titleLabel.font = [UIFont systemFontOfSize:13*AutoSizeScaleX];
            return cell;
            
        }
        if (indexPath.row == 2) {
            static NSString *identify = @"StagesApplySuccessCell";
            StagesApplySuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
            cell.fd_enforceFrameLayout = NO;
            
            return cell;
            
        }
    }
    
    if ([self.stagesApplyStatus isEqualToString:@"2"]) {
        if (indexPath.row == 0) {
            static NSString *identify = @"PartnerTrainSubmitCell";
            PartnerTrainSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
            cell.fd_enforceFrameLayout = YES;//是Frame布局
            cell.contentString = @"学车分期申请提交成功";
            cell.timeString = @"今天16:00";
            return cell;
        }
        if (indexPath.row == 1) {
            static NSString *identify = @"PartnerTrainWaitCell";
            PartnerTrainWaitCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
            cell.fd_enforceFrameLayout = YES;//是Frame布局
            cell.contentString = @"预计需要2个工作日,请等待工作人员审核,请保持电话畅通。";
            cell.bigBtn.titleLabel.font = [UIFont systemFontOfSize:13*AutoSizeScaleX];
            return cell;
            
        }
        if (indexPath.row == 2) {
            static NSString *identify = @"PartnerTrainFailCell";
            PartnerTrainFailCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
            cell.fd_enforceFrameLayout = YES;
            cell.titleString = @"学车分期审核不通过";
            cell.subTitleString = @"原因:电话拒接";
            cell.zhuanDouString = @"赚豆已退还账户";
            cell.timeString = @"今天17:30";
            return cell;
            
        }
    }
    
   
   
    return nil;
    
}

- (void)configNav {
    
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back)  andCenterTitle:@"学车分期申请"];
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
