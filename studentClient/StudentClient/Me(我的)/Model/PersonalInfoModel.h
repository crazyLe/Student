//
//  PersonalInfoModel.h
//  学员端
//
//  Created by gaobin on 16/8/5.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalInfoModel : NSObject

singletonInterface(PersonalInfoModel)

@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * age;
@property (nonatomic, copy) NSString * areaId;
@property (nonatomic, copy) NSString * cityId;
@property (nonatomic, copy) NSString * face;
@property (nonatomic, copy) NSString * introduce;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * provinceId;
@property (nonatomic, copy) NSString * sex;
@property (nonatomic, copy) NSString * trueName;
@property (nonatomic, copy) NSString * beans;
@property (nonatomic, assign) int isver;
@property (nonatomic, copy) NSString * mymessage;

-(void)configDict:(NSDictionary *)dict;

@end
