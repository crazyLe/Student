//
//  SubjectVideoModel.h
//  学员端
//
//  Created by zuweizhong  on 16/7/13.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubjectVideoModel : NSObject

@property(nonatomic,copy)NSString * imgUrl;

@property(nonatomic,copy)NSString * title;

@property(nonatomic,assign)long long time;

@property(nonatomic,assign)int  idNum;

@property(nonatomic,copy)NSString * remark;

@property(nonatomic,copy)NSString * url;

@end
