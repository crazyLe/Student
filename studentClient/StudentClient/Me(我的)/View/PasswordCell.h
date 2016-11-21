//
//  PasswordCell.h
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTMaterialSwitch.h>
@class PasswordCell;

@protocol PasswordCellDelegate <NSObject>

- (void)clickPasswordCellValueChange:(PasswordCell *)cell;

@end

@interface PasswordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet JTMaterialSwitch *pwdSwitch;

@property (nonatomic, strong) id<PasswordCellDelegate>delegate;

@end
