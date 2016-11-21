//
//  RepaymentRecordCell.h
//  学员端
//
//  Created by gaobin on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STRecordModel.h"

@interface RepaymentRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *monthLab;
@property (weak, nonatomic) IBOutlet UILabel *orderLab;
@property (weak, nonatomic) IBOutlet UILabel *shouldRepayLab;
@property (weak, nonatomic) IBOutlet UILabel *havedRepayLab;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *havedRepayImgView;
@property (weak, nonatomic) IBOutlet UILabel *stageOrderLab;

@property (weak, nonatomic) IBOutlet UILabel *currentRepayLab;

@property (weak, nonatomic) IBOutlet UILabel *alreadyRepayLab;
@property (weak, nonatomic) IBOutlet UIView *botomLineView;
@property (weak, nonatomic) IBOutlet UIView *topLineView;

@property (nonatomic, strong) STRecordModel * model;

@end
