//
//  SubjectTwoPhotoCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/13.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SubjectVideoItem.h"
@class SubjectTwoPhotoCell;
@protocol SubjectTwoPhotoCellDelegate <NSObject>

-(void)subjectTwoPhotoCell:(SubjectTwoPhotoCell *)cell didClickItemViewWithItemModel:(SubjectVideoModel*)itemModel;

@end

@interface SubjectTwoPhotoCell : UITableViewCell<SubjectVideoItemDelegate>

@property(nonatomic,strong)NSMutableArray * photoModelArray;

-(void)configCellUIWithPhotoModelArray:(NSMutableArray *)photoModelArray;

@property(nonatomic,strong)UILabel *lineLabel ;

@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,weak)id<SubjectTwoPhotoCellDelegate> delegate;


+(CGFloat)getCellHeightWithData:(NSMutableArray *)data;

@end
