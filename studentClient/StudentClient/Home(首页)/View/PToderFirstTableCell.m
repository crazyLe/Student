//
//  PToderFirstTableCell.m
//  学员端
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PToderFirstTableCell.h"

@implementation PToderFirstTableCell

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
    self.orderIdLabel = orderNumLabel;
    orderNumLabel.font = [UIFont systemFontOfSize:13.0];
    orderNumLabel.text = @"订单编号：89757";
    orderNumLabel.textColor = [UIColor colorWithHexString:@"#c9c9c9"];
    [self.contentView addSubview:orderNumLabel];
    
    
    UILabel * coachLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, CGRectGetMaxY(orderNumLabel.frame)+15, 100, 15)];
    self.coachLabel = coachLabel;
    NSMutableAttributedString * attStr = nil;
    attStr = [[NSMutableAttributedString alloc]initWithString:@"教练:" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#c8c8c8"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"张小开" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    coachLabel.attributedText = attStr;
//    coachLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:coachLabel];
    
    UIButton * coachBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(coachLabel.frame)+5, CGRectGetMinY(coachLabel.frame), 50, 15)];
    self.jiaLingBtn = coachBtn;
    [coachBtn setBackgroundImage:[UIImage imageNamed:@"驾龄"] forState:UIControlStateNormal];
    [coachBtn setTitle:@"五年驾龄" forState:UIControlStateNormal];
    [coachBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    coachBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:coachBtn];
    
//    UILabel * carsLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, CGRectGetMaxY(coachLabel.frame)+16, 150, 15)];
//    self.carLabel = carsLabel;
//    NSMutableAttributedString * carsStr = nil;
//    carsStr = [[NSMutableAttributedString alloc]initWithString:@"车辆:" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#c8c8c8"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
//    [carsStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"捷达" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
//    carsLabel.attributedText = carsStr;
//    [self.contentView addSubview:carsLabel];
    
//    UILabel * subjectsLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, CGRectGetMaxY(carsLabel.frame)+16, 150, 15)];
    UILabel * subjectsLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, CGRectGetMaxY(coachBtn.frame)+16, 150, 15)];
    self.subjectLabel = subjectsLabel;
    NSMutableAttributedString * subjectsStr = nil;
    subjectsStr = [[NSMutableAttributedString alloc]initWithString:@"科目:" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#c8c8c8"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [subjectsStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"科目二" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    subjectsLabel.attributedText = subjectsStr;
//    subjectsLabel.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:subjectsLabel];
    
    UILabel * addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, CGRectGetMaxY(subjectsLabel.frame)+16, kScreenWidth-60, 15)];
    self.addressLabel = addressLabel;
    NSMutableAttributedString * addressStr = nil;
    addressStr = [[NSMutableAttributedString alloc]initWithString:@"地址:" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#c8c8c8"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [addressStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"合肥市经开区莲花路与芙蓉路交口" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    addressLabel.attributedText = addressStr;
    addressLabel.numberOfLines = 0;
//    addressLabel.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:addressLabel];
    
    
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
