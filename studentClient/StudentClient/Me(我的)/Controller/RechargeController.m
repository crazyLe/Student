//
//  RechargeController.m
//  学员端
//
//  Created by zuweizhong  on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "RechargeController.h"
#import "RechargeCell.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

@interface RechargeController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    NSString *douzi;
    int chongzhiMoney;
    NSString *payway;
}
@property(nonatomic,strong)UITableView * tableView;

@end

@implementation RechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_COLOR;
    
    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"充值"];
    
    douzi = @"0";
    
    [self createUI];
    
    [self quarydouzi];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedouzi) name:kWeiXinPaySuccessNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedouzi) name:@"ALIPAYSUCCEED" object:nil];
    
    
}
- (void)updatedouzi
{
    [self quarydouzi];
}

/**
 *  一定要加这句，否则有可能在push的时候留下白边
 */
-(void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

//查询豆子
- (void)quarydouzi
{
    NSString *url = self.interfaceManager.getMypurseUrl;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Mypurse/Purse" time:time];
    param[@"deviceInfo"] =[HttpParamManager getDeviceInfo];

    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
         NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSLog(@"%@",dict);
        
        int code = [dict[@"code"] intValue];
        if (1 == code) {
         douzi =  dict[@"info"][@"userinfo"][@"beans"];
        [self.tableView reloadData];
        }
    } failed:^(NSError *error) {
        
    }];
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createUI
{
    //创建tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-kNavHeight) style:UITableViewStylePlain];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setExtraCellLineHidden];
    tableView.allowsSelection = NO;
    tableView.separatorColor = [UIColor colorWithHexString:@"f0f0f0"];
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:@"RechargeCell" bundle:nil] forCellReuseIdentifier:@"RechargeCell"];

}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return [tableView fd_heightForCellWithIdentifier:@"RechargeCell" cacheByIndexPath:indexPath configuration:^(id cell) {
        
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identify = @"RechargeCell";
    RechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    
    cell.moneyNumLabel.text = douzi;
        
    cell.chongzhi = ^(int money){
        
        chongzhiMoney = money;
        
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝",@"微信", nil];
        [action showInView:self.view];
    };
    
    return cell;
 
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%lu",buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            [self getPaydata:@"1"];
        }
            break;
        case 1:
        {
            if(![WXApi isWXAppInstalled]){
                [self.hudManager showErrorSVHudWithTitle:@"请先安装微信客户端" hideAfterDelay:1.0];
                return;
            };
            [self getPaydata:@"3"];
        }
            break;
            
        default:
            break;
    }
}

//（3微信，1支付宝，2银联）
- (void)getPaydata:(NSString *)paytype
{
    NSString *timestr = [HttpParamManager getTime];
    NSString *url = self.interfaceManager.chongzhiDou;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = kUid;
    param[@"time"] = timestr;
    param[@"sign"] = [HttpsTools getSignWithIdentify:@"/topUpBeans" time:timestr];
    
    param[@"totalMoney"] = @(0.1);
    param[@"totalBeans"] = @(1);
    
//    param[@"totalMoney"] = @(chongzhiMoney);
//    param[@"totalBeans"] = @(chongzhiMoney*10);
    
    param[@"payType"] = paytype;
    
    payway = paytype;

    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@",dict);
        int code = [dict[@"code"] intValue];
        NSDictionary *backdata = dict[@"info"];
        if (1 == code) {
                NSString *content = backdata[@"content"];

                switch ([payway intValue]) {
                    case 1://支付宝
                    {
                        [self alipayWithcontent:content];
                    }
                        break;
                        
                    case 3://微信
                    {
                        NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:content options:0];
                        NSDictionary *decodeDic = [NSJSONSerialization JSONObjectWithData:decodeData options:NSJSONReadingMutableContainers error:nil];
                        [self weipaywithcontent:decodeDic];
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark 微信支付方法
- (void)weipaywithcontent:(NSDictionary *)decodeDic
{
    PayReq *payReq = [[PayReq alloc] init];
    //    payReq.openID              = [decodeDic objectForKey:@"appId"];
    payReq.partnerId           = [decodeDic objectForKey:@"partnerId"];
    payReq.prepayId            = [decodeDic objectForKey:@"prepayId"];
    payReq.nonceStr            = [decodeDic objectForKey:@"nonceStr"];
    payReq.timeStamp           = [[decodeDic objectForKey:@"timeStamp"] unsignedIntValue];
    payReq.package             = [decodeDic objectForKey:@"packageValue"];
    payReq.sign                = [decodeDic objectForKey:@"sign"];
    //发送请求到微信，等待微信返回onResp
    [WXApi sendReq:payReq];
}

- (void)alipayWithcontent:(NSString *)content
{
    [[NSUserDefaults standardUserDefaults] setObject:@"chongzhi" forKey:@"payaims"];
    
    [[AlipaySDK defaultService] payOrder:content fromScheme:@"alipaySDK" callback:^(NSDictionary *resultDic) {
        // 处理支付结果
        //        9000 订单支付成功
        //        8000 正在处理中
        //        4000 订单支付失败
        //        6001 用户中途取消
        //        6002 网络连接出错
        int code = [resultDic[@"resultStatus"] intValue];
        if (9000 == code) {
            [self.hudManager showSuccessSVHudWithTitle:@"赚豆充值成功" hideAfterDelay:2.0 animaton:YES];
            [self quarydouzi];
            
        }else
        {
            [self.hudManager showSuccessSVHudWithTitle:@"赚豆充值失败" hideAfterDelay:2.0 animaton:YES];
        }
    }];
}

@end
