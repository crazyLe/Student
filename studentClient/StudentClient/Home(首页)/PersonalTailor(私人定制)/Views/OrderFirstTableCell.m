//
//  OrderFirstTableCell.m
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "OrderFirstTableCell.h"

@implementation OrderFirstTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createaUI];
    }
    return self;
}

- (void)createaUI
{
    UILabel * orderLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-90)/2-9, 12, 90, 16)];
    orderLabel.text = @"订单信息";
    orderLabel.textColor = [UIColor colorWithHexString:@"#55b0fe"];
    orderLabel.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:orderLabel];
    
    UILabel * orderNumLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-110)/2-9, CGRectGetMaxY(orderLabel.frame)+10, 110, 9)];
    orderNumLabel.font = [UIFont systemFontOfSize:13.0];
    orderNumLabel.text = @"订单编号：89757";
    orderNumLabel.textColor = [UIColor colorWithHexString:@"#c9c9c9"];
    [self.contentView addSubview:orderNumLabel];
    
    
    _coachLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, CGRectGetMaxY(orderNumLabel.frame)+30, 150, 15)];
    NSMutableAttributedString * attStr = nil;
    attStr = [[NSMutableAttributedString alloc]initWithString:@"教练:" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#c8c8c8"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"张小开" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    _coachLabel.attributedText = attStr;
    [self.contentView addSubview:_coachLabel];
    
    
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, CGRectGetMaxY(_coachLabel.frame)+16, 250, 15)];
    NSMutableAttributedString * addressStr = nil;
    addressStr = [[NSMutableAttributedString alloc]initWithString:@"地址:" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#c8c8c8"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [addressStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"XXXXXXXXXXXXXXXXXXXX" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    _addressLabel.attributedText = addressStr;
    [self.contentView addSubview:_addressLabel];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
