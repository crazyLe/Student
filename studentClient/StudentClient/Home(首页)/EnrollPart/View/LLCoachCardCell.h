//
//  LLCoachCardCell.h
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FindCoachModel;

@interface LLCoachCardCell : SuperTableViewCell

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIButton *couponBtn,*stageBtn,*seniorCoachBtn,*noSmokingBtn,*nightBtn,*distanceBtn;

@property (nonatomic,strong) UILabel *priceLbl,*nameLbl,*classInfoLbl,*locationLbl;

@property (nonatomic,strong) UIImageView *locationImgView,*headBtn;

@property(strong,nonatomic)FindCoachModel *model;

- (void)setPriceLbl:(NSString *)price marketPrice:(NSString *)marketPrice;

- (void)setNameLbl:(NSString *)name img:(UIImage *)img bounds:(CGRect)bounds driving:(NSString *)driving;

@end
