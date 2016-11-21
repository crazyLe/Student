//
//  HeaderReusableView.h
//  学员端
//
//  Created by gaobin on 16/7/18.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHPickView.h"

typedef enum {

    HeaderButtonTypeFrom = 0,
    
    HeaderButtonTypeTo,
    
    HeaderButtonTypeCarType


}HeaderViewButtonType;

@class HeaderReusableView;

@protocol HeaderReusableViewDelegate <NSObject>

-(void)headerReusableView:(HeaderReusableView *)headerView didClickBtnWithType:(HeaderViewButtonType)type;

@end

@interface HeaderReusableView : UICollectionReusableView
@property (nonatomic, strong) UIButton * fromTimeBtn;
@property (nonatomic, strong) UIButton * toTimeBtn;
@property(nonatomic,strong)UIButton * carTypeBtn;
@property(nonatomic,weak)id<HeaderReusableViewDelegate> delegate;

@end
