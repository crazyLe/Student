//
//  PartnerTrainModel.h
//  学员端
//
//  Created by gaobin on 16/8/3.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BindingTeacherModel.h"
#import "TeachingTimesModel.h"
#import "CarTypesModel.h"
@interface PartnerTrainModel : NSObject

@property (nonatomic, copy) NSString * selectCarType;
@property (nonatomic, strong) NSMutableArray<TeachingTimesModel *> * teachingTimes;
@property (nonatomic, strong) NSMutableArray<CarTypesModel *> * carTypes;
@property (nonatomic, strong) BindingTeacherModel  * bindingTeacher;

@property (nonatomic, copy) NSString * bindstatus;



@end
