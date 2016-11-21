//
//  VideoCell.h
//  学员端
//
//  Created by gaobin on 16/7/12.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCell : UITableViewCell

@property (nonatomic, strong) UIImageView * leftImgView;
@property (nonatomic, strong) UIImageView * rightImgView;
@property (nonatomic, strong) UILabel * leftLab;
@property (nonatomic, strong) UILabel * rightLab;
@property (nonatomic, strong) UIImageView * leftCameraView;
@property (nonatomic, strong) UIImageView * rightCamerwView;
@property (nonatomic, strong) UILabel * leftTimeLab;
@property (nonatomic, strong) UILabel * rightTimeLab;



@end
