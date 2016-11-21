//
//  MyCoachViewController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/29.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "MyCoachViewController.h"
#import "MyCoachBindCell.h"
#import "MyCoachUnBindCell.h"
#import "MyPartnerTrainCell.h"
#import "BindCoachController.h"
#import "CoachModel.h"

static NSString *const kMyCoachBindCell = @"MyCoachBindCell";
static NSString *const kMyCoachUnBindCell = @"MyCoachUnBindCell";
static NSString *const kMyPartnerTrainCell = @"MyPartnerTrainCell";


@interface MyCoachViewController ()<UITableViewDelegate,UITableViewDataSource,MyCoachBindCellDelegate,MyCoachUnBindCellDelegate>

@property(nonatomic,strong)UITableView * tableView;


@end

@implementation MyCoachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BG_COLOR;
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:@"我的教练"];
    [self createUI];
}

-(void)createUI {
    //创建tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-kNavHeight) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"MyCoachBindCell" bundle:nil] forCellReuseIdentifier:kMyCoachBindCell];
    [tableView registerNib:[UINib nibWithNibName:@"MyCoachUnBindCell" bundle:nil] forCellReuseIdentifier:kMyCoachUnBindCell];
    [tableView registerNib:[UINib nibWithNibName:@"MyPartnerTrainCell" bundle:nil] forCellReuseIdentifier:kMyPartnerTrainCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setExtraCellLineHidden];
    tableView.allowsSelection = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}

- (void)leftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- tableView的代理和数据源
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (2 == section) {
       return  _xueshiArr.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            return [self cellType:tableView andCoach:_secondCoach andIndexpath:indexPath];
        }
            break;
        case 1:
        {
            return [self cellType:tableView andCoach:_thredCoach andIndexpath:indexPath];
        }
            break;
        case 2:
        {
            NSInteger row = indexPath.row;
            MyPartnerTrainCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyPartnerTrainCell forIndexPath:indexPath];
            cell.xueshi = _xueshiArr[row];
            
            return cell;
            
        }
            break;
            
        default:
            break;
    }
    
    return nil;

}

- (UITableViewCell *)cellType:(UITableView *)tableView andCoach:(CoachModel *)coach andIndexpath:(NSIndexPath *)indexPath
{
    if (coach.idNum != nil) {
        MyCoachBindCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyCoachBindCell forIndexPath:indexPath];
        cell.delegate = self;
        cell.coach = coach;
        if (indexPath.section == 1) {
            cell.subjectNumLabel.text = @"科目三";
        } else {
            cell.subjectNumLabel.text = @"科目二";
        }
        return cell;
    } else {
        MyCoachUnBindCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyCoachUnBindCell forIndexPath:indexPath];

        if (indexPath.section == 1) {
            cell.mainTitleLabel.text = @"科目三";
            cell.titleLabel.text = @"暂未绑定科目三";
        } else {
            cell.mainTitleLabel.text = @"科目二";
            cell.titleLabel.text = @"暂未绑定科目二";
        }
        cell.gotoBlock = ^(){
            NSString *sub;
            if (0 == indexPath.section ) {
                sub = @"second";
            } else {
                sub = @"thred";
            }
            BindCoachController *bindVC = [[BindCoachController alloc]init];
            bindVC.sub = sub;
            [self.navigationController pushViewController:bindVC animated:YES];
        };
        return cell;
    }
}

- (void)jiechuBDingCoach:(MyCoachBindCell *)cell {
    NSString *uid = cell.coach.idNum;
    NSLog(@"%@",uid);
    
    NSString *subject = nil;
    
    if ([cell.subjectNumLabel.text isEqualToString:@"科目二"])
    {
        subject = @"second";
    }
    else
    {
        subject = @"thred";
    }
    NSString *postUrl =  self.interfaceManager.unBindCoachUrl;
    
    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    NSLog(@"%@",kUid);
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/bindingCoach" time:time];
    param[@"coachId"] = uid;
    param[@"subjects"] = subject;
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    [HJHttpManager PostRequestWithUrl:postUrl param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@== %@",dict,dict[@"msg"]);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1) {
            
            [self.hudManager showSuccessSVHudWithTitle:msg hideAfterDelay:1.0 animaton:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [NOTIFICATION_CENTER postNotificationName:kRefreshMyCoachStateNotification object:nil];
                [self leftBtnClick];
            });
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];

    
    
    
    
}


@end
