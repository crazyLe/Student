//
//  PersonalInfoModel.m
//  学员端
//
//  Created by gaobin on 16/8/5.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PersonalInfoModel.h"

@implementation PersonalInfoModel

singletonImplementation(PersonalInfoModel)

-(void)configDict:(NSDictionary *)dict
{
    
    [PersonalInfoModel sharedPersonalInfoModel].address = dict[@"address"];
    [PersonalInfoModel sharedPersonalInfoModel].age =[NSString stringWithFormat:@"%@",dict[@"age"]];
    [PersonalInfoModel sharedPersonalInfoModel].areaId = [NSString stringWithFormat:@"%@",dict[@"areaId"]];
    
    [PersonalInfoModel sharedPersonalInfoModel].beans = [NSString stringWithFormat:@"%@",dict[@"beans"]];

    [PersonalInfoModel sharedPersonalInfoModel].cityId = [NSString stringWithFormat:@"%@",dict[@"cityId"]];
    
    [PersonalInfoModel sharedPersonalInfoModel].face = dict[@"face"];
    
    [PersonalInfoModel sharedPersonalInfoModel].introduce = dict[@"introduce"];
    [PersonalInfoModel sharedPersonalInfoModel].isver = [dict[@"isver"] intValue];
    [PersonalInfoModel sharedPersonalInfoModel].mymessage = [NSString stringWithFormat:@"%@",dict[@"mymessage"]];

    [PersonalInfoModel sharedPersonalInfoModel].nickName =[NSString stringWithFormat:@"%@",dict[@"nickName"]];
    [PersonalInfoModel sharedPersonalInfoModel].phone = [NSString stringWithFormat:@"%@",dict[@"phone"]];
    [PersonalInfoModel sharedPersonalInfoModel].provinceId =  [NSString stringWithFormat:@"%@",dict[@"provinceId"]];
    [PersonalInfoModel sharedPersonalInfoModel].sex = [NSString stringWithFormat:@"%@",dict[@"sex"]];
    [PersonalInfoModel sharedPersonalInfoModel].trueName = dict[@"trueName"];
}

@end
