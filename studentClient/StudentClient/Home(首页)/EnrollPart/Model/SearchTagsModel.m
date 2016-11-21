//
//  SearchTagsModel.m
//  学员端
//
//  Created by zuweizhong  on 16/8/3.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SearchTagsModel.h"
@implementation SearchTagsModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"values":[ValueModel class]};

}
@end
