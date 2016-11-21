//
//  CircleMainFrameModel.h
//  学员端
//
//  Created by zuweizhong  on 16/7/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CircleMainModel.h"
@interface CircleMainFrameModel : NSObject

@property(nonatomic,assign)CGRect iconImageViewF;

@property(nonatomic,assign)CGRect nameLabelF;

@property(nonatomic,assign)CGRect vipImageViewF;

@property(nonatomic,assign)CGRect topBestImageViewF;

@property(nonatomic,assign)CGRect contentLabelF;

@property(nonatomic,strong)NSMutableArray * imageViewFrameArray;

@property(nonatomic,assign)CGRect timeLabelF;

@property(nonatomic,assign)CGRect locationLabelF;

@property(nonatomic,assign)CGRect commentBtnF;

@property(nonatomic,assign)CGRect zanBtnF;

@property(nonatomic,assign)CGRect lineViewF;

@property(nonatomic,assign)CGRect perfectCommentViewF;

@property(nonatomic,assign)CGRect commentIconImageViewF;

@property(nonatomic,assign)CGRect commentNameLabelF;

@property(nonatomic,assign)CGRect commentTimeLabelF;

@property(nonatomic,assign)CGRect perfectCommentImageViewF;

@property(nonatomic,assign)CGRect commentZanBtnF;

@property(nonatomic,assign)CGRect commentContentLabelF;

@property(nonatomic,assign)CGFloat cellHeight;

@property(nonatomic,strong)CircleMainModel * circleMainModel;


@end
