//
//  AutoDeleteCell.h
//  学员端
//
//  Created by gaobin on 16/7/18.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoDeleteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *colorImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UISwitch *autoDeleteSwitch;

@end
