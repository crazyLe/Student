//
//  PartnerTrainingDetailVC.h
//  学员端
//
//  Created by zuweizhong  on 16/7/14.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "TeachingTimesModel.h"
@interface PartnerTrainingDetailVC : BaseViewController

@property(nonatomic,strong)NSString * subjectNum;

@property(nonatomic,strong)TeachingTimesModel * teachModel;

@end


@interface SelectOrderModel : NSObject

@property(nonatomic,strong)NSDate * date;

@property(nonatomic,strong)NSMutableArray * teachModelArray;



@end