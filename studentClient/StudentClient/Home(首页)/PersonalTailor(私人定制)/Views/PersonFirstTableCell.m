//
//  PersonFirstTableCell.m
//  学员端
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PersonFirstTableCell.h"

@implementation PersonFirstTableCell

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
    attStr = [[NSMutableAttributedString alloc]initWithString:@"私人订制:" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#c8c8c8"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"普通版" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    _coachLabel.attributedText = attStr;
    [self.contentView addSubview:_coachLabel];
    
    UILabel * serviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, CGRectGetMaxY(_coachLabel.frame)+16, 68, 15)];
    serviceLabel.text = @"服务内容:";
    serviceLabel.textColor = [UIColor colorWithHexString:@"c8c8c8"];
    serviceLabel.font = [UIFont systemFontOfSize:15];
//    serviceLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:serviceLabel];
    
    
    _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(26+63, CGRectGetMaxY(_coachLabel.frame)+16, 250, 64)];
    NSMutableAttributedString * addressStr = [[NSMutableAttributedString alloc]init];
    NSArray * addressArr  = @[@"1.巴拉巴拉",@"2.巴拉巴拉",@"3.巴拉巴拉"];
    for (int i=0; i<3; i++) {
        [addressStr appendAttributedString:[[NSAttributedString alloc]initWithString:addressArr[i] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
        if (i<2) {
            [addressStr  appendAttributedString:[[NSAttributedString  alloc] initWithString:@"\n\n"attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:3]}]];
        }

    }
    _addressLabel.attributedText = addressStr;
    _addressLabel.numberOfLines = 0;
//    addressLabel.backgroundColor = [UIColor cyanColor];
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
