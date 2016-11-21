//
//  SearchTagsModel.h
//  学员端
//
//  Created by zuweizhong  on 16/8/3.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValueModel.h"

@interface SearchTagsModel : NSObject

@property(nonatomic,strong)NSString * title;
@property(nonatomic,assign)int typeid;
@property(nonatomic,strong)NSArray * values;


@end
