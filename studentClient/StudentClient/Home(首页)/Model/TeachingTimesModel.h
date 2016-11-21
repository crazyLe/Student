//
//  TeachingTimesModel.h
//  学员端
//
//  Created by gaobin on 16/8/3.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeachingTimesModel : NSObject

@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * certification;
@property (nonatomic, copy) NSString * charge;
@property (nonatomic, copy) NSString * carType;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * imgUrl;
@property (nonatomic, copy) NSString * distance;
@property(nonatomic,assign)int driving_experience;


@end
