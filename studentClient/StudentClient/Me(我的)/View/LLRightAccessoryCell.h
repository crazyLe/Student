//
//  LLRightAccessoryCell.h
//  学员端
//
//  Created by apple on 16/7/23.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLLeftImgLeftLblCell.h"
#import <UIKit/UIKit.h>

@interface LLRightAccessoryCell : LLLeftImgLeftLblCell

@property (nonatomic,strong) UIImageView *accessoryImgView;

@property (nonatomic,strong) UILabel *accessoryLbl;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) NSString *messageNum;

@property (nonatomic,strong) NSString *accessoryLblText;

@end
