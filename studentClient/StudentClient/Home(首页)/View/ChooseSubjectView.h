//
//  ChooseSubjectView.h
//  学员端
//
//  Created by gaobin on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    SubjectOneBtn,
    SubjectTwoBtn,
    SubjectThreeBtn,
    
    
}SubjectBtnType;
@protocol SubjectBtnDelegate <NSObject>

- (void)btnClickWithBtnType:(SubjectBtnType)btnType;


@end

@interface ChooseSubjectView : UIView


@property (nonatomic, weak) id<SubjectBtnDelegate> delegate;


@end
