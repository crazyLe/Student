//
//  PersonalCustomizeCell.m
//  学员端
//
//  Created by gaobin on 16/7/26.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PersonalCustomizeCell.h"

@implementation PersonalCustomizeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _orderInfoTitleLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _studySecretaryLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _orderInfoDetailLab.textColor = [UIColor colorWithHexString:@"#333333"];
//    _orderInfoDetailLab.text = @"私人订制学车秘书普通版";
    _nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _phoneLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#ececec"];
    _timeLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _priceLab.font = [UIFont boldSystemFontOfSize:15];
    _priceLab.textColor = [UIColor colorWithHexString:@"#7b91a3"];
    
    
    
    
    
    
}
-(void)layoutSubviews {
    
    [_isRepayImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(autoScaleW(80));
        make.height.offset(autoScaleH(45));
        
    }];
    
    
}
- (void)deleteBtnClick {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPersonalCustomizeCellDeleteBtn:)])
    {
        [self.delegate clickPersonalCustomizeCellDeleteBtn:_index];
    }
    
}

- (void)setOrderModel:(MyOrderModel *)orderModel
{
    _orderModel = orderModel;

    _orderNumberLab.text = [NSString stringWithFormat:@"订单编号:%@",orderModel.idStr];
    if ([orderModel.allow_del isEqualToString:@"1"]) {
        _deleteBtn.hidden = NO;
    }
    else
    {
        _deleteBtn.hidden = YES;
    }
    
    _phoneLab.hidden = YES;
    
    if ([self.orderModel.orderType isEqualToString:@"1"]) {
        self.orderTypeLabel.text = @"全款";

    }else
    {
        self.orderTypeLabel.text = @"分期";
    }
    
    _priceLab.text = [NSString stringWithFormat:@"￥%@",self.orderModel.money];
    _orderInfoDetailLab.text = orderModel.info;
    _nameLab.text = [orderModel.productInfo lastObject];
    
    if ([orderModel.state isEqualToString:@"0"]) {
        _isRepayImgView.image = [UIImage imageNamed:@"未付款"];
    }
    else if ([orderModel.state isEqualToString:@"1"]) {
        _isRepayImgView.image = [UIImage imageNamed:@"已付款"];
    }
    else if ([orderModel.state isEqualToString:@"2"]) {
        _isRepayImgView.image = [UIImage imageNamed:@"分期中"];
    }
    else if ([orderModel.state isEqualToString:@"3"]) {
        _isRepayImgView.image = [UIImage imageNamed:@"已报道"];
    }
    else if ([orderModel.state isEqualToString:@"4"]) {
        _isRepayImgView.image = [UIImage imageNamed:@"未付款"];
    }
    else if ([orderModel.state isEqualToString:@"5"]) {
        _isRepayImgView.image = [UIImage imageNamed:@"审核中"];
    }
    else if ([orderModel.state isEqualToString:@"6"]) {
        _isRepayImgView.image = [UIImage imageNamed:@"审核失败"];
    }
    else if ([orderModel.state isEqualToString:@"-1"]) {
        _isRepayImgView.image = [UIImage imageNamed:@"已取消"];
    }
    else if ([orderModel.state isEqualToString:@"-2"]) {
        _isRepayImgView.image = [UIImage imageNamed:@"支付失败"];
    }
    else if ([orderModel.state isEqualToString:@"-3"]) {
        _isRepayImgView.image = [UIImage imageNamed:@"退款"];
    }
    else
    {
        _isRepayImgView.image = [UIImage imageNamed:@"未付款"];
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:[_orderModel.createTime doubleValue]]];
    
    _timeLab.text = dateString;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
