//
//  OrderFourthTableCell.m
//  学员端
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "OrderFourthTableCell.h"

@interface  OrderFourthTableCell()<UITextFieldDelegate>

@end

#define hSpacingNum 17.0
@implementation OrderFourthTableCell

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
    UILabel * firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, hSpacingNum, 40, 15)];
    firstLabel.text = @"赚豆:";
    firstLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    firstLabel.font = [UIFont systemFontOfSize:15.0];
    //    firstLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:firstLabel];
    
    
//    UILabel * secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(26+36, hSpacingNum, 122, 15)];
//    secondLabel.text = @"1000";
//    secondLabel.textColor = [UIColor colorWithHexString:@"#666666"];
//    secondLabel.font = [UIFont systemFontOfSize:15.0];
////    secondLabel.backgroundColor = [UIColor orangeColor];
//    [self.contentView addSubview:secondLabel];
    
    _secondField = [[UITextField alloc]initWithFrame:CGRectMake(26+36, hSpacingNum-9, 122, 34)];
    _secondField.text = @"10000";
    _secondField.textColor = [UIColor colorWithHexString:@"666666"];
    _secondField.font = [UIFont systemFontOfSize:15.0];
    _secondField.delegate = self;
    _secondField.keyboardType = UIKeyboardTypeNumberPad;
    _secondField.borderStyle=UITextBorderStyleRoundedRect;
    [self.contentView addSubview:_secondField];

    UILabel * thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(26+36+122+5, hSpacingNum, 60, 14)];
    thirdLabel.text = @"抵1000元";
    thirdLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    thirdLabel.font = [UIFont systemFontOfSize:13.0];
//    thirdLabel.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:thirdLabel];
    
    UILabel * fourthLabel = [[UILabel alloc]initWithFrame:CGRectMake(26+36, CGRectGetMaxY(_secondField.frame)+8, 230, 15)];
    fourthLabel.text = @"共1000赚豆，最多可抵1000元";
    fourthLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    fourthLabel.font = [UIFont systemFontOfSize:15.0];
//    fourthLabel.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:fourthLabel];
    
//    NSArray * payArr = @[@"全额付款",@"分期支付"];
////    NSArray * payColorArr  = @[rgb(71, 178, 254),[UIColor whiteColor]];
//    NSArray * payTextColorArr = @[[UIColor whiteColor],[UIColor colorWithHexString:@"999999"]];
//    NSArray * payImageArr = @[@"1111",@"22222"];
//    for (int i=0; i<2; i++) {
//        UIButton * payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        payBtn.frame = CGRectMake(26+36+102*i, CGRectGetMaxY(fourthLabel.frame)+18, 102, 31);
//        [payBtn setTitle:payArr[i] forState:UIControlStateNormal];
//        [payBtn setTitleColor:payTextColorArr[i] forState:UIControlStateNormal];
//        [payBtn setBackgroundImage:[UIImage imageNamed:payImageArr[i]] forState:UIControlStateNormal];
//        if (i==1) {
//            payBtn.layer.borderWidth = 1;
//            payBtn.layer.borderColor = rgb(226, 225, 226).CGColor;
//        }
//        
////        payBtn.backgroundColor = payColorArr[i];
//        payBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
//        [self.contentView addSubview:payBtn];
//    }
    _payFirstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payFirstBtn.frame = CGRectMake(26+36, CGRectGetMaxY(fourthLabel.frame)+18, 102, 31);
    [_payFirstBtn setTitle:@"全额付款" forState:UIControlStateNormal];
    [_payFirstBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_payFirstBtn setBackgroundImage:[UIImage imageNamed:@"1111"] forState:UIControlStateNormal];
    _payFirstBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    _payFirstBtn.tag = 100;
    [_payFirstBtn addTarget:self action:@selector(pressPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_payFirstBtn];
    
    _paySecondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _paySecondBtn.frame = CGRectMake(26+36+102, CGRectGetMaxY(fourthLabel.frame)+18, 102, 31);
    [_paySecondBtn setTitle:@"分期付款" forState:UIControlStateNormal];
    [_paySecondBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [_paySecondBtn setBackgroundImage:[UIImage imageNamed:@"2222"] forState:UIControlStateNormal];
    _paySecondBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    _paySecondBtn.tag = 200;
    [_paySecondBtn addTarget:self action:@selector(pressPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_paySecondBtn];
    
}


//btn点击响应事件
- (void)pressPayBtn:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
            [_payFirstBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_payFirstBtn setBackgroundImage:[UIImage imageNamed:@"1111"] forState:UIControlStateNormal];
            [_paySecondBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            [_paySecondBtn setBackgroundImage:[UIImage imageNamed:@"3333"] forState:UIControlStateNormal];
            break;
        case 200:
            [_payFirstBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            [_payFirstBtn setBackgroundImage:[UIImage imageNamed:@"3333"] forState:UIControlStateNormal];
            [_paySecondBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_paySecondBtn setBackgroundImage:[UIImage imageNamed:@"4444"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickPersonFourthCellPayBtn:)]) {
        [self.delegate clickPersonFourthCellPayBtn:sender.tag];
    }
}

- (void)secondFieldInput:(UITextField *)field
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(personFourthCellsecondField)]) {
        [self.delegate personFourthCellsecondField];
    }
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
