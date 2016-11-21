//
//  OrderThirdTableCell.m
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "OrderThirdTableCell.h"

#define hSpacingNum 23.0

@implementation OrderThirdTableCell

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
    UILabel * firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, hSpacingNum, 36, 15)];
    firstLabel.text = @"优惠:";
    firstLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    firstLabel.font = [UIFont systemFontOfSize:15.0];
//    firstLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:firstLabel];
    
    UIButton * secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secondBtn.frame = CGRectMake(26+36,hSpacingNum, 42, 15);
//    secondBtn.backgroundColor = [UIColor orangeColor];
    [secondBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形-2-副本"] forState:UIControlStateNormal];
    [secondBtn setTitle:@"代金券" forState:UIControlStateNormal];
    [secondBtn setTitleColor:[UIColor colorWithHexString:@"#fe5e5b"] forState:UIControlStateNormal];
    secondBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:secondBtn];
    
    
    _thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(26+36+42+6, hSpacingNum, 130, 15)];
    _thirdLabel.text = @"200元学车代金券";
    _thirdLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _thirdLabel.font = [UIFont systemFontOfSize:15.0];
    //    thirdLabel.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:_thirdLabel];
    
    UIImageView * fourthImageV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-50-8, hSpacingNum+3, 12, 8)];
    fourthImageV.image = [UIImage imageNamed:@"iconfont-jiantou(1)"];
    //    fifthImageV.backgroundColor = [UIColor purpleColor];
    [self.contentView addSubview:fourthImageV];
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
