//
//  LLBannerCell.h
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLButton.h"
#import <UIKit/UIKit.h>

@interface LLBannerCell : SuperTableViewCell

@property (nonatomic,strong)UIImageView *flagImgView;

@property (nonatomic,strong)UILabel *titleLbl;

@property (nonatomic,strong)LLButton *rightBtn;

@property (nonatomic,strong)UIImageView *bannerBtn;

@end
