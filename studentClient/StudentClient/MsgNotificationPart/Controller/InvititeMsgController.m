//
//  InvititeMsgController.m
//  学员端
//
//  Created by zuweizhong  on 16/8/1.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "InvititeMsgController.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "SystemHeaderCell.h"
#import "InviteMsgCell.h"
@interface InvititeMsgController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;

@end

@implementation InvititeMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_COLOR;
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"邀请类消息"];
    [self createUI];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createUI
{
    //新消息
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setExtraCellLineHidden];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor colorWithHexString:@"ececec"];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"InviteMsgCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"InviteMsgCell"];
    
}
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
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SystemHeaderCell *header = [[[NSBundle mainBundle]loadNibNamed:@"SystemHeaderCell" owner:nil options:nil]lastObject];
    header.backgroundColor = [UIColor clearColor];
    return header;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:@"InviteMsgCell" cacheByIndexPath:indexPath configuration:^(InviteMsgCell * cell) {
        cell.backgroundColor = [UIColor whiteColor];
        
    }];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifer = @"InviteMsgCell";
    InviteMsgCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}
@end
