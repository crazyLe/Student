//
//  ExamQuestionTopCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/16.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamQuestionModel.h"
#import "ZFPlayerView.h"

@interface ExamQuestionTopCell : UITableViewCell

@property(nonatomic,strong)YYLabel * contentLabel;

@property(nonatomic,strong)UIImageView * contentImageView;

@property(nonatomic,strong)UIButton * multi_radioBtn;

@property(nonatomic,strong)ExamQuestionModel * questionModel;

@property(nonatomic,strong)ZFPlayerView * playerView;

@property(nonatomic, assign)CGFloat cellHeight;


@end
