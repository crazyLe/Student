//
//  LLProgressView.h
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLProgressView : UIView

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UILabel *progressLbl;

@property (nonatomic,strong) UIView *progressBgView,*progressFrontView;

@property (nonatomic,assign) CGFloat progress;

@end
