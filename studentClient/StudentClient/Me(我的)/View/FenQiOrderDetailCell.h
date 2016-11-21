//
//  FenQiOrderDetailCell.h
//  学员端
//
//  Created by zuweizhong  on 16/8/24.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FenQiOrderDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *repayTypeTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *repayTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderMoneyTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *orderMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *orderStateTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLab;



@property (weak, nonatomic) IBOutlet UILabel *fenqiShouFuLabel;
@property (weak, nonatomic) IBOutlet UILabel *fenqiQiShuLabel;
@property (weak, nonatomic) IBOutlet UILabel *liXiLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentMoneyLabel;


@property (weak, nonatomic) IBOutlet UILabel *fenqiShouFuDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *fenqiQiShuDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *liXiDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentMoneyDetailLabel;

@end
