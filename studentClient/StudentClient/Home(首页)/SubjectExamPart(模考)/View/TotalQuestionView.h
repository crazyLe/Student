//
//  TotalQuestionView.h
//  学员端
//
//  Created by zuweizhong  on 16/7/16.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TotalQuestionView;
@protocol TotalQuestionViewDelegate <NSObject>

-(void)totalQuestionView:(TotalQuestionView *)totalView didSelectIndex:(int)index;

@end


@interface TotalQuestionView : UIView

@property(nonatomic,strong)NSMutableArray * totalQuestionArr;

@property(nonatomic,strong)UILabel * correntLabel;

@property(nonatomic,strong)UILabel * incorrentLabel;

@property(nonatomic,strong)UIButton * dismissButton;

@property(nonatomic,strong)UIScrollView * scrollView;

@property(nonatomic,copy) void(^dismissBlock)(void);

@property(nonatomic,strong)NSMutableArray *incorrectIndexArray;

@property(nonatomic,strong)NSMutableArray *correctIndexArray;

@property(nonatomic,weak)id<TotalQuestionViewDelegate> delegate;

/**
 *  显示
 */
-(void)show;
/**
 *  消失
 */
-(void)dismiss;

@end
