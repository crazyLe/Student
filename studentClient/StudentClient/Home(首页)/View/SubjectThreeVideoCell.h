//
//  SubjectThreeVideoCell.h
//  学员端
//
//  Created by gaobin on 16/7/13.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectVideoItem.h"
#import "SubjectVideoModel.h"
@class SubjectThreeVideoCell;
@protocol SubjectThreeVideoCellDelegate <NSObject>

-(void)subjectThreeVideoCell:(SubjectThreeVideoCell *)cell didClickItemViewWithItemModel:(SubjectVideoModel*)model;

@end

@interface SubjectThreeVideoCell : UITableViewCell<SubjectVideoItemDelegate>

@property(nonatomic,strong)NSMutableArray * videoModelArray;

-(void)configCellUIWithVideoModelArray:(NSMutableArray *)videoModelArray;

@property (nonatomic, assign) CGFloat cellHeight;

+(CGFloat)getCellHeightWithData:(NSMutableArray *)data;

@property(nonatomic,weak)id<SubjectThreeVideoCellDelegate> delegate;


@end
