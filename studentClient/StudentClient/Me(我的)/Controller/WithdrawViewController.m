//
//  WithdrawViewController.m
//  学员端
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLWithdrawDesCell.h"
#import "LLLeftLblRightTFCell.h"
#import "UIViewController+NavigationController.h"
#import "LLWithdrawAmountCell.h"
#import "LLEarnBeansRemainCell.h"
#import "WithdrawViewController.h"
#import <IQKeyboardManager.h>
#import "WithdrawModel.h"
#import "WithdrawRecordController.h"
#import "SRActionSheet.h"
@interface WithdrawViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)NSString * selectedMoney;

@property(nonatomic,strong)UITextField * bankTextF;

@property(nonatomic,strong)UITextField * nameTextF;

@property(nonatomic,strong)UITextField * cardNumTextF;

@property(nonatomic,strong)WithdrawModel *withdrawModel;

@property(nonatomic,strong)UITableView * tableView;

@end

@implementation WithdrawViewController
{
    NSArray *registerCellArr;
}

- (id)init
{
    if (self = [super init]) {
        registerCellArr = @[@"LLEarnBeansRemainCell",@"LLWithdrawAmountCell",@"LLWithdrawDesCell"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   

    [self setNavigation];
    
    [self setUI];
    
    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;

}

-(void)loadData
{
    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    NSString * url = self.interfaceManager.getCashCasebefore;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/getCash/casebefore" time:time];
    paramDict[@"type"] = @(1);
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@">>>%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            
            NSDictionary  *subDict = dict[@"info"];
            
            WithdrawModel *model = [WithdrawModel mj_objectWithKeyValues:subDict];
            
            self.withdrawModel = model;
            
            [self.hudManager dismissSVHud];
            
            [self.tableView reloadData];
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
            
        }
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
        
        
    }];




}
#pragma mark - Setup

- (void)setNavigation
{
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(clickNavLeftBtn:) andCenterTitle:@"提现"  andRightBtnImageName:nil rightHighlightImageName:nil rightBtnSelector:@selector(rightClick:) withRightBtnTitle:@"提现记录" rightColor:[UIColor colorWithHexString:@"#5eb5ff"]];
}
-(void)rightClick:(UIButton *)btn
{

    WithdrawRecordController *vc = [[WithdrawRecordController alloc]init];
    [self.view endEditing:YES];
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)setUI
{
    [self setBg_TableView];
}

- (void)setBg_TableView
{
    UITableView *bg_TableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView = bg_TableView;
    [self.view addSubview:bg_TableView];
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self.view endEditing:YES];
    }]];
    [bg_TableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    bg_TableView.delegate = self;
    bg_TableView.dataSource = self;
    bg_TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    for (NSString *className in registerCellArr) {
        [bg_TableView registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDateSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [@[@(1),@(1),@(3),@(1),@(1)][section] longValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [@[@[@(65)],@[@(55)],@[@(42*kHeightScale),@(42*kHeightScale),@(42*kHeightScale)],@[@(60*kHeightScale)],@[@(250*kHeightScale)]][indexPath.section][indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            LLEarnBeansRemainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLEarnBeansRemainCell"];
            cell.leftLbl.text = @"赚豆：";
            cell.rightLbl.text = self.currentUserInfo.beans;
            return cell;
        }
            break;
        case 1:
        {
            LLWithdrawAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLWithdrawAmountCell"];
            cell.leftLbl.text = @"提现金额：";
            NSArray *btnTitleArr = @[@"100元",@"200元",@"300元"];
            int i = 0;
            for (UIButton *btn in cell.btnArr) {
                [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
                i++;
            }
            cell.selectedBtnBlock = ^(NSString *money)
            {
                HJLog(@"%@",money);
                
                self.selectedMoney = money;
            
            
            };
            return cell;
        }
            break;
        case 2:
        {
            
            
            if (indexPath.row == 0) {
                LLLeftLblRightTFCell *cell = [[LLLeftLblRightTFCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLLeftLblRightTFCell0"];
                self.bankTextF = cell.rightTF;
                self.bankTextF.delegate = self;
                NSArray *leftLblTextArr = @[@"提现银行：",@"开 户 名：",@"银行卡号："];
                cell.leftLbl.text = leftLblTextArr[indexPath.row];
                if (indexPath.row==0) {
                    cell.accessoryImgView.image = [UIImage imageNamed:@"iconfont-jiantou(1)"];
                    cell.accessoryImgView.hidden = NO;
                }
                else
                {
                    cell.accessoryImgView.hidden = YES;
                }
                return cell;
            }
            if (indexPath.row == 1) {
                LLLeftLblRightTFCell1 *cell = [[LLLeftLblRightTFCell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLLeftLblRightTFCell1"];

                self.nameTextF = cell.rightTF;
                self.nameTextF.delegate = nil;
                NSArray *leftLblTextArr = @[@"提现银行：",@"开 户 名：",@"银行卡号："];
                cell.leftLbl.text = leftLblTextArr[indexPath.row];
                if (indexPath.row==0) {
                    cell.accessoryImgView.image = [UIImage imageNamed:@"iconfont-jiantou(1)"];
                    cell.accessoryImgView.hidden = NO;
                }
                else
                {
                    cell.accessoryImgView.hidden = YES;
                }
                
                
                return cell;

            }
            if (indexPath.row == 2) {
                LLLeftLblRightTFCell2 *cell = [[LLLeftLblRightTFCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LLLeftLblRightTFCell2"];

                self.cardNumTextF = cell.rightTF;
                self.cardNumTextF.keyboardType = UIKeyboardTypeNumberPad;
                self.cardNumTextF.delegate = nil;
                NSArray *leftLblTextArr = @[@"提现银行：",@"开 户 名：",@"银行卡号："];
                cell.leftLbl.text = leftLblTextArr[indexPath.row];
                if (indexPath.row==0) {
                    cell.accessoryImgView.image = [UIImage imageNamed:@"iconfont-jiantou(1)"];
                    cell.accessoryImgView.hidden = NO;
                }
                else
                {
                    cell.accessoryImgView.hidden = YES;
                }
                
                
                return cell;

            }
            return nil;
           
        }
            break;
        case 3:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.backgroundColor = [UIColor clearColor];
            UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cell.contentView addSubview:exitBtn];
            [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(10*kHeightScale, 22*kHeightScale, 10*kHeightScale, 22*kHeightScale));
            }];
            exitBtn.backgroundColor = [UIColor colorWithHexString:@"5cb6ff"];
            exitBtn.layer.masksToBounds = YES;
            exitBtn.layer.cornerRadius = 5.0f;
            [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [exitBtn removeAllTargets];
            [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [exitBtn setTitle:@"申请提现" forState:UIControlStateNormal];
            exitBtn.titleLabel.font = kFont15;
            return cell;
        }
            break;
        case 4:
        {
            LLWithdrawDesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LLWithdrawDesCell"];
            cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:245/255.0 blue:244/255.0 alpha:1];
            cell.titleLbl.text = @"提现说明：";
            NSString *contentStr = self.withdrawModel.intro;
            if (contentStr != nil) {
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                [style setLineSpacing:10.0f*kHeightScale];
                cell.contentLbl.attributedText = [[NSAttributedString alloc] initWithString:contentStr attributes:@{NSParagraphStyleAttributeName:style}];
            }
            
            return cell;
        }
            break;
            
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)exitBtnClick
{
    if ([self.bankTextF.text isEqualToString:@""]) {
        [self.hudManager showErrorSVHudWithTitle:@"请选择开户行" hideAfterDelay:1.0];
        return;
    }
    if ([self.nameTextF.text isEqualToString:@""]) {
        [self.hudManager showErrorSVHudWithTitle:@"请填写开户名" hideAfterDelay:1.0];
        return;
    }
    if ([self.cardNumTextF.text isEqualToString:@""]) {
        [self.hudManager showErrorSVHudWithTitle:@"请填写银行卡号" hideAfterDelay:1.0];
        return;
    }

    [self.view endEditing:YES];
    NSString * url = self.interfaceManager.getCashUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/getCash"time:time];
    paramDict[@"totalBeans"] = @(self.selectedMoney.integerValue *10);
    paramDict[@"bankAccount"] = self.bankTextF.text;
    NSInteger idNum = 0;
    for (int i = 0; i<self.withdrawModel.Banks.count; i++) {
        NSDictionary *dict = self.withdrawModel.Banks[i];
        if ([dict[@"name"] isEqualToString:self.bankTextF.text]) {
            idNum = [dict[@"id"] integerValue];
            break;
        }
    }
    paramDict[@"bankId"] = @(idNum);
    paramDict[@"bankTrueName"] = self.nameTextF.text;
    paramDict[@"bankCard"] = self.cardNumTextF.text;

    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@">>>%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            
            [self.hudManager showSuccessSVHudWithTitle:@"申请提现成功" hideAfterDelay:1.0 animaton:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                WithdrawRecordController *vc = [[WithdrawRecordController alloc]init];
                [self.view endEditing:YES];
                [self.navigationController pushViewController:vc animated:YES];
            });
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
    
        }
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];

        
    }];


}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    if (textField == self.bankTextF) {
        
        [self.cardNumTextF resignFirstResponder];
        [self.nameTextF resignFirstResponder];
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i<self.withdrawModel.Banks.count; i++) {
            NSDictionary *dict = self.withdrawModel.Banks[i];
            [arr addObject:dict[@"name"]];
        }
        [SRActionSheet sr_showActionSheetViewWithTitle:@"请选择银行"
                                     cancelButtonTitle:@"取消"
                                destructiveButtonTitle:nil
                                     otherButtonTitles:arr
                                      selectSheetBlock:^(SRActionSheet *actionSheetView, NSInteger actionIndex) {
                                          if (actionIndex == -1) {
                                              return ;
                                          }
                                          NSDictionary *dict = self.withdrawModel.Banks[actionIndex];
                                          self.bankTextF.text = dict[@"name"];
                                          
                                      }];

        return NO;
    }

    return YES;
    
}
- (void)clickNavLeftBtn:(UIButton *)leftBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

@implementation LLLeftLblRightTFCell1
#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _leftLbl = [UILabel new];
    [self.contentView addSubview:_leftLbl];
    
    _rightTF = [UITextField new];
    [self.contentView addSubview:_rightTF];
    
    _accessoryImgView = [UIImageView new];
    [self.contentView addSubview:_accessoryImgView];
}

- (void)setContraints
{
    [super setContraints];
    
    WeakObj(_leftLbl)
    [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(22*kWidthScale);
        //        make.top.offset(20*kHeightScale);
        make.centerY.offset(0);
        make.width.offset(80*kWidthScale);
        make.height.offset(25*kHeightScale);
    }];
    
    [_rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftLblWeak.mas_right);
        make.height.offset(32*kHeightScale);
        make.centerY.equalTo(_leftLblWeak);
        make.right.offset(-22*kWidthScale);
    }];
    
    WeakObj(_accessoryImgView)
    [_accessoryImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.bottom.offset(-5);
        make.right.offset(-20);
        make.width.equalTo(_accessoryImgViewWeak.mas_height);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    _leftLbl.textColor = [UIColor colorWithHexString:@"666666"];
    _leftLbl.font = kFont14;
    
    _rightTF.borderStyle = UITextBorderStyleRoundedRect;
    _rightTF.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    
    _accessoryImgView.contentMode = UIViewContentModeCenter;
}


@end


@implementation LLLeftLblRightTFCell2

#pragma mark - Setup

- (void)setUI
{
    [super setUI];
    
    _leftLbl = [UILabel new];
    [self.contentView addSubview:_leftLbl];
    
    _rightTF = [UITextField new];
    [self.contentView addSubview:_rightTF];
    
    _accessoryImgView = [UIImageView new];
    [self.contentView addSubview:_accessoryImgView];
}

- (void)setContraints
{
    [super setContraints];
    
    WeakObj(_leftLbl)
    [_leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(22*kWidthScale);
        //        make.top.offset(20*kHeightScale);
        make.centerY.offset(0);
        make.width.offset(80*kWidthScale);
        make.height.offset(25*kHeightScale);
    }];
    
    [_rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftLblWeak.mas_right);
        make.height.offset(32*kHeightScale);
        make.centerY.equalTo(_leftLblWeak);
        make.right.offset(-22*kWidthScale);
    }];
    
    WeakObj(_accessoryImgView)
    [_accessoryImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.bottom.offset(-5);
        make.right.offset(-20);
        make.width.equalTo(_accessoryImgViewWeak.mas_height);
    }];
}

- (void)setAttributes
{
    [super setAttributes];
    
    _leftLbl.textColor = [UIColor colorWithHexString:@"666666"];
    _leftLbl.font = kFont14;
    
    _rightTF.borderStyle = UITextBorderStyleRoundedRect;
    _rightTF.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    
    _accessoryImgView.contentMode = UIViewContentModeCenter;
}


@end


