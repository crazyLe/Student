//
//  LLSelectCityViewController.m
//  Coach
//
//  Created by LL on 16/9/21.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import "LLSelectCityViewController.h"

@interface LLSelectCityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *dataArr; //数据源

@end

@implementation LLSelectCityViewController
{
    
}

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self setNavigation];
//    [self setUI];
}

#pragma mark - Setup

- (void)setNavigation
{
//    [self setTitleText:@"城市选择" textColor:nil];
    self.title = @"城市选择";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithOriginName:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    
    UITableView *table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:table];
    table.dataSource = self;
    table.delegate= self;
    
    self.bg_TableView = table;
    
    [self initWithData];
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)setUI
//{
//    [self setBg_TableView];
//    self.bg_TableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.bg_TableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//}

//- (void)setBg_TableView
//{
//    [self setBg_TableViewWithConstraints:nil];
//    [self registerClassWithClassNameArr:@[@"UITableViewCell"] cellIdentifier:nil];
//}

#pragma mark - UITableViewDelegate && UITableViewDateSource

//Setup your cell margins:
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    LLOpenCityModel *model = _dataArr[indexPath.row];
    
    cell.textLabel.text = model.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(LLSelectCityViewController:didSelectCity:)]) {
        [_delegate LLSelectCityViewController:self didSelectCity:_dataArr[indexPath.row]];
    }
}

- (void)initWithData
{
   NSArray *cityArr =  [[SCDBManager shareInstance] getAllValuesInTable:kOpenCityTableName KeyArr:kOpenCityTableColumnArr WhereItsKey:@"parent_id" IsValue:_provinceModel.id_num];
   _dataArr =  [LLOpenCityModel mj_objectArrayWithKeyValuesArray:cityArr];
   [self.bg_TableView reloadData];
}

@end
