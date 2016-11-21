//
//  PartnerTrainingDetailVC.m
//  学员端
//
//  Created by zuweizhong  on 16/7/14.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PartnerTrainingDetailVC.h"
#import "PartnerTrainingDetailCell1.h"
#import "PartnerTrainingDetailCell2.h"
#import "PartnerTrainOrderController.h"
#import "TeachModel.h"
#import "OrderInfoModel.h"
@interface PartnerTrainingDetailVC ()<UITableViewDelegate,UITableViewDataSource,PartnerTrainingDetailCell2Delegate>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)UIButton * confirmBtn;

@property(nonatomic,strong)NSMutableArray * orderModelArray;

@property(nonatomic,strong)NSDate * currentSelectDate;

@property(nonatomic,strong)NSMutableArray * selectTimeModelArray;

@property(nonatomic,strong)OrderInfoModel * orderInfoModel;

@property(nonatomic,strong)NSMutableArray * hasSelectArray;


@end

@implementation PartnerTrainingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.selectTimeModelArray = [NSMutableArray array];
    
    self.hasSelectArray = [NSMutableArray array];
    
    self.currentSelectDate = [NSDate date];
    
    self.orderModelArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f7f6"];
    
    [self configNav];
    
    [self createUI];
    
    [self loadCurrentData];
    
    
}
-(void)loadCurrentData
{
    
    NSDate *currentD = [NSDate date];
    
    self.currentSelectDate = [GHDateTools dateByAddingDays:currentD day:2];
    
    
    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    NSString * url = self.interfaceManager.teachingDetailUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/teachingDetail"time:time];
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    paramDict[@"subject"] = self.subjectNum;
    paramDict[@"teacherId"] = self.teachModel.uid;
    paramDict[@"day"] = @(self.currentSelectDate.timeIntervalSince1970);
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@">>>%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            NSDictionary * infoDict = [dict objectForKey:@"info"];
            
            NSArray *arr = infoDict[@"teachingList"];
            
            self.orderModelArray = [TeachModel mj_objectArrayWithKeyValuesArray:arr];
            
            SelectOrderModel *model = [[SelectOrderModel alloc]init];
            
            model.date = self.currentSelectDate;
            
            model.teachModelArray = self.orderModelArray;
            
            [self.hasSelectArray addObject:model];
            
            [self.tableView reloadData];
            
            [self.hudManager dismissSVHud];
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
        }
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
    }];

}
-(void)createUI
{
    //创建UITableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-kNavHeight-52) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setExtraCellLineHidden];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    [self.view addSubview:tableView];
    
    
    UIButton *confirmBtn = [[UIButton alloc]init];
    
    confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#5cb6ff"];
    
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.confirmBtn = confirmBtn;
    
    [confirmBtn setTitle:@"确定预约" forState:UIControlStateNormal];
    
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.confirmBtn];

    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        
        make.right.offset(0);
        
        make.bottom.offset(0);
        
        make.height.equalTo(@52);
        
    }];
    
    
    
}
-(void)confirmBtnClick
{
    if (kLoginStatus) {
        [self.hudManager showNormalStateSVHUDWithTitle:nil];
        NSString * url = self.interfaceManager.loadOrderUrl;
        NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
        paramDict[@"uid"] = kUid;
        NSString * time = [HttpParamManager getTime];
        paramDict[@"time"] = time;
        paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/Orderinfo/loadOrder" time:time];
        NSMutableString *str = [[NSMutableString alloc]init];
        for (int i = 0; i<self.selectTimeModelArray.count; i++) {
            TeachModel *model = self.selectTimeModelArray[i];
            [str appendString:[NSString stringWithFormat:@",%d",model.xsid]];
        }
        if (str.length == 0) {
            [self.hudManager showErrorSVHudWithTitle:@"还没有选择时段" hideAfterDelay:1.0];
            return;
        }
        NSString *ids = [str substringFromIndex:1];
        paramDict[@"productId"] = ids;
        paramDict[@"orderType"] = @(5);
        paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
        
        [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            HJLog(@">>>%@",dict);
            NSInteger code = [dict[@"code"] integerValue];
            NSString * msg = dict[@"msg"];
            if (code == 1) {
                NSDictionary * infoDict = [dict objectForKey:@"info"][@"orderInfo"];
                
                self.orderInfoModel = [OrderInfoModel mj_objectWithKeyValues:infoDict];
                
                PartnerTrainOrderController *orderVC = [[PartnerTrainOrderController alloc]init];
                orderVC.orderInfoModel = self.orderInfoModel;
                orderVC.subjectNum = self.subjectNum;
                orderVC.jiaLing = [NSString stringWithFormat:@"%d年驾龄",self.teachModel.driving_experience];
                [self.navigationController pushViewController:orderVC animated:YES];
                
                [self.hudManager dismissSVHud];
                
            }
            else
            {
                [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
            }
        } failed:^(NSError *error) {
            
            [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
        }];

    }
    else
    {
    
        LoginGuideController * vc = [[LoginGuideController alloc]init];
    
        JTNavigationController *nav = [[JTNavigationController alloc]initWithRootViewController:vc];
    
        [self presentViewController:nav animated:YES completion:nil];
    }

    
    
    
    
    
    


}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    
    return 10;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return CGFLOAT_MIN;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 93;
    }

    if (indexPath.section == 1) {
        
        PartnerTrainingDetailCell2 *cell = (PartnerTrainingDetailCell2 *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        [cell setNeedsLayout];
        
        [cell layoutIfNeeded];

        return cell.cellHeight;
    }
    return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *identify = @"PartnerTrainingDetailCell1";
        
        PartnerTrainingDetailCell1 *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PartnerTrainingDetailCell1" owner:nil options:nil]lastObject];
        }
        cell.nameLabel.text = self.teachModel.name;
        
        cell.isvipimageView.hidden = [self.teachModel.certification isEqualToString:@"1"]?NO:YES;
        
        [cell.jiaAgeLabel setTitle:[NSString stringWithFormat:@"%d年驾龄",self.teachModel.driving_experience] forState:UIControlStateNormal];
                
        cell.carTypeLabel.text = [NSString stringWithFormat:@"培训车辆:%@",self.teachModel.carType];
        
        cell.placeLabel.text = [NSString stringWithFormat:@"培训场地:%@",self.teachModel.address];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.teachModel.imgUrl] placeholderImage:[UIImage imageNamed:@"头像"]];
        
        return cell;
    }
    if (indexPath.section == 1) {
        
        static NSString *identify1 = @"PartnerTrainingDetailCell2";
        
        PartnerTrainingDetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        
        if (!cell) {
            cell = [[PartnerTrainingDetailCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1];
        }
        cell.delegate = self;
        cell.hasSelectedTimeModelArray = self.selectTimeModelArray;
        cell.orderModelArr = self.orderModelArray;
        cell.currentSelectDate = self.currentSelectDate;
        return cell;
    }
    
    return nil;
    
  
}
-(void)partnerTrainingDetailCell2:(PartnerTrainingDetailCell2 *)cell didGetselectedTimeModelArray:(NSMutableArray *)timeModelArray
{
    self.selectTimeModelArray = timeModelArray;
    
    cell.selectedLabel.attributedText = [cell getSelectedLabelAttributeTextWithNumber:(int)timeModelArray.count];

    
}
-(void)partnerTrainingDetailCell2:(PartnerTrainingDetailCell2 *)cell didSelectDayViewWithTime:(long long)time1
{
    NSDate *currentD = [NSDate dateWithTimeIntervalSince1970:time1];
    
    for (int i = 0; i<self.hasSelectArray.count; i++) {
        SelectOrderModel *model = self.hasSelectArray[i];
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"MM-dd";
        NSString *str1 = [df stringFromDate:model.date];
        NSString *str2 = [df stringFromDate:currentD];
        if ([str1 isEqualToString:str2]) {
            self.currentSelectDate = currentD;
            self.orderModelArray = model.teachModelArray;
            [self.tableView reloadData];
            return;
        }
        
    }
    
    self.currentSelectDate = currentD;
    [self.hudManager showNormalStateSVHUDWithTitle:nil];
    NSString * url = self.interfaceManager.teachingDetailUrl;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    paramDict[@"uid"] = kUid;
    NSString * time = [HttpParamManager getTime];
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/teachingDetail"time:time];
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    paramDict[@"subject"] = self.subjectNum;
    paramDict[@"teacherId"] = self.teachModel.uid;
    paramDict[@"day"] = @(time1);
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@">>>%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1) {
            NSDictionary * infoDict = [dict objectForKey:@"info"];
          
            NSArray *arr = infoDict[@"teachingList"];
            
            self.orderModelArray = [TeachModel mj_objectArrayWithKeyValuesArray:arr];
            
            [self.tableView reloadData];
            
            [self.hudManager dismissSVHud];
            
            SelectOrderModel *model = [[SelectOrderModel alloc]init];
            
            model.date = self.currentSelectDate;
            
            model.teachModelArray = self.orderModelArray;
            
            [self.hasSelectArray addObject:model];
            
        }
        else
        {
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1];
        }
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0];
    }];




}

- (void)configNav {

    [self createNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back)  andCenterTitle:@"学时陪练"];

}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end


@implementation SelectOrderModel



@end
