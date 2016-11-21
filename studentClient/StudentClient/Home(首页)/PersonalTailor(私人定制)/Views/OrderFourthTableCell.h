//
//  OrderFourthTableCell.h
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol PersonFourthTableCellDelegete <NSObject>

@protocol OrderFourthTableCellDelegete <NSObject>

- (void)clickPersonFourthCellPayBtn:(NSInteger)markTag;
- (void)personFourthCellsecondField;

@end

@interface OrderFourthTableCell : UITableViewCell

/*
 **     此cell跟PersonFourthTableCell布局一样,可直接用PersonFourthTableCell
 */


@property (nonatomic, strong) UIButton* payFirstBtn;
@property (nonatomic, strong) UIButton * paySecondBtn;
@property (nonatomic, strong) UITextField * secondField;

@property (nonatomic,assign) id<OrderFourthTableCellDelegete>delegate;
@end
