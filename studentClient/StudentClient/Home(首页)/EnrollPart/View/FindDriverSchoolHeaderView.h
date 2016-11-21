//
//  FindDriverSchoolHeaderView.h
//  学员端
//
//  Created by gaobin on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    HeaderViewBtnRecommendBtn = 0,
    HeaderViewBtnMinDistanceBtn,
    HeaderViewBtnClassifyBtn,
    
    
}HeaderViewBtnType;
@protocol HeaderViewBtnDelegate  <NSObject>

- (void)headerViewDidClickBtnWithBtnType:(HeaderViewBtnType)btnType lastBtn:(UIButton *)lastBtn;

@end




@interface FindDriverSchoolHeaderView : UICollectionReusableView

@property (nonatomic, strong) UIButton * recommendBtn;
@property (nonatomic, strong) UIButton * minDistanceBtn;
@property (nonatomic, strong) UIButton * classifyBtn;
@property (nonatomic, strong) UIButton * lastBtn;
@property (nonatomic, weak) id<HeaderViewBtnDelegate>delegate;


@end
