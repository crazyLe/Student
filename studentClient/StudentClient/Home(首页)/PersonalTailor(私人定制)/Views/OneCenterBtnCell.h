//
//  OneCenterBtnCell.h
//  Coach
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 sskz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OneCenterBtnCell;

@protocol OneCenterBtnCellDelegate <NSObject>

- (void)centerBtnCell:(OneCenterBtnCell *)cell clickCenterBtn:(UIButton *)centerBtn;

@end

@interface OneCenterBtnCell : SuperTableViewCell

@property (nonatomic,strong)UIButton *centerBtn;

@property (nonatomic,assign)id delegate;

@end
