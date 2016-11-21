//
//  ArticlesModel.h
//  学员端
//
//  Created by gaobin on 16/8/4.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticlesModel : NSObject

//@property (nonatomic, assign) int idNum;//题目分类id
@property (nonatomic, copy) NSString * imgUrl;//文章图片地址
@property (nonatomic, copy) NSString * pageUrl;//文章Wap页面地址
@property (nonatomic, copy) NSString * title;//题目分类名称
@property (nonatomic, assign) long createTime;
@property (nonatomic, assign) int readCount;

@end
