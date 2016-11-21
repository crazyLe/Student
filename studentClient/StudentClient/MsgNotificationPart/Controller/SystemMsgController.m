//
//  SystemMsgController.m
//  学员端
//
//  Created by zuweizhong  on 16/8/1.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SystemMsgController.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "SystemHeaderCell.h"
#import "SystemMsgCell.h"
#import "MessageDataBase.h"
#import "ExtraMoneyVC.h"
#import "InvititeMsgController.h"
#import "RealNameAuthenticationVC.h"
#import "AlreadyRealNameVC.h"
#import "RealNameModel.h"
#import "MyOrderDetailVC.h"
#import "MyCoachViewController.h"
#import "CoachModel.h"
#import "XueshiModel.h"
#import "UnBindCoachController.h"
#import "WithdrawRecordController.h"
#import "MyCircleViewController.h"
#import "MyVoucherVC.h"
#import "StagingBillVC.h"
#import "CircleDetailWebController.h"
#import "InviteMsgCell.h"
#import "UIScrollView+EmptyDataSet.h"


@interface SystemMsgController ()<UITableViewDelegate,UITableViewDataSource,InviteMsgCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)int maxid;
@property(nonatomic,strong)CoachModel *secModel;
@property(nonatomic,strong)CoachModel *thiModel;
@property(nonatomic,strong)NSMutableArray *xueshiArr;

@end

@implementation SystemMsgController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BG_COLOR;
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"系统消息"];
    
    self.dataArray = [NSMutableArray array];
    
    self.maxid = [[MessageDataBase shareInstance] getMaxIdModel].idNum;
    
    [self createUI];
    
    [self loadMessage];
}

-(void)loadMessage {
    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    NSString *url = self.interfaceManager.msgUrl;
    NSString *time = [HttpParamManager getTime];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"maxId"] = @(self.maxid);
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/message" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1)
        {
            NSArray *arr = [MsgModel mj_objectArrayWithKeyValuesArray:dict[@"info"][@"message"]];
            
            for (int i = 0; i<arr.count; i++) {
                MsgModel *model = arr[i];
                [[MessageDataBase shareInstance] insertDataWithModel:model];
            }
            if (self.isCircle) {
                self.dataArray = [[MessageDataBase shareInstance] queryCircleMessage].mutableCopy;
            } else {
                self.dataArray = [[MessageDataBase shareInstance] query].mutableCopy;
            }
            //设置所有信息已读
            for (int i = 0; i<self.dataArray.count ; i++) {
                MsgModel *model = self.dataArray[i];
                [[MessageDataBase shareInstance] setDataIsReadWithModel:model];
            }
            [NOTIFICATION_CENTER postNotificationName:kMakeMsgIsReadNotification object:nil];
            [self.hudManager dismissSVHud];
            [self.tableView reloadData];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
        }
        
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
    }];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createUI {
    //新消息
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kNavHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setExtraCellLineHidden];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor colorWithHexString:@"ececec"];
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"SystemMsgCell" bundle:nil] forCellReuseIdentifier:@"SystemMsgCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"InviteMsgCell" bundle:nil] forCellReuseIdentifier:@"InviteMsgCell"];
    
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SystemHeaderCell *header = [[[NSBundle mainBundle]loadNibNamed:@"SystemHeaderCell" owner:nil options:nil]lastObject];
    header.backgroundColor = [UIColor clearColor];
    MsgModel *model = self.dataArray[section];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"MM-dd HH:mm";
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:model.addtime];
    NSString *time = [df stringFromDate:lastDate];
    header.timeLabel.text = time;
    return header;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MsgModel *model = self.dataArray[indexPath.section];
    
    HJLog(@"%@",model);
    
    NSDictionary *msgDict = model.msg.mj_JSONObject;

    
    if ([msgDict[@"msg_id"] integerValue] == 24) {
        ExtraMoneyVC *VC = [[ExtraMoneyVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    /*
    if ([msgDict[@"msg_id"] integerValue] == 23) {
        NSString *tId = msgDict[@"tId"];
        InvititeMsgController *VC = [[InvititeMsgController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
        
    }
     */
    if ([msgDict[@"msg_id"] integerValue] == 21) {
        RealNameAuthenticationVC * vc = [[RealNameAuthenticationVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }

    if ([msgDict[@"msg_id"] integerValue] == 20) {
        NSString * url = self.interfaceManager.realNameState;
        [self.hudManager showNormalStateSVHUDWithTitle:nil];
        NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
        paramDict[@"uid"] = kUid;
        NSString * timeString = [HttpParamManager getTime];
        paramDict[@"time"] = timeString;
        paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/userAuth" time:timeString];
        
        [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            HJLog(@"+++%@",dict);
            NSInteger code = [dict[@"code"] integerValue];
            NSString * msg = dict[@"msg"];
            if (code == 1) {
                
                [self.hudManager dismissSVHud];
                NSDictionary * infoDict = dict[@"info"];
                RealNameModel *model = [RealNameModel mj_objectWithKeyValues:infoDict];
                //审核通过,进去已认证界面
                AlreadyRealNameVC * vc = [[AlreadyRealNameVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.realName = model;
                [self.navigationController pushViewController:vc animated:YES];
                
            } else {
                [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            }
        } failed:^(NSError *error) {
            [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        }];
    }

    if ([msgDict[@"msg_id"] integerValue] == 19||[msgDict[@"msg_id"] integerValue] == 18||[msgDict[@"msg_id"] integerValue] == 7||[msgDict[@"msg_id"] integerValue] == 6||[msgDict[@"msg_id"] integerValue] == 5||[msgDict[@"msg_id"] integerValue] == 4||[msgDict[@"msg_id"] integerValue] == 3||[msgDict[@"msg_id"] integerValue] == 2||[msgDict[@"msg_id"] integerValue] == 1) {
        
        NSString *idStr = msgDict[@"orderId"];
        [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
        NSString * url = self.interfaceManager.getOrderdetails;
        NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
        paramDict[@"orderId"] = idStr;
        paramDict[@"uid"] = kUid;
        NSString * timeString = [HttpParamManager getTime];
        paramDict[@"time"] = timeString;
        paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/Orderdetails" time:timeString addExtraStr:idStr];
        
        [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSInteger code = [dict[@"code"] integerValue];
            NSString * msg = dict[@"msg"];
            if (code == 1) {
                [self.hudManager dismissSVHud];
                OrderDetailModel *info = [OrderDetailModel mj_objectWithKeyValues:dict[@"info"][@"orderInfo"]];
                MyOrderDetailVC * vc = [[MyOrderDetailVC alloc] init];
                vc.orderDetailInfo = info;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            }
        } failed:^(NSError *error) {
            [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
        }];
    }
    
    if ([msgDict[@"msg_id"] integerValue] == 17||[msgDict[@"msg_id"] integerValue] == 16) {

        [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];
        NSString *postUrl =  self.interfaceManager.myCoach;
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSString *time = [HttpParamManager getTime];
        param[@"uid"] = kUid;
        param[@"time"] = time;
        param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/myCoach" time:time];
        param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
        [HJHttpManager PostRequestWithUrl:postUrl param:param finish:^(NSData *data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            HJLog(@"%@",dict);
            NSInteger code = [dict[@"code"] integerValue];
            NSString *msg = dict[@"msg"];
            if (code == 1) {
                
                [self.hudManager dismissSVHud];
                
                NSDictionary *infoDict = dict[@"info"];
                
                NSDictionary *secondDict = infoDict[@"second"];
                
                NSDictionary *thirdDict = infoDict[@"thred"];
                
                self.secModel = [CoachModel mj_objectWithKeyValues:secondDict];
                
                self.thiModel = [CoachModel mj_objectWithKeyValues:thirdDict];
                self.xueshiArr = [XueshiModel mj_objectArrayWithKeyValuesArray:infoDict[@"teachingTimes"]];

                //我的教练
                if (self.secModel.idNum == nil && self.thiModel.idNum == nil) {
                    UnBindCoachController *unBindVC =[[UnBindCoachController alloc]init];
                    unBindVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:unBindVC animated:YES];
                } else {
                    MyCoachViewController *mycoachVC = [[MyCoachViewController alloc]init];
                    mycoachVC.hidesBottomBarWhenPushed = YES;
                    mycoachVC.secondCoach = self.secModel;
                    mycoachVC.thredCoach = self.thiModel;
                    mycoachVC.xueshiArr = self.xueshiArr;
                    [self.navigationController pushViewController:mycoachVC animated:YES];
                }
            } else {
                [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
            }
            
        } failed:^(NSError *error) {
            [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
        }];
    }

    if ([msgDict[@"msg_id"] integerValue] == 15) {
        WithdrawRecordController *vc = [[WithdrawRecordController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }

    if ([msgDict[@"msg_id"] integerValue] == 14) {//头条
        int topId = [msgDict[@"topid"] intValue];
        
        CircleDetailWebController *circleDetail  =[[CircleDetailWebController alloc]init];
        
        circleDetail.urlString = [NSString stringWithFormat:@"%@/%d?app=1&uid=%@&cityId=%ld&address=%@,%@",self.interfaceManager.circleDetailUrl,topId,kUid,[HttpParamManager getCurrentCityID],[HttpParamManager getLongitude],[HttpParamManager getLatitude]];
        
        [self.navigationController pushViewController:circleDetail animated:YES];
    }

    if ([msgDict[@"msg_id"] integerValue] == 13) {
        MyCircleViewController *vc = [[MyCircleViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }

    if ([msgDict[@"msg_id"] integerValue] == 12) {
        MyVoucherVC *vc = [[MyVoucherVC alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }

    if ([msgDict[@"msg_id"] integerValue] == 11||[msgDict[@"msg_id"] integerValue] == 10||[msgDict[@"msg_id"] integerValue] == 9||[msgDict[@"msg_id"] integerValue] == 8||[msgDict[@"msg_id"] integerValue] == 46||[msgDict[@"msg_id"] integerValue] == 45){
        
        long fid = [msgDict[@"fid"] longValue];
        
        StagingBillVC *vc = [[StagingBillVC alloc]init];
        
        vc.installmentBIllidStr = [NSString stringWithFormat:@"%ld",fid];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MsgModel *model = self.dataArray[indexPath.section];
    
    NSDictionary *msgDict = model.msg.mj_JSONObject;
    
    if ([msgDict[@"msg_id"] integerValue] == 23) {//邀请类
        
        return [tableView fd_heightForCellWithIdentifier:@"InviteMsgCell" cacheByIndexPath:indexPath configuration:^(InviteMsgCell * cell) {
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentLabel.text = model.title;
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            df.dateFormat = @"yyyy-MM-dd";
            NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:model.addtime];
            NSString *time = [df stringFromDate:lastDate];
            cell.timeLabel.text = time;
            cell.delegate = self;
            NSString *tId = msgDict[@"tId"];
            cell.inviteId = tId;
        }];
        
    } else {
        return [tableView fd_heightForCellWithIdentifier:@"SystemMsgCell" cacheByIndexPath:indexPath configuration:^(SystemMsgCell * cell) {
            cell.backgroundColor = [UIColor whiteColor];
            MsgModel *model = self.dataArray[indexPath.section];
            
            cell.contentLabel.text = model.title;
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            df.dateFormat = @"yyyy-MM-dd";
            NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:model.addtime];
            NSString *time = [df stringFromDate:lastDate];
            cell.timeLabel.text = time;
            cell.contentLabel.adjustsFontSizeToFitWidth = YES;
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MsgModel *model = self.dataArray[indexPath.section];
    
    NSDictionary *msgDict = model.msg.mj_JSONObject;

    if ([msgDict[@"msg_id"] integerValue] == 23) {//邀请类
        
        static NSString * identifer = @"InviteMsgCell";
        InviteMsgCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentLabel.text = model.title;
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy-MM-dd";
        NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:model.addtime];
        NSString *time = [df stringFromDate:lastDate];
        cell.timeLabel.text = time;
        cell.delegate = self;
        NSString *tId = msgDict[@"tId"];
        cell.inviteId = tId;
        return cell;
        
    } else {
        static NSString * identifer = @"SystemMsgCell";
        SystemMsgCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.contentLabel.text = model.title;
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy-MM-dd";
        NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:model.addtime];
        NSString *time = [df stringFromDate:lastDate];
        cell.timeLabel.text = time;
        cell.contentLabel.adjustsFontSizeToFitWidth = YES;
        return cell;
    }
}

-(void)inviteMsgCell:(InviteMsgCell *)cell didClickAgreeOrRejectBtnWithString:(NSString *)str {
    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    NSString *postUrl =  self.interfaceManager.recruitUpdate;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"result"] = str;
    param[@"tid"] = cell.inviteId;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/recruit/update" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    [HJHttpManager PostRequestWithUrl:postUrl param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        if (code == 1) {
            [self.hudManager showSuccessSVHudWithTitle:msg hideAfterDelay:1.0 animaton:YES];
        } else {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0];
        }
    } failed:^(NSError *error) {
        [self.hudManager showErrorSVHudWithTitle:@"请求失败" hideAfterDelay:1.0];
    }];
}


#pragma mark -- DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无消息哦";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark -- DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

@end
