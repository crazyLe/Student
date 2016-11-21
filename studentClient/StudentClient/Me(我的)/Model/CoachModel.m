//
//  CoachModel.m
//  学员端
//
//  Created by 翁昌青 on 16/8/5.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "CoachModel.h"

@implementation CoachModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"idNum":@"id",@"schoolName":@"driving_school"};
}

@end
