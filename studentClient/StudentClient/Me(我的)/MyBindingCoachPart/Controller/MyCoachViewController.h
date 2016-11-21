//
//  MyCoachViewController.h
//  学员端
//
//  Created by zuweizhong  on 16/7/29.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
@class CoachModel;
@interface MyCoachViewController : BaseViewController
@property(strong,nonatomic)CoachModel *secondCoach;
@property(strong,nonatomic)CoachModel *thredCoach;
@property(strong,nonatomic)NSArray *xueshiArr;
@end
