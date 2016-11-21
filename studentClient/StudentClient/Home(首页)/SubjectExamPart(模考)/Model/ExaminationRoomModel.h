//
//  ExaminationRoomModel.h
//  学员端
//
//  Created by gaobin on 16/8/4.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExaminationRoomModel : NSObject

@property (nonatomic, assign) int idNum;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * distance;
@property (nonatomic, assign) NSString * Remaining; //剩余空位,文档上首字母就是大写的,目前数据为空

@end
