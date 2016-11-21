//
//  PartnerTrainModel.m
//  学员端
//
//  Created by gaobin on 16/8/3.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PartnerTrainModel.h"


@implementation PartnerTrainModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"teachingTimes":[TeachingTimesModel class],@"carTypes":[CarTypesModel class],@"bindingTeacher":[BindingTeacherModel class]};
}



@end
