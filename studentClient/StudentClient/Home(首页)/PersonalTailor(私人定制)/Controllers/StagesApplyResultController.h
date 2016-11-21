//
//  StagesApplyResultController.h
//  学员端
//
//  Created by zuweizhong  on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"



@interface StagesApplyResultController : BaseViewController

/**
 *  学车分期状态(1成功，2失败，0正在申请中)
 */
@property(nonatomic,strong)NSString * stagesApplyStatus;


@end
