//
//  PartnerTrainOrderController.h
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderInfoModel.h"
@interface PartnerTrainOrderController : BaseViewController

@property(nonatomic,strong)OrderInfoModel *orderInfoModel;

@property(nonatomic,strong)NSString * subjectNum;

@property(nonatomic,strong)NSString * jiaLing;

@end
