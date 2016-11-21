//
//  PersonalTailController.m
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PersonalTailController.h"

#import "PaySuccessController.h"
#import "PersonFirstTableCell.h"
#import "PersonSecondTableCell.h"
#import "PersonThirdTableCell.h"
#import "PersonFourthTableCell.h"
#import "PersonFifthTableCell.h"

static BOOL FifthCellHidden = YES;
@interface PersonalTailController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,PersonFourthTableCellDelegete>
{
    UIScrollView * _backScrollView;
    UIImageView * _topImageView;
    UITableView * _orderTableView;
    UIButton * _paymentBtn;
}

@end

@implementation PersonalTailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //私人订制购买
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"私人订制购买"];
    [self createUI];
}

- (void)createUI
{
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _backScrollView.backgroundColor = rgb(239, 245, 244);
    _backScrollView.delegate = self;
    _backScrollView.showsVerticalScrollIndicator =  NO;
    _backScrollView.contentSize = CGSizeMake(kScreenWidth, 664);
    [self.view addSubview:_backScrollView];
    
    [self createTopImageView];
}

- (void)createTopImageView
{
    
    
    _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 451+25)];
    _topImageView.backgroundColor = [UIColor colorWithHexString:@"#f2f7f6"];
    _topImageView.contentMode = UIViewContentModeScaleToFill;
    _topImageView.image = [UIImage imageNamed:@"icon-dingdan-bg"];
    _topImageView.userInteractionEnabled = YES;
    [_backScrollView addSubview:_topImageView];
    
    _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 15, kScreenWidth-15*2, 397+9) style:UITableViewStylePlain];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.separatorColor = [UIColor colorWithHexString:@"f0f0f0"];
    _orderTableView.showsVerticalScrollIndicator = NO;
    _orderTableView.backgroundColor = [UIColor whiteColor];
    _orderTableView.scrollEnabled = NO;
    [_topImageView addSubview:_orderTableView];
    
    _paymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _paymentBtn.frame = CGRectMake(64, CGRectGetMaxY(_topImageView.frame), kScreenWidth-64*2, 40);
    
    _paymentBtn.backgroundColor = [UIColor colorWithHexString:@"#352c3f"];
    _paymentBtn.layer.cornerRadius = 20.0;
    NSMutableAttributedString * payStr = nil;
    payStr = [[NSMutableAttributedString alloc]initWithString:@"支付" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"¥2100.00" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#bbe0ff"],NSFontAttributeName:[UIFont systemFontOfSize:16]}]];
    [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"元" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}]];
    [_paymentBtn setAttributedTitle:payStr forState:UIControlStateNormal];
    [_paymentBtn addTarget:self action:@selector(clickPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_backScrollView addSubview:_paymentBtn];
    
}

- (void)clickPayBtn:(UIButton *)sender
{
    PaySuccessController * paySuccessVC = [[PaySuccessController alloc]init];
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark PersonFourthTableCellDelegete
- (void)clickPersonFourthCellPayBtn:(NSInteger)markTag
{
    if (markTag == 100) {
        NSLog(@"全额付款");
        FifthCellHidden = YES;
        _backScrollView.contentSize = CGSizeMake(kScreenWidth, 664);
        _topImageView.frame =CGRectMake(0, 20, kScreenWidth, 451+25);
        _orderTableView.frame = CGRectMake(15, 15, kScreenWidth-15*2, 397+9);
        _paymentBtn.frame = CGRectMake(64, CGRectGetMaxY(_topImageView.frame), kScreenWidth-64*2, 40);
        [_orderTableView reloadData];
    }else{
        NSLog(@"分期支付");
        FifthCellHidden = NO;
        _backScrollView.contentSize = CGSizeMake(kScreenWidth, 664+140);
        _topImageView.frame =CGRectMake(0, 20, kScreenWidth, 451+113+75);
        _orderTableView.frame = CGRectMake(15, 15, kScreenWidth-15*2, 397+9+140+13);
        _paymentBtn.frame = CGRectMake(64, CGRectGetMaxY(_topImageView.frame), kScreenWidth-64*2, 40);
        [_orderTableView reloadData];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 20, 0, 20)];
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 178;
    }else if(indexPath.row == 3){
        return 159-25;
    }else if(indexPath.row == 4){
        return 138;
    }else{
        return 55;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (FifthCellHidden == NO) {
        return 5;
    }else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString * string = @"cellOne";
        PersonFirstTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[PersonFirstTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.row == 1){
        static NSString * string = @"cellTwo";
        PersonSecondTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonSecondTableCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 2){
        static NSString * string = @"cellThree";
        PersonThirdTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[PersonThirdTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 3){
        static NSString * string = @"cellFour";
        PersonFourthTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[PersonFourthTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.row == 4){
        static NSString * string = @"cellFive";
        PersonFifthTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[PersonFifthTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}



@end
