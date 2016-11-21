//
//  OSAddressPickerView.h
//  AddressPicker
//
//  Created by mac on 16/8/2.
//  Copyright © 2016年 筒子家族. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProvinceModel.h"
typedef  void(^AdressBlock)(ProvinceModel *provinceModel, CityModel *cityModel, CountryModel *districtModel);

@interface OSAddressPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,copy) AdressBlock block;

@property(nonatomic,strong)NSMutableArray * dataArray;


+ (id)shareInstance;
- (void)showBottomView;

@end
