//
//  FindDriverSchoolHeaderView.m
//  学员端
//
//  Created by gaobin on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "FindDriverSchoolHeaderView.h"

@implementation FindDriverSchoolHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithFrame:(CGRect)frame {
    
    self= [super initWithFrame:frame];
    if (self) {
        
        _recommendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lastBtn = _recommendBtn;
        _recommendBtn.selected = YES;
        [_recommendBtn setBackgroundImage:[UIImage imageNamed:@"icoonfont-jiaxiao-selected-wight"] forState:UIControlStateNormal];
        [_recommendBtn setBackgroundImage:[UIImage imageNamed:@"icoonfont-jiaxiao-selected-blue"] forState:UIControlStateSelected];
        _recommendBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
        [_recommendBtn setTitle:@"推荐" forState:UIControlStateNormal];
        [_recommendBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [_recommendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _recommendBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_recommendBtn];
        
        _minDistanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minDistanceBtn setBackgroundImage:[UIImage imageNamed:@"icoonfont-jiaxiao-selected-blue"] forState:UIControlStateSelected];
        [_minDistanceBtn setBackgroundImage:[UIImage imageNamed:@"icoonfont-jiaxiao-selected-wight"] forState:UIControlStateNormal];
        _minDistanceBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
        [_minDistanceBtn setTitle:@"距我最近" forState:UIControlStateNormal];
        [_minDistanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_minDistanceBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _minDistanceBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_minDistanceBtn];
        
        _classifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_classifyBtn setBackgroundImage:[UIImage imageNamed:@"icoonfont-jiaxiao-selected-wight"] forState:UIControlStateNormal];
        [_classifyBtn setImage:[UIImage resizedImageWithName:@"iconfont-jiantou33"] forState:UIControlStateNormal];
        _classifyBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, -40, 0, 0);
        _classifyBtn.imageEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, -50);
        [_classifyBtn setTitle:@"C1" forState:UIControlStateNormal];
        [_classifyBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        _classifyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_classifyBtn];
        
        [_recommendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(85);
            make.height.offset(30);
            make.top.offset(12);
        }];
        [_minDistanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(85);
            make.height.offset(30);
            make.centerY.equalTo(_recommendBtn);
            make.centerX.equalTo(self);
            make.left.equalTo(_recommendBtn.mas_right).offset(15);
        }];
        [_classifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(85);
            make.height.offset(30);
            make.centerY.equalTo(_recommendBtn);
            make.left.equalTo(_minDistanceBtn.mas_right).offset(15);
            
        }];
        [self.recommendBtn addTarget:self action:@selector(recommendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.minDistanceBtn addTarget:self action:@selector(minDistanceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.classifyBtn addTarget:self action:@selector(classifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        
    }
    
    return self;
    
    
}

#pragma mark -- 点击推荐按钮
- (void)recommendBtnClick:(UIButton *)recommendBtn {
    
    if (_lastBtn != recommendBtn) {
        
        recommendBtn.selected = YES;
        
        _lastBtn.selected = NO;
        
        _lastBtn = recommendBtn;
        
        _lastBtn.tag = 1000;
    }
    
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickBtnWithBtnType:lastBtn:)]) {
        
        [self.delegate headerViewDidClickBtnWithBtnType:HeaderViewBtnRecommendBtn lastBtn:_lastBtn];
        
    }
    
}
#pragma mark -- 点击距我最近按钮
- (void)minDistanceBtnClick:(UIButton *)minDistanceBtn {
    
    if (_lastBtn != minDistanceBtn) {
        
        minDistanceBtn.selected = YES;
        
        _lastBtn.selected = NO;
        
        _lastBtn = minDistanceBtn;
        
        _lastBtn.tag = 2000;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickBtnWithBtnType:lastBtn:)]) {
        
        [self.delegate headerViewDidClickBtnWithBtnType:HeaderViewBtnMinDistanceBtn lastBtn:_lastBtn];
        
    }
    
    
}
#pragma mark -- 点击C1按钮
- (void)classifyBtnClick:(UIButton *)classifyBtn {
    
    
    [classifyBtn setBackgroundImage:[UIImage imageNamed:@"icoonfont-jiaxiao-selected-blue"] forState:UIControlStateNormal];
    [classifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickBtnWithBtnType:lastBtn:)]) {
        
        [self.delegate headerViewDidClickBtnWithBtnType:HeaderViewBtnClassifyBtn lastBtn:_lastBtn];
        
    }
}

@end
