//
//  RealNameAuthenticationVC.m
//  学员端
//
//  Created by gaobin on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "RealNameAuthenticationVC.h"
#import "RealNameHeaderCell.h"
#import "RealNameInfoCell.h"
#import "UploadPhotoCell.h"
#import "CLAlertView.h"
#import "ValidateHelper.h"

@interface RealNameAuthenticationVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UploadPhotoCellDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSString *realName;

@property(nonatomic,strong)NSString *idNum;

@property(nonatomic,strong)UIImage *selectImage;

@end

@implementation RealNameAuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavigation];
    
    [self createUI];
}

- (void)createUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BG_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"RealNameHeaderCell" bundle:nil] forCellReuseIdentifier:@"RealNameHeaderCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"RealNameInfoCell" bundle:nil] forCellReuseIdentifier:@"RealNameInfoCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"UploadPhotoCell" bundle:nil] forCellReuseIdentifier:@"UploadPhotoCell"];
}

#pragma mark -- tableView的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;

        case 1:
            return 2;
        case 2:
            return 1;

        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString * identifier = @"RealNameHeaderCell";
        RealNameHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        //cell.authenticationImgView.hidden = YES;
        [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:self.currentUserInfo.face] placeholderImage:[UIImage imageNamed:@"头像"]];
        cell.nameLab.text = self.currentUserInfo.nickName;
        cell.phoneLab.text = self.currentUserInfo.phone;
        return cell;
    } else if (indexPath.section == 1 ) {
        
        static NSString * identifier = @"RealNameInfoCell";
        RealNameInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if (indexPath.row == 1) {
            //防止线条重合
            cell.topLineView.hidden = YES;
            cell.titleLab.text = @"身份证号码";
            cell.detailLab.text = self.idNum;
            
        }
        if (indexPath.row == 0) {
            cell.topLineView.hidden = NO;
            cell.titleLab.text = @"真实姓名";
            cell.detailLab.text = self.realName;
        }
        
        return cell;
        
    } else if (indexPath.section == 2 ) {
        
        static NSString * identifier = @"UploadPhotoCell";
        UploadPhotoCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.uploadDelegate = self;
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"输入真实姓名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];

            alertView.tag = 1000;
            
            [alertView show];
        } else if (indexPath.row == 1) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"输入身份证号码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
            
            alertView.tag = 1001;
            
            UITextField *textF = [alertView textFieldAtIndex:0];
            
            textF.keyboardType = UIKeyboardTypeASCIICapable;
            
            [alertView show];
            
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            UITextField *textF = [alertView textFieldAtIndex:0];
            self.realName = textF.text;
        }
    } else {
        if (buttonIndex == 1) {
            UITextField *textF = [alertView textFieldAtIndex:0];
            self.idNum = textF.text;
        }
    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 74;
    } else if (indexPath.section == 1) {
        return 45;
    } else {
        return 170;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 7.5;
    } else if (section == 1) {
        return 7.5;
    } else {
        return 7.5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0 || section == 1) {
        return CGFLOAT_MIN;
    } else {
        return 200;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        
        UIView * bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor clearColor];
        
        UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(20, 20, kScreenWidth - 40, 50);
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"发到学员圈"] forState:UIControlStateNormal];
        [submitBtn setTitle:@"提交认证" forState:UIControlStateNormal];
        submitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn setTitleEdgeInsets:UIEdgeInsetsMake(-5, 7, 0, 0)];
        [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:submitBtn];
        
        UILabel * authenticationLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 80, 15)];
        authenticationLab.text = @"认证须知 :";
        authenticationLab.font = [UIFont boldSystemFontOfSize:15];
        authenticationLab.textColor = [UIColor colorWithHexString:@"#666666"];
        authenticationLab.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:authenticationLab];
        
        UILabel * oneLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 200, 15)];
        oneLab.text = @"1、认证提交必须真实有效";
        oneLab.textColor = [UIColor colorWithHexString:@"#666666"];
        oneLab.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:oneLab];
        
        UILabel * twoLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 250, 15)];
        twoLab.text = @"2、提交成功后将会在1个工作日内审核";
        twoLab.textColor = [UIColor colorWithHexString:@"#666666"];
        twoLab.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:twoLab];
        
        return bgView;

    }
    
    return nil;
}

-(void)uploadPhotoCell:(UploadPhotoCell *)cell didSelectImageWithImage:(UIImage *)image {
    self.selectImage = image;
}

- (void)submitBtnClick {
    

    if ([self.realName isEqualToString:@""] || self.realName == nil) {
        [self.hudManager showErrorSVHudWithTitle:@"请填写真实姓名" hideAfterDelay:1.0];
        return;
    }
    if ([self.idNum isEqualToString:@""] || self.idNum == nil) {
        [self.hudManager showErrorSVHudWithTitle:@"请填写身份证号码" hideAfterDelay:1.0];
        return;
    }
    if (self.selectImage == nil) {
        [self.hudManager showErrorSVHudWithTitle:@"请选择身份证照片" hideAfterDelay:1.0];
        return;
    }
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在提交..."];
    NSString * url = self.interfaceManager.userAuthAddUrl;
    NSMutableDictionary * paramDic = [NSMutableDictionary dictionary];
    
    paramDic[@"uid"] = kUid;
    NSString * timeStr = [HttpParamManager getTime];
    paramDic[@"time"] = timeStr;
    paramDic[@"sign"] = [HttpParamManager getSignWithIdentify:@"/userAuth/add" time:timeStr];
    //修改的参数
    paramDic[@"trueName"] = self.realName;
    paramDic[@"IDNum"] = self.idNum;
    NSData *data = UIImageJPEGRepresentation(self.selectImage, 0.5);
    [HJHttpManager UploadFileWithUrl:url param:paramDic serviceName:@"picName" fileName:@"1.png" mimeType:@"image/jpeg" fileData:data finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"+++___%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            [self.hudManager dismissSVHud];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [NOTIFICATION_CENTER postNotificationName:kAuthenticationStateNotification object:nil];
            });
            CLAlertView * alertView = [[CLAlertView alloc] initWithAlertViewWithTitle:@"提交成功" text:@"我们会在1个工作日内审核认证,请留意系统消息。" DefauleBtn:nil cancelBtn:@"朕知道了" defaultBtnBlock:^(UIButton *defaultBtn) {
                
            } cancelBtnBlock:nil];
            
            [alertView show];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];

        }
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"保存失败" hideAfterDelay:1.0f];

    }];
}

- (void)createNavigation {
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:@"实名认证"];
}

- (void)leftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
