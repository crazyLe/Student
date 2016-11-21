//
//  FindDriverSchoolCell.h
//  学员端
//
//  Created by gaobin on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriveSchoolModel.h"

@interface FindDriverSchoolCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *discountImgView;
@property (weak, nonatomic) IBOutlet UIImageView *driverSchoolImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *supportStageLab;
@property (weak, nonatomic) IBOutlet UILabel *numberEnrollLab;
@property (weak, nonatomic) IBOutlet UIImageView *distanceImgView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLab;

@property(nonatomic,strong)DriveSchoolModel * driveSchoolModel;




@end
