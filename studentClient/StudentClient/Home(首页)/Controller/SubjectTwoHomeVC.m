//
//  SubjectTwoHomeVC.m
//  学员端
//
//  Created by zuweizhong  on 16/7/13.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SubjectTwoHomeVC.h"
#import "SubjectVideoModel.h"
#import "SubjectPhotoModel.h"
#import "SubjectTwoVideoCell.h"
#import "SubjectTwoPhotoCell.h"
#import "SubjectTwoRealCell.h"
#import "SeekHelpCell.h"
#import <IQKeyboardReturnKeyHandler.h>
#import "SubjectTwoExamHomeVC.h"
#import "CLDropDownMenu.h"
#import "SubjectThreeHomeVC.h"
#import "SubjectOneHomeVC.h"
#import "MoviePlayerViewController.h"
#import "SubjectFourHomeVC.h"
#import "SubjectDetailController.h"
#import "BaseWebController.h"
#import "PartnerTrainingVC.h"
@interface SubjectTwoHomeVC ()<UITableViewDelegate,UITableViewDataSource,SubjectTwoVideoCellDelegate,SubjectTwoPhotoCellDelegate,SeekHelpCellDelegate>

@property(nonatomic,weak)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * videoArray;
@property(nonatomic,strong)NSMutableArray * photoArray;
@property (nonatomic, strong) CLDropDownMenu * dropMenu;
@property(nonatomic,strong)NSMutableArray * quickEntrancesArray;

@end

@implementation SubjectTwoHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f7f6"];
    
    self.quickEntrancesArray = [NSMutableArray array];
    
    [self createCenterBtnNavWithLeftBtnImageName:@"返回" leftHighlightImageName:nil leftBtnSelector:@selector(back) andCenterTitle:@"科目二" centerBtnSelector:@selector(centerBtnClick:) andRightBtnImageName:nil rightHighlightImageName:nil rightBtnSelector:nil withRightBtnTitle:nil];

    
    [self createUI];
    
    
    [self loadData];
    

}
-(void)loadData
{

    [self.hudManager showNormalStateSVHUDWithTitle:@"正在加载..."];

    NSString *url = self.interfaceManager.subjectThird;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    param[@"uid"] = kUid;
    param[@"time"] = time;
    param[@"sign"] = [HttpParamManager getSignWithIdentify:@"/subjectThird" time:time];
    param[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    param[@"subject"] = @"second";
    [HJHttpManager PostRequestWithUrl:url param:param finish:^(NSData *data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@"%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString *msg = dict[@"msg"];
        
        if (code == 1) {
            NSArray *arr1 = dict[@"info"][@"articles"];
            self.photoArray = [SubjectPhotoModel mj_objectArrayWithKeyValuesArray:arr1];
            NSArray *arr2 = dict[@"info"][@"videos"];
            self.videoArray = [SubjectVideoModel mj_objectArrayWithKeyValuesArray:arr2];
            self.quickEntrancesArray = dict[@"info"][@"quickEntrances"];

            [self.tableView reloadData];
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
- (CLDropDownMenu *)dropMenu {
    
    if (!_dropMenu) {
        _dropMenu = [[CLDropDownMenu alloc] initWithBtnPressedByWindowFrame:CGRectMake(kScreenWidth/2 , -128, 60, 120) Pressed:^(NSInteger index) {
            if (index == 0) {
                SubjectOneHomeVC * vc = [[SubjectOneHomeVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }if (index == 1) {
                SubjectThreeHomeVC * vc = [[SubjectThreeHomeVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }if (index == 2) {
                NSLog(@"跳转科目四");
                SubjectFourHomeVC * vc = [[SubjectFourHomeVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }];
        
        _dropMenu.removeFromSupviewHandle = ^(){
            
            _dropMenu = nil;
            
        };
        _dropMenu.direction = CLDirectionTypeBottom;
        _dropMenu.titleList = @[@"科目一",@"科目三",@"科目四"];
    }
    
    return _dropMenu;
    
    
}
- (void)centerBtnClick:(UIButton *)btn {
    
    if (!_dropMenu) {
        
        [self.view addSubview:self.dropMenu];
        
    }else {
        
        [self.dropMenu removeFromSuperview];
        self.dropMenu = nil;
    }
    
    
}

-(NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];

    }
    return _photoArray;

}
-(NSMutableArray *)videoArray
{
    if (!_videoArray) {
        
        _videoArray = [NSMutableArray array];
    }
    
    return _videoArray;

}
-(void)createUI
{
    //创建UITableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight-kNavHeight) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setExtraCellLineHidden];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    [self.view addSubview:tableView];
    [self.tableView registerClass:[SubjectTwoVideoCell class] forCellReuseIdentifier:@"SubjectTwoVideoCell"];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 1;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }

    return 9;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return CGFLOAT_MIN;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (indexPath.section == 0) {
        
        return [SubjectTwoVideoCell getCellHeightWithData:self.videoArray];
    }
    if (indexPath.section == 1) {
        
        return [SubjectTwoPhotoCell getCellHeightWithData:self.photoArray];
    }
  
    if (indexPath.section == 2) {
        
        return (kScreenWidth-26)*0.3337+5+5;
    }
    
    if (indexPath.section == 3) {
        
        return 240;
    }
    return 0;
   

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        static NSString *identify = @"SubjectTwoVideoCell";
        
        SubjectTwoVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (!cell) {
            cell = [[SubjectTwoVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        [cell configCellUIWithVideoModelArray:self.videoArray];
        
        cell.videoModelArray = self.videoArray;
        
        cell.delegate = self;

        return cell;
    }
    
    if (indexPath.section == 1) {
        
        static NSString *identify = @"SubjectTwoPhotoCell";
        
        SubjectTwoPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (!cell) {
            cell = [[SubjectTwoPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        [cell configCellUIWithPhotoModelArray:self.photoArray];
        
        cell.photoModelArray = self.photoArray;
        
        cell.delegate = self;

        return cell;
    }
    if (indexPath.section == 2) {
        
        static NSString *identify = @"SubjectTwoRealCell";
        
        SubjectTwoRealCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SubjectTwoRealCell" owner:nil options:nil]lastObject];
        }
        [cell.testSimulaterBtn removeAllTargets];
        [cell.testSimulaterBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [cell.testSimulaterBtn setImage:[UIImage imageNamed:@"学时陪练2"] forState:UIControlStateNormal];
        return cell;
    }
    if (indexPath.section == 3) {
        
        static NSString * identifier = @"SeekHelpCell";
        SeekHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[SeekHelpCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.delegate = self;
        cell.subjectNumber = @"二";
        return cell;
    }
    
    
    
    return nil;

}
-(void)seekHelpCellDidClickSendBtn:(SeekHelpCell *)cell
{
    if ([cell.textView.text isEqualToString:@""]||cell.textView.text == nil) {
        [self.hudManager showErrorSVHudWithTitle:@"内容不能为空!" hideAfterDelay:1.0f];
        return;
    }
    [self.hudManager showNormalStateSVHUDWithTitle:@"正在操作..."];
    
    NSString * url = self.interfaceManager.communityCreateUrl;
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    NSString *time = [HttpParamManager getTime];
    paramDict[@"uid"] = kUid;
    paramDict[@"time"] = time;
    paramDict[@"sign"] = [HttpParamManager getSignWithIdentify:@"/community/create" time:time];
    paramDict[@"deviceInfo"] = [HttpParamManager getDeviceInfo];
    paramDict[@"cityId"] = @([HttpParamManager getCurrentCityID]);
    paramDict[@"communityType"] = @(0);
    paramDict[@"content"] = cell.textView.text;
    paramDict[@"anonymous"] = @(0);
    paramDict[@"address"] = [NSString stringWithFormat:@"%@,%@",[HttpParamManager getLongitude],[HttpParamManager getLatitude]];
    
    [HJHttpManager PostRequestWithUrl:url param:paramDict finish:^(NSData *data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        HJLog(@">>>>%@",dict);
        NSInteger code = [dict[@"code"] integerValue];
        NSString * msg = dict[@"msg"];
        if (code == 1)
        {
            [self.hudManager showSuccessSVHudWithTitle:msg hideAfterDelay:1.0 animaton:YES];
        }
        else {
            
            [self.hudManager showErrorSVHudWithTitle:msg hideAfterDelay:1.0f];
            
        }
        
    } failed:^(NSError *error) {
        
        [self.hudManager showErrorSVHudWithTitle:@"加载失败" hideAfterDelay:1.0f];
    }];
    cell.textView.text = nil;
    
}

-(void)subjectTwoVideoCell:(SubjectTwoVideoCell *)cell didClickItemViewWithItemModel:(SubjectVideoModel *)itemModel
{
    HJLog(@"%@",itemModel);
    
    SubjectDetailController *vc = [[SubjectDetailController alloc] init];
    
    vc.urlString = itemModel.url;
    
    vc.titleString = itemModel.title;
    
    [self.navigationController pushViewController:vc animated:YES];


}
-(void)subjectTwoPhotoCell:(SubjectTwoPhotoCell *)cell didClickItemViewWithItemModel:(SubjectPhotoModel *)itemModel
{
    HJLog(@"%@",itemModel);
    
    SubjectDetailController *vc = [[SubjectDetailController alloc] init];
    
    vc.urlString = itemModel.pageUrl;
    
    vc.titleString = itemModel.title;

    [self.navigationController pushViewController:vc animated:YES];


}
-(void)back
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}
- (void)action:(UIButton *)btn
{
    PartnerTrainingVC *VC = [[PartnerTrainingVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];

    /*
    SubjectTwoRealCell *cell = (SubjectTwoRealCell *)btn.superview.superview;
    NSString *url = cell.dict[@"actionScript"];
    BaseWebController *baseVC = [[BaseWebController alloc]init];
    NSString *urlStr = [NSString stringWithFormat:@"%@?app=1&uid=%@",url,kUid];
    baseVC.urlString = urlStr;
    baseVC.titleString = @"详情";
    [self.navigationController pushViewController:baseVC animated:YES];
     */
    
}
@end
