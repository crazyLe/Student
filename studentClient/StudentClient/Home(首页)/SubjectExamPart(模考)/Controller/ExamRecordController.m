//
//  ExamRecordController.m
//  学员端
//
//  Created by zuweizhong  on 16/8/6.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "ExamRecordController.h"
#import "ExamRecordCell.h"
#import "ExamRecordModel.h"
#import "ExamRankController.h"
@interface ExamRecordController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property(nonatomic,assign)int page;

@property(nonatomic,strong)NSMutableArray * dataArray;


@end

@implementation ExamRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.page = 1;
    
    self.dataArray = [NSMutableArray array];
    
    [self createNavigation];
    
    [self createUI];
    
    [self loadData];
    
}
-(void)loadData
{

    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    NSString *url = self.interfaceManager.testRecordUrl;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/questions/testRecord" time:time];
    param[@"deviceInfo"] =[HttpParamManager getDeviceInfo];
    if ([self.subjectNum isEqualToString:@"一"]) {
        param[@"type"] = @(1);
    }
    else
    {
        param[@"type"] = @(4);
    }
    param[@"page"] = @(self.page);
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {
            
            NSArray *arr = dict[@"info"][@"data"];
  
            self.dataArray =  [ExamRecordModel mj_objectArrayWithKeyValuesArray:arr];
            
            [self.tableView reloadData];
            
            [self.hudManager dismissSVHud];
            
        }
        else if(code == 2)
        {
            //验证失败，去登录
            LoginGuideController *loginVC = [[LoginGuideController alloc]init];
            JTNavigationController *loginnavC = [[JTNavigationController alloc] initWithRootViewController:loginVC];
            loginnavC.fullScreenPopGestureEnabled = YES;
            self.view.window.rootViewController = loginnavC;
            
            [self.hudManager dismissSVHud];

        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            
        }
        
        
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];
    


}
- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"ExamRecordCell" bundle:nil] forCellReuseIdentifier:@"ExamRecordCell"];
    
}
#pragma mark --tableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"ExamRecordCell";
    
    ExamRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.rankImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"模考_%ld",(long)indexPath.row+1]];
    cell.markLab.font = [UIFont boldSystemFontOfSize:19];
    
    ExamRecordModel *model = self.dataArray[indexPath.row];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.addtime];
    
    cell.timePointLab.text = [df stringFromDate:date];
    
    cell.timeRangeLab.text = model.user_time_format;
    
    cell.introduceLab.text = [NSString stringWithFormat:@"超过全国%@%%的用户",model.beat_percent];
    
    cell.markLab.text = [NSString stringWithFormat:@"%d",model.scores];
    
    cell.detailLab.text = [NSString stringWithFormat:@"答错:%d,未答:%d",model.error_answer,model.un_answer];
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExamRecordModel *model = self.dataArray[indexPath.row];

    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    NSString *url = self.interfaceManager.testRecordDelUrl;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/questions/testRecordDel" time:time];
    param[@"deviceInfo"] =[HttpParamManager getDeviceInfo];
    param[@"id"] = @(model.idNum);
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {

            [self.hudManager showSuccessSVHudWithTitle:@"删除成功!" hideAfterDelay:1.0 animaton:YES];
            
            [self loadData];
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            
        }
        
        
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];

    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

- (void)createNavigation {
    
    if ([self.subjectNum isEqualToString:@"一"]) {
        [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:@"模考记录" andRightBtnImageName:nil rightHighlightImageName:nil rightBtnSelector:@selector(rightBtnClick) withRightBtnTitle:@"模考排行" rightColor:[UIColor colorWithHexString:@"#7ace1e"]];
    }
    else
    {
        [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(leftBtnClick) andCenterTitle:@"模考记录" andRightBtnImageName:nil rightHighlightImageName:nil rightBtnSelector:@selector(rightBtnClick) withRightBtnTitle:@"模考排行" rightColor:[UIColor colorWithHexString:@"#7ace1e"]];
    }

    
}
- (void)leftBtnClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)rightBtnClick {
    
    ExamRankController *vc = [[ExamRankController alloc]init];
    
    if ([self.subjectNum isEqualToString:@"一"]) {
        vc.urlString = [NSString stringWithFormat:@"%@?uid=%@&subjectId=1&app=1",self.interfaceManager.rankUrl,kUid];
    }
    else
    {
        vc.urlString = [NSString stringWithFormat:@"%@?uid=%@&subjectId=4&app=1",self.interfaceManager.rankUrl,kUid];
        
    }
    vc.subjectNum = self.subjectNum;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
