//
//  CitySelectController.m
//  学员端
//
//  Created by zuweizhong  on 16/8/1.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLAddress.h"
#import "CitySelectController.h"
#import "BAddressPickerController.h"
@interface CitySelectController ()<BAddressPickerDelegate,BAddressPickerDataSource>

@end

@implementation CitySelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    self.title = @"城市选择";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageWithOriginName:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    
    BAddressPickerController *addressPickerController = [[BAddressPickerController alloc] initWithFrame:self.view.frame];
    addressPickerController.dataSource = self;
    addressPickerController.delegate = self;
    [self addChildViewController:addressPickerController];
    [self.view addSubview:addressPickerController.view];
    
}
-(void)leftAction:(UIBarButtonItem *)leftBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark - BAddressController Delegate

- (NSArray*)arrayOfHotCitiesInAddressPicker:(BAddressPickerController *)addressPicker{
//    return @[@"北京",@"上海",@"深圳",@"杭州",@"广州",@"武汉",@"天津",@"重庆",@"成都",@"苏州"];
    return @[];
}

- (void)addressPicker:(BAddressPickerController *)addressPicker didSelectedCity:(NSString *)city
{
    NSLog(@"选择---------%@",city);
    /*
    [LLAddress getCityId:city completeBlock:^(BOOL isSuccess, NSString *areaName, NSString *areaID) {
        if (isSuccess) {
            //保存选择的城市ID
            NSLog(@"2222=====>countyID : %@\n 2222==>countyName : %@",areaID,areaName);
            [kUserDefault setObject:areaName forKey:@"locationCity"]; //全称
            [kUserDefault setObject:areaID forKey:@"locationID"];     //地区ID
        }
    }];
    */
    
    [kUserDefault  setObject:city forKey:@"locationCity"];  //简称
    
    [kUserDefault synchronize];
    
    /*
    if (self.didSelectCityBlock) {
        self.didSelectCityBlock(city);
    }
     */
    
    [NOTIFICATION_CENTER postNotificationName:kLocationChangeNotification object:nil userInfo:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)beginSearch:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)endSearch:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


@end
