//
//  MobileModifyCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileModifyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
- (IBAction)sendBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendBtnWidthConstraint;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end
