//
//  PersonFifthTableCell.m
//  学员端
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PersonFifthTableCell.h"

#define hSpacingNum 10.0
@implementation PersonFifthTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return  self;
}

- (void)createUI
{
    _firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(64, hSpacingNum, 125, 15)];
    NSMutableAttributedString * attStr = nil;
    attStr = [[NSMutableAttributedString alloc]initWithString:@"首付:  " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"免首付" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    _firstLabel.attributedText = attStr;
    _firstLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:_firstLabel];
    
    //分割线1
    self.line1 = [[UILabel alloc]init];
    self.line1.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    [self.contentView addSubview:_line1];

    
    UIImageView * firstImageV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-50-8, hSpacingNum+3, 12, 8)];
    firstImageV.image = [UIImage imageNamed:@"iconfont-jiantou(1)"];
    [self.contentView addSubview:firstImageV];
    
    _secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(26+36, hSpacingNum+CGRectGetMaxY(_firstLabel.frame)+10, 125, 15)];
    _secondLabel.text = @"1000";
    _secondLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _secondLabel.font = [UIFont systemFontOfSize:15.0];
    NSMutableAttributedString * secondStr = nil;
    secondStr = [[NSMutableAttributedString alloc]initWithString:@"时间:  " attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [secondStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"3个月" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    _secondLabel.attributedText = secondStr;
    _secondLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:_secondLabel];
    
    //分割线2
    self.line2 = [[UILabel alloc]init];
    self.line2.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    [self.contentView addSubview:_line2];
    
    UIImageView * secondImageV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-50-8, hSpacingNum+3+CGRectGetMaxY(_firstLabel.frame)+10, 12, 8)];
    secondImageV.image = [UIImage imageNamed:@"iconfont-jiantou(1)"];
    [self.contentView addSubview:secondImageV];
    
    _thirdLabel= [[UILabel alloc]initWithFrame:CGRectMake(62, hSpacingNum+CGRectGetMaxY(_secondLabel.frame)+10, kScreenWidth-80-15*2, 57)];
    NSMutableAttributedString * thirdStr = nil;
    thirdStr = [[NSMutableAttributedString alloc]initWithString:@"首付还款：首付0.00元+月供136.00元 = 136.00元\n每月还款：" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    [thirdStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"136.00" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#55afff"],NSFontAttributeName:[UIFont systemFontOfSize:13]}]];
    [thirdStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"元" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont systemFontOfSize:13]}]];
    _thirdLabel.attributedText = thirdStr;
    _thirdLabel.numberOfLines = 0;
    [self.contentView addSubview:_thirdLabel];
    
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.line1.frame = CGRectMake(CGRectGetMinX(_firstLabel.frame), CGRectGetMaxY(_firstLabel.frame)+8, self.width-CGRectGetMinX(_firstLabel.frame)-20, LINE_HEIGHT);

    
    self.line2.frame = CGRectMake(CGRectGetMinX(_secondLabel.frame), CGRectGetMaxY(_secondLabel.frame)+8, self.width-CGRectGetMinX(_secondLabel.frame)-20, LINE_HEIGHT);



}

@end
