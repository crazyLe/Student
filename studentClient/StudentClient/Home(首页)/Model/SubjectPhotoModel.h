//
//  SubjectPhotoModel.h
//  学员端
//
//  Created by zuweizhong  on 16/7/13.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubjectPhotoModel : NSObject

@property(nonatomic,copy)NSString * imgUrl;
@property(nonatomic,copy)NSString * pageUrl;
@property(nonatomic,assign)int  readCount;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,assign)int  createTime;

@end
