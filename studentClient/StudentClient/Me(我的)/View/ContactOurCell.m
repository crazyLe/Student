//
//  ContactOurCell.m
//  KKXC_Franchisee
//
//  Created by gaobin on 16/8/19.
//  Copyright © 2016年 cqingw. All rights reserved.
//

#import "ContactOurCell.h"

@implementation ContactOurCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _customerServiceLab.layer.borderWidth = 1;
    _customerServiceLab.layer.borderColor = [UIColor colorWithHexString:@"5bb7ff"].CGColor;
    _customerServiceLab.layer.cornerRadius = 5;
    _customerServiceLab.clipsToBounds = YES;

    _customerPhoneLab.userInteractionEnabled = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_customerPhoneLab addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)tapAction {
    if (self.phoneClickedHandle) {
        self.phoneClickedHandle(self.customerPhoneLab.text);
    }
}

@end
