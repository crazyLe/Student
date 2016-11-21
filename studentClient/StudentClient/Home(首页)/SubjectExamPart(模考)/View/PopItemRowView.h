//
//  PopItemRowView.h
//  学员端
//
//  Created by zuweizhong  on 16/7/19.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopItemRowView : UIControl
@property (weak, nonatomic) IBOutlet UIButton *titleNumBtn;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *numExamLabel;
@property(nonatomic,strong)NSMutableArray * classTypeNumArray;

@end
