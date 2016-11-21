//
//  SubjectTwoVideoCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/13.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectVideoItem.h"
@class SubjectTwoVideoCell;
@protocol SubjectTwoVideoCellDelegate <NSObject>

-(void)subjectTwoVideoCell:(SubjectTwoVideoCell *)cell didClickItemViewWithItemModel:(SubjectVideoModel*)itemModel;

@end
@interface SubjectTwoVideoCell : UITableViewCell<SubjectVideoItemDelegate>

@property(nonatomic,strong)NSMutableArray * videoModelArray;

-(void)configCellUIWithVideoModelArray:(NSMutableArray *)videoModelArray;

@property(nonatomic,strong)UILabel *lineLabel ;

@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,weak)id<SubjectTwoVideoCellDelegate> delegate;


+(CGFloat)getCellHeightWithData:(id)data;

@end

