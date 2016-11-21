//
//  CircleMainContentCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleMainFrameModel.h"
@class CircleMainContentCell;
@protocol CircleMainContentCellDelegate <NSObject>

@optional
-(void)circleMainContentCell:(CircleMainContentCell *)cell didClickImageViewWithImageUrl:(NSString *)url index:(int)index;

-(void)circleMainContentCell:(CircleMainContentCell *)cell didClickCommentBtnWithModel:(CircleMainFrameModel *)frameModel;

-(void)circleMainContentCell:(CircleMainContentCell *)cell didClickZanBtnWithModel:(CircleMainFrameModel *)frameModel;

-(void)circleMainContentCell:(CircleMainContentCell *)cell didClickCommentZanBtnWithModel:(CircleMainFrameModel *)frameModel;

@end


@interface CircleMainContentCell : UITableViewCell

@property(nonatomic,strong)CircleMainFrameModel * circleFrameModel;

@property(nonatomic,strong)UIImageView * iconImageView;

@property(nonatomic,strong)UILabel * nameLabel;

@property(nonatomic,strong)UIImageView * vipImageView;

@property(nonatomic,strong)UIButton * topBestBtn;

@property(nonatomic,strong)YYLabel * contentLabel;

@property(nonatomic,strong)NSMutableArray * imageViewsArray;

@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UILabel * locationLabel;

@property(nonatomic,strong)UIButton * commentBtn;

@property(nonatomic,strong)UIButton * zanBtn;

@property(nonatomic,strong)UIView * lineView;

@property(nonatomic,strong)UIImageView * commentIconImageView;

@property(nonatomic,strong)UILabel * commentNameLabel;

@property(nonatomic,strong)UILabel * commentTimeLabel;

@property(nonatomic,strong)UIImageView * perfectCommentImageView;

@property(nonatomic,strong)UIButton * commentZanBtn;

@property(nonatomic,strong)YYLabel * commentContentLabel;

@property(nonatomic,strong)UIView * perfectCommentView;

@property(nonatomic,weak)id<CircleMainContentCellDelegate> delegate;

@property(nonatomic,strong)NSIndexPath *indexPath;


@end
