//
//  TeachModel.h
//  学员端
//
//  Created by zuweizhong  on 16/8/15.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeachModel : NSObject

@property(nonatomic,copy)NSString * cost;
@property(nonatomic,assign)long long endTime;
@property(nonatomic,assign)long long startTime;
@property(nonatomic,assign)int  idNum;
@property(nonatomic,assign)int  remaining;
@property(nonatomic,assign)int  totalPlaces;
@property(nonatomic,assign)int  xsid;
/**
 *  是否选中
 */
@property(nonatomic,assign)BOOL isSelected;

@end
