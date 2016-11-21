//
//  OrderSecondTableCell.m
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "OrderSecondTableCell.h"

static NSInteger spacingNum = 0;
static NSInteger hSpacingNum = 0;
@implementation OrderSecondTableCell

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
    spacingNum = 5*kScreenWidth/375.0;
    hSpacingNum = 23.0;
    
    UILabel * firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, hSpacingNum, 36, 15)];
    firstLabel.text = @"优惠:";
    firstLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    firstLabel.font = [UIFont systemFontOfSize:15.0];
    //    firstLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:firstLabel];
    
    _secondLabel = [[UILabel alloc]initWithFrame:CGRectMake((26+36), hSpacingNum, kScreenWidth-50-8-36-26, 15)];
    _secondLabel.text = @"普通班 周一至周日 白天 ¥3500";
    _secondLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    _secondLabel.font = [UIFont systemFontOfSize:14.0];
    //    firstLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_secondLabel];
    
    UIImageView * fifthImageV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-50-8, hSpacingNum+3, 12, 8)];
    fifthImageV.image = [UIImage imageNamed:@"iconfont-jiantou(1)"];
//    fifthImageV.backgroundColor = [UIColor purpleColor];
    [self.contentView addSubview:fifthImageV];
    
    
    
    
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
