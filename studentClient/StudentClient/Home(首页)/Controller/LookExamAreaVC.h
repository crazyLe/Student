//
//  LookExamAreaVC.h
//  学员端
//
//  Created by gaobin on 16/8/8.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "SubjectVideoModel.h"
@interface LookExamAreaVC : BaseViewController

@end


@interface LookExamModel : NSObject


@property(nonatomic,strong)NSString *type_name;

@property(nonatomic,assign)int id;

@property(nonatomic,strong)NSArray<SubjectVideoModel *> *item;

@end