//
//  PersonFourthTableCell.m
//  学员端
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PersonFourthTableCell.h"
#import "NSMutableAttributedString+LLExtension.h"

#define hSpacingNum 17.0

@interface  PersonFourthTableCell()<UITextViewDelegate>

@end

@implementation PersonFourthTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return  self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
}
- (void)createUI
{
    UILabel * firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(26, hSpacingNum, 40, 15)];
    firstLabel.text = @"赚豆:";
    self.firstLabel = firstLabel;
    firstLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    firstLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:firstLabel];
    
    _secondTextView = [[UITextField alloc]initWithFrame:CGRectMake(26+36, hSpacingNum-9, 122, 34)];
//    _secondTextView.contentInset = UIEdgeInsetsZero;
//    _secondTextView.textContainerInset = UIEdgeInsetsMake(7, 0, 0, 0);
    _secondTextView.layer.borderWidth = 0.5f;
    _secondTextView.layer.borderColor = [UIColor colorWithHexString:@"c8c8c8"].CGColor;
    _secondTextView.layer.cornerRadius = 2.0f;
    _secondTextView.clipsToBounds = YES;
    _secondTextView.textAlignment = NSTextAlignmentLeft;
//    _secondTextView.textAlignment = NSTextAlignmentCenter;
//    _secondTextView.delegate = self;
    _secondTextView.keyboardType = UIKeyboardTypeNumberPad;
//    _secondTextView.attributedText = [self getAttrStringWithZhuanDouNum:@"1000"];
    
    _secondTextView.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    //设置显示模式为永远显示(默认不显示)
    _secondTextView.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *paddingView = [[UIImageView alloc] initWithFrame:CGRectMake(_secondTextView.frame.size.width-20, 0, 20, 20)];
    paddingView.image = [UIImage imageNamed:@"充值iconfont-zhuandou2"];
    _secondTextView.rightViewMode = UITextFieldViewModeUnlessEditing;
    _secondTextView.rightView = paddingView;
    [self.contentView addSubview:_secondTextView];
    
    UILabel * thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(26+36+122+5, hSpacingNum, 120, 14)];
    self.thirdLabel = thirdLabel;
    thirdLabel.text = @"抵1000元";
    thirdLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    thirdLabel.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:thirdLabel];
    
    UILabel * fourthLabel = [[UILabel alloc]initWithFrame:CGRectMake(26+36, CGRectGetMaxY(_secondTextView.frame)+8, 230, 15)];
    self.fourthLabel = fourthLabel;
    fourthLabel.text = @"共1000赚豆，最多可抵1000元";
    fourthLabel.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    fourthLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:fourthLabel];
    
//    NSArray * payArr = @[@"全额付款",@"分期支付"];
//    //    NSArray * payColorArr  = @[rgb(71, 178, 254),[UIColor whiteColor]];
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
//        //        payBtn.backgroundColor = payColorArr[i];
//        payBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
//        [payBtn addTarget:self action:@selector(pressPayBtn:) forControlEvents:UIControlEventTouchUpInside];
//        payBtn.tag = 100*i+100;
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
    
    _warningLabel = [[UILabel alloc]initWithFrame:CGRectMake(26+36+102+2, CGRectGetMaxY(_paySecondBtn.frame)+1, 102-4, 15)];
    _warningLabel.text = @"金额满1000元可用";
    _warningLabel.hidden = YES;
    _warningLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    _warningLabel.font = [UIFont systemFontOfSize:11.0];
    _warningLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_warningLabel];
}

- (void)pressPayBtn:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
            [_payFirstBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_payFirstBtn setBackgroundImage:[UIImage imageNamed:@"1111"] forState:UIControlStateNormal];
            [_paySecondBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            [_paySecondBtn setBackgroundImage:[UIImage imageNamed:@"2222"] forState:UIControlStateNormal];

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

-(void)textViewDidChange:(UITextView *)textView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(personFourthCellsecondField)]) {
        [self.delegate personFourthCellsecondField];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    textView.attributedText = nil;
}

-(NSMutableAttributedString *)getAttrStringWithZhuanDouNum:(NSString *)num {
    NSMutableAttributedString * secondStr = [[NSMutableAttributedString alloc]initWithString:num attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
//    NSTextAttachment *attachment=[[NSTextAttachment alloc] initWithData:nil ofType:nil];
//    UIImage *img=[UIImage imageNamed:@"充值iconfont-zhuandou2"];
//    attachment.image=img;
//    attachment.bounds=CGRectMake(70, -5, 20, 20);
//    NSAttributedString *atr2 = [NSMutableAttributedString attributedStringWithAttachment:attachment];
//    [secondStr appendAttributedString:atr2];
    
    return secondStr;
}

@end
