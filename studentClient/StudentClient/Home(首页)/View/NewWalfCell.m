//
//  NewWalfCell.m
//  学员端
//
//  Created by zuweizhong  on 16/8/5.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "NewWalfCell.h"

@implementation NewWalfCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.weiMingPian setImage:[UIImage imageNamed:@"microCard"] forState:UIControlStateNormal];
    [self.zhuanXueFei setImage:[UIImage imageNamed:@"earnTuition"] forState:UIControlStateNormal];
    [self.daiJingQuan setImage:[UIImage imageNamed:@"cashCoupon"] forState:UIControlStateNormal];
    [self.debitAndCreditBtn setImage:[UIImage imageNamed:@"debitAndCredit"] forState:UIControlStateNormal];

    self.cellHeight = 38+18+((float)(kScreenWidth-40*4)/3)*1.3+15;
}

- (IBAction)weiMingPianClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(newWalfCell:didClickBtnWithBtnType:)]) {
        [self.delegate newWalfCell:self didClickBtnWithBtnType:NewWalfCellBtnWeiMingPian];
    }
}

- (IBAction)zhuanXueFeiClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(newWalfCell:didClickBtnWithBtnType:)]) {
        [self.delegate newWalfCell:self didClickBtnWithBtnType:NewWalfCellBtnZhuanXueFei];
    }
}

- (IBAction)daiJingQuanClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(newWalfCell:didClickBtnWithBtnType:)]) {
        [self.delegate newWalfCell:self didClickBtnWithBtnType:NewWalfCellBtnDaiJingQuan];
    }
}

- (IBAction)debitCreditClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(newWalfCell:didClickBtnWithBtnType:)]) {
        [self.delegate newWalfCell:self didClickBtnWithBtnType:NewWalfCellBtnDebitredit];
    }
}

@end
