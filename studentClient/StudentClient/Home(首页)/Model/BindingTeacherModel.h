//
//  BindingTeacherModel.h
//  学员端
//
//  Created by gaobin on 16/8/3.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BindingTeacherModel : NSObject

@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * teachingRemark;
@property(nonatomic,assign)int teachingRemarknum;
@property (nonatomic, copy) NSString * address;
@property(nonatomic,assign)int driving_experience;
@property (nonatomic, copy) NSString * face;
@property (nonatomic, copy) NSString * carType;

@property(nonatomic,assign)int state;


@end
