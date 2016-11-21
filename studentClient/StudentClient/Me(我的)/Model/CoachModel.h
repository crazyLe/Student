//
//  CoachModel.h
//  学员端
//
//  Created by 翁昌青 on 16/8/5.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoachModel : NSObject
//教练id
@property(copy,nonatomic)NSString   *coachId;

@property(copy,nonatomic)NSString   *idNum;

@property(copy,nonatomic)NSString   *uid;


@property(copy,nonatomic)NSString   *name;
@property(copy,nonatomic)NSString   *phone;

@property(copy,nonatomic)NSString   *age;
@property(copy,nonatomic)NSString   *schoolId;
@property(copy,nonatomic)NSString   *schoolName;
//头像
@property(copy,nonatomic)NSString   *imgUrl;
@property(copy,nonatomic)NSString   *subjects;
//是否认证
@property(copy,nonatomic)NSString   *certification;
@property(copy,nonatomic)NSString   *bind_status;

@end
