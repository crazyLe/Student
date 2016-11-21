//
//  DebitCreditController.m
//  StudentClient
//
//  Created by sky on 2016/9/23.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "DebitCreditController.h"
#import "KZWebController.h"
#import "DebitCreditCell.h"
#import "PPDLoanSdk.h"

static NSString *const kDebitCreditCellID = @"DebitCreditCell";

static NSString *const kDebitCreditWebURL = @"https://m.nonobank.com/mxdsite/mxdwxsite/borrow.html?am_id=1975";


@interface DebitCreditController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *aTableView;

@end

@implementation DebitCreditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BG_COLOR;
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(backAction) andCenterTitle:@"借点花"];

    [self configTableView];
}

- (void)configTableView{
    [self.aTableView registerNib:[UINib nibWithNibName:@"DebitCreditCell" bundle:nil] forCellReuseIdentifier:kDebitCreditCellID];
    self.aTableView.estimatedRowHeight = 120;
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DebitCreditCell *cell = [tableView dequeueReusableCellWithIdentifier:kDebitCreditCellID forIndexPath:indexPath];

    return cell;
}


#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        KZWebController *webCtl = [[KZWebController alloc] initWithNibName:@"KZWebController" bundle:nil];
        webCtl.hidesBottomBarWhenPushed = YES;
        webCtl.webURL = kDebitCreditWebURL;
        webCtl.title = @"名校贷";
        [self.navigationController pushViewController:webCtl animated:YES];
    } else {
        [LoansSDK showLoanSdkView:nil withController:self];
    }
}


@end
