//
//  LLPackupOrOpenCell.h
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "LLButton.h"
#import <UIKit/UIKit.h>

@class LLPackupOrOpenCell;

@protocol LLPackupOrOpenCellDelegate <NSObject>

- (void)LLPackupOrOpenCell:(LLPackupOrOpenCell *)cell clickBtn:(LLButton *)btn;

@end

@interface LLPackupOrOpenCell : SuperTableViewCell

@property (nonatomic,strong) LLButton *packOrOpenBtn;

@property (nonatomic,assign) id delegate;

@end
