//
//  ApplyOnlineViewController.m
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "ApplyOnlineViewController.h"

#import "OrderFirstTableCell.h"
#import "OrderSecondTableCell.h"
#import "OrderThirdTableCell.h"
#import "OrderFourthTableCell.h"
#import "PaySuccessController.h"

@interface ApplyOnlineViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView * _backScrollView;
    UITableView * _orderTableView;
}


@end

@implementation ApplyOnlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //在线报名
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"在线报名"];
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
    
    
    UIImageView * topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 451)];
    topImageView.backgroundColor = [UIColor colorWithHexString:@"#f2f7f6"];
    topImageView.contentMode = UIViewContentModeScaleToFill;
    topImageView.image = [UIImage imageNamed:@"icon-dingdan-bg"];
    topImageView.userInteractionEnabled = YES;
    [_backScrollView addSubview:topImageView];
    
    _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 15, kScreenWidth-15*2, 397) style:UITableViewStylePlain];
    //    _orderTableView.backgroundView = topImageView;
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.showsVerticalScrollIndicator = NO;
    _orderTableView.scrollEnabled = NO;
//    _orderTableView.backgroundColor = [UIColor blackColor];
    [topImageView addSubview:_orderTableView];
    
    UIButton * paymentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    paymentBtn.frame = CGRectMake(64, CGRectGetMaxY(topImageView.frame), kScreenWidth-64*2, 40);
    paymentBtn.backgroundColor = [UIColor colorWithHexString:@"#352c3f"];
    paymentBtn.layer.cornerRadius = 20.0;
    //    [paymentBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-paybtn"] forState:UIControlStateNormal];
    NSMutableAttributedString * payStr = nil;
    payStr = [[NSMutableAttributedString alloc]initWithString:@"支付" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"¥2100.00" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#bbe0ff"],NSFontAttributeName:[UIFont systemFontOfSize:16]}]];
    [payStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"元" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:16]}]];
    [paymentBtn setAttributedTitle:payStr forState:UIControlStateNormal];
    [paymentBtn addTarget:self action:@selector(clickPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_backScrollView addSubview:paymentBtn];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 139;
    }else if(indexPath.row == 3){
        return 159;
    }else{
        return 60;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString * string = @"cellOne";
        OrderFirstTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[OrderFirstTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        //        cell.backgroundColor = [UIColor brownColor];
        return cell;
    }else if(indexPath.row == 1){
        static NSString * string = @"cellTwo";
        OrderSecondTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[OrderSecondTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        //        cell.backgroundColor = [UIColor purpleColor];
        return cell;
    }else if(indexPath.row == 2){
        static NSString * string = @"cellThree";
        OrderThirdTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[OrderThirdTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        //        cell.backgroundColor = [UIColor magentaColor];
        return cell;
    }else{
        static NSString * string = @"cellFour";
        OrderFourthTableCell * cell = [tableView dequeueReusableCellWithIdentifier:string];
        if (cell == nil) {
            cell = [[OrderFourthTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        }
        //        cell.backgroundColor = [UIColor magentaColor];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
