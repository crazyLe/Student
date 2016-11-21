//
//  MsgNotificationController.m
//  学员端
//
//  Created by zuweizhong  on 16/8/1.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MsgNotificationController.h"
#import "MsgNotifiCell.h"
#import "SystemMsgController.h"
#import "InvititeMsgController.h"
@interface MsgNotificationController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;

@end

@implementation MsgNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"系统消息"];
    [self createUI];
    
   
}
- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createUI
{
    //新消息
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setExtraCellLineHidden];
    [_tableView setCellLineFullInScreen];
    _tableView.separatorColor = [UIColor colorWithHexString:@"ececec"];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"MsgNotifiCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MsgNotifiCell"];

}

#pragma mark -- tableView的代理和数据源
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MsgNotifiCell";
    MsgNotifiCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        SystemMsgController *systemMsg = [[SystemMsgController alloc]init];
        [self.navigationController pushViewController:systemMsg animated:YES];
    }
    if (indexPath.row == 1) {
        InvititeMsgController *systemMsg = [[InvititeMsgController alloc]init];
        [self.navigationController pushViewController:systemMsg animated:YES];
    }

}
@end
