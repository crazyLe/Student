//
//  MyPartnerTrainCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/29.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XueshiModel;
@interface MyPartnerTrainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property(strong,nonatomic)XueshiModel *xueshi;

@end
