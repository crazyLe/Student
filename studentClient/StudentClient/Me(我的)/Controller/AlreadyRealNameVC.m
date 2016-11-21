//
//  AlreadyRealNameVC.m
//  学员端
//
//  Created by gaobin on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "AlreadyRealNameVC.h"
#import "RealNameHeaderCell.h"
#import "AlreadyInfoCell.h"
#import "RestartAuthenticationCell.h"
#import "RealNameAuthenticationVC.h"


@interface AlreadyRealNameVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation AlreadyRealNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    
    [self createNavigation];
    
    [self createUI];
}

- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = BG_COLOR;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"RealNameHeaderCell" bundle:nil] forCellReuseIdentifier:@"RealNameHeaderCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"AlreadyInfoCell" bundle:nil] forCellReuseIdentifier:@"AlreadyInfoCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RestartAuthenticationCell" bundle:nil] forCellReuseIdentifier:@"RestartAuthenticationCell"];
}

#pragma mark -- tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 1;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString * identifier = @"RealNameHeaderCell";
        
        RealNameHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:self.currentUserInfo.face] placeholderImage:[UIImage imageNamed:@"头像"]];
        cell.nameLab.text = self.currentUserInfo.nickName;
        cell.phoneLab.text = self.currentUserInfo.phone;
        return cell;
    }

    if (indexPath.section == 1) {
        
        static NSString * identifier = @"AlreadyInfoCell";
        
        AlreadyInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //防止分割线颜色太深
        if (indexPath.row == 0) {
            
            cell.titleLab.text = @"真实姓名";
            cell.detailLab.text = _realName.trueName;
        }
        if (indexPath.row == 1) {
            
            cell.titleLab.text = @"身份证号码";
            cell.topLineView.hidden = YES;
            cell.detailLab.text = _realName.IDNum;
        }
        
        return cell;
        
    } else {
        static NSString * identifier = @"RestartAuthenticationCell";
        
        RestartAuthenticationCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 74;
    } else if (indexPath.section == 1) {
        return 45;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 7.5;
    } else if (section == 1) {
        return 7.5;
    } else {
        return kScreenHeight -kNavHeight -7.5*2 -74 -45*2 -50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        
        RealNameAuthenticationVC * vc = [[RealNameAuthenticationVC alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)createNavigation {
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:@"实名认证"];
}

- (void)leftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
