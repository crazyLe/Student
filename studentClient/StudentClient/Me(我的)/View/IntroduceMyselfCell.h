//
//  IntroduceMyselfCell.h
//  学员端
//
//  Created by gaobin on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalInfoModel.h"

@interface IntroduceMyselfCell : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *limitInputLab;

@property (nonatomic, strong) PersonalInfoModel * personalInfo ;

@end
