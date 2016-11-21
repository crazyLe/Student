//
//  OrderItemView.h
//  学员端
//
//  Created by zuweizhong  on 16/7/15.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeachModel.h"
@interface OrderItemView : UIControl
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property(nonatomic,strong)TeachModel * teachModel;

@end
