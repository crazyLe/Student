//
//  PasswordCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/28.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PasswordCell.h"

@implementation PasswordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.pwdSwitch = [[JTMaterialSwitch alloc] initWithSize:JTMaterialSwitchSizeNormal
                                                style:JTMaterialSwitchStyleLight
                                                state:JTMaterialSwitchStateOff]
    ;
    self.pwdSwitch.thumbOnTintColor = [UIColor colorWithRed:0.36f green:0.71f blue:0.99f alpha:1.00f];
    self.pwdSwitch.trackOnTintColor = [UIColor colorWithRed:0.76f green:0.84f blue:0.89f alpha:1.00f];;
    self.pwdSwitch.thumbOffTintColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    self.pwdSwitch.trackOffTintColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
    [self.pwdSwitch addTarget:self action:@selector(pwdSwitchValueChange) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.pwdSwitch];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.pwdSwitch.frame = CGRectMake(kScreenWidth-40-8, 15, 30, 20);

}

- (void)pwdSwitchValueChange
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPasswordCellValueChange:)])
    {
        [self.delegate clickPasswordCellValueChange:self];
    }
}



@end
