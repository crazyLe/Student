//
//  ItemPoolCell.h
//  学员端
//
//  Created by gaobin on 16/7/12.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {

    ItemPoolCellButtonOne = 0,
    
    ItemPoolCellButtonTwo,
    
    ItemPoolCellButtonThree
    


}ItemPoolCellButtonType;

@class ItemPoolCell;
@protocol ItemPoolCellDelegate <NSObject>

-(void)itemPoolCell:(ItemPoolCell *)cell didClickButtonWithType:(ItemPoolCellButtonType) type;


@end

@interface ItemPoolCell : UITableViewCell

@property(nonatomic,weak)id<ItemPoolCellDelegate> delegate;

@property (nonatomic, strong) UIButton * itemPoolBtn;
@property (nonatomic, strong) UIButton * onlineTestBtn;
@property (nonatomic, strong) UIButton * mistakeCollectionBtn;

@property (nonatomic, strong) UILabel * itemPoolLab;
@property (nonatomic, strong) UILabel * onlineTestLab;
@property (nonatomic, strong) UILabel * mistakeCollectionLab;

@property (nonatomic, assign) CGFloat  cellHeight; 
@end
