//
//  ExamRecordCell.h
//  学员端
//
//  Created by gaobin on 16/8/8.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rankImgView;
@property (weak, nonatomic) IBOutlet UILabel *timeRangeLab;
@property (weak, nonatomic) IBOutlet UILabel *introduceLab;
@property (weak, nonatomic) IBOutlet UILabel *timePointLab;
@property (weak, nonatomic) IBOutlet UILabel *markLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@end
