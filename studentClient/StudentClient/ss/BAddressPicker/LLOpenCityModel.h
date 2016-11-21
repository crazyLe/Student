//
//  LLOpenCityModel.h
//  Coach
//
//  Created by LL on 16/9/21.
//  Copyright © 2016年 sskz. All rights reserved.
//
/*
 (
 {
 hot = 0;
 id = 110101;
 name = "\U4e1c\U57ce\U533a";
 "parent_id" = 110100;
 pinyin = "<null>";
 "short_name" = "\U4e1c\U57ce";
 title = "\U4e1c\U57ce\U533a";
 }
 )
 */

#import <Foundation/Foundation.h>

@interface LLOpenCityModel : NSObject

@property (nonatomic,copy) NSString *id_num;

@property (nonatomic,copy) NSString *hot;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *parent_id;

@property (nonatomic,copy) NSString *pinyin;

@property (nonatomic,copy) NSString *short_name;

@property (nonatomic,copy) NSString *title;

@end
