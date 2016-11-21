//
//  ProvinceModel.h
//  学员端
//
//  Created by zuweizhong  on 16/8/9.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CityModel;

@class CountryModel;


@interface ProvinceModel : NSObject<NSCoding>

@property(nonatomic,assign)int idNum;

@property(nonatomic,strong)NSString * name;

@property(nonatomic,assign)int parent_id;

@property(nonatomic,strong)NSMutableArray<CityModel *> * citys;

@end

@interface CityModel : NSObject<NSCoding>


@property(nonatomic,assign)int idNum;

@property(nonatomic,strong)NSString * name;

@property(nonatomic,assign)int parent_id;

@property(nonatomic,strong)NSMutableArray<CountryModel *> * countrys;


@end

@interface CountryModel : NSObject<NSCoding>

@property(nonatomic,assign)int idNum;

@property(nonatomic,strong)NSString * name;

@property(nonatomic,assign)int parent_id;


@end


