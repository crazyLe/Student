//
//  TuCaoCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionCommentModel.h"

@class TuCaoCell;

@protocol TuCaoCellDelegate <NSObject>

-(void)tuCaoCell:(TuCaoCell *)cell didClickZanBtnWithModel:(QuestionCommentModel *)model;

@end

@interface TuCaoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shengPinLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UILabel *zanCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property(nonatomic,strong)QuestionCommentModel * commentModel;
- (IBAction)tucaoBtnClick:(id)sender;
@property (weak, nonatomic) id<TuCaoCellDelegate> delegate;


@end
