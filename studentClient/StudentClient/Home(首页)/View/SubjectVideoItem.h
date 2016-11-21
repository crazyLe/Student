//
//  SubjectTwoVideoItem.h
//  学员端
//
//  Created by zuweizhong  on 16/7/13.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectVideoModel.h"
@class SubjectVideoItem;
@protocol  SubjectVideoItemDelegate<NSObject>

-(void)subjectVideoItem:(SubjectVideoItem *)itemView  didClickContentBtnWithModel:(SubjectVideoModel *)model;

@end

@interface SubjectVideoItem : UIView

@property(nonatomic,strong)UIButton * contentButton;

@property(nonatomic,strong)UILabel * mainTitleLabel;

@property(nonatomic,strong)UILabel * timeLabel;

@property(nonatomic,strong)SubjectVideoModel *itemModel;

@property(nonatomic,strong)UIImageView * timeImageView;

@property(nonatomic,weak)id<SubjectVideoItemDelegate> delegate;


@end
