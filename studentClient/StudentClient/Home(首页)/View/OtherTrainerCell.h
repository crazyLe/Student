//
//  OtherTrainerCell.h
//  学员端
//
//  Created by gaobin on 16/7/15.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherTrainerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *authenticationImgView;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;

@property (weak, nonatomic) IBOutlet UILabel *carTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *appointTimeLab;
@property (weak, nonatomic) IBOutlet UIImageView *locationImgView;
@property (weak, nonatomic) IBOutlet UILabel *locationLab;
@property (weak, nonatomic) IBOutlet UIImageView *distanceImgView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLab;


- (void)getCellHeightWithLab:(NSString *)string;

@end
