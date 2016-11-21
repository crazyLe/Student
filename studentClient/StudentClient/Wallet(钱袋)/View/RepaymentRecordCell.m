//
//  RepaymentRecordCell.m
//  学员端
//
//  Created by gaobin on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "RepaymentRecordCell.h"

@implementation RepaymentRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(STRecordModel *)model
{
    _model = model;
//    _monthLab.text = @"7";
    _monthLab.text = [NSString stringWithFormat:@"%ld",(long)[_model.month integerValue]];
//    _orderLab.text = @"私人订制学车秘书普通版";
    _orderLab.text = _model.title;
//    _shouldRepayLab.text = @"¥367.00";
    _shouldRepayLab.text = [NSString stringWithFormat:@"¥%@",_model.thisMonthMoney];
//    _havedRepayLab.text = @"6个月";
    _havedRepayLab.text = [NSString stringWithFormat:@"%@个月",_model.completeCount];
    _lineLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
//    _timeLab.text = @"2016-07-06 17:28";
    _timeLab.text = _model.payTime;
    _timeLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    
    NSLog(@"~~~%@~~",_model.isReimbursement);
    if ([_model.isReimbursement isEqualToString:@"未还"]) {
        _havedRepayImgView.image = [UIImage imageNamed:@"未付款"];
    }else if ([_model.isReimbursement isEqualToString:@"已还"]){
        _havedRepayImgView.image = [UIImage imageNamed:@"已还清"];
    }
    
    
}

@end
