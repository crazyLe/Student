//
//  CurrentRepaymentCell.m
//  学员端
//
//  Created by gaobin on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "CurrentRepaymentCell.h"

@implementation CurrentRepaymentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _currentRepayLab.font = [UIFont boldSystemFontOfSize:15];
    
    _englishLab.textColor = [UIColor colorWithHexString:@"#dddddd"];
    _studyExpensesLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _totalInterestLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _monthSupplyLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _timeLimitLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _alreadyRepayLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _repayDayLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    
    _studyExpensesLab1.textColor = [UIColor colorWithHexString:@"#666666"];
    _totalInterestLab1.textColor = [UIColor colorWithHexString:@"#666666"];
    _monthSupplyLab1.textColor = [UIColor colorWithHexString:@"#666666"];
    _timeLimitLab1.textColor = [UIColor colorWithHexString:@"#666666"];
    _alreadyRepayLab1.textColor = [UIColor colorWithHexString:@"#666666"];
    _repayDayLab1.textColor = [UIColor colorWithHexString:@"#666666"];
    
    _earnBeanLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    _offsetMoneyLab.textColor = [UIColor colorWithHexString:@"#c8c8c8"];
    
    _actrulRepayLab.textColor = [UIColor colorWithHexString:@"#808080"];
    
    _numberBeanTextView.contentInset = UIEdgeInsetsZero;
    _numberBeanTextView.textContainerInset = UIEdgeInsetsMake(5, 0, 0, 0);
    _numberBeanTextView.layer.borderWidth = 0.5f;
    _numberBeanTextView.layer.borderColor = [UIColor colorWithHexString:@"c8c8c8"].CGColor;
    _numberBeanTextView.layer.cornerRadius = 2.0f;
    _numberBeanTextView.clipsToBounds = YES;
    _numberBeanTextView.delegate = self;
    _numberBeanTextView.keyboardType = UIKeyboardTypeNumberPad;

    [_repaymentBtn setBackgroundImage:[UIImage imageNamed:@"支付圆角矩形-4"] forState:UIControlStateNormal];
    _repaymentBtn.titleEdgeInsets = UIEdgeInsetsMake(-5, 7, 0, 0);
    _repaymentBtn.imageEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    
   //画三条虚线哦
    UIView * lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = [UIColor clearColor];
    [self addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_repayDayLab.mas_bottom).offset(17);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.offset(1);
    }];
    [Utilities drawDashLineWithRect:CGRectMake(0, 0, kScreenWidth -60, 1) WithColor:[UIColor colorWithHexString:@"#e5e5e5"] parentView:lineView1];
    
    UIView * lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = [UIColor clearColor];
    [self addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_currentRepayLab.mas_bottom).offset(17);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.offset(1);
    }];
    [Utilities drawDashLineWithRect:CGRectMake(0, 0, kScreenWidth -60, 1) WithColor:[UIColor colorWithHexString:@"#e5e5e5"] parentView:lineView2];
    
    UIView * lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = [UIColor clearColor];
    [self addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_currentMonthShouldLab.mas_bottom).offset(17);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.offset(1);
    }];
    [Utilities drawDashLineWithRect:CGRectMake(0, 0, kScreenWidth -60, 1) WithColor:[UIColor colorWithHexString:@"#e5e5e5"] parentView:lineView3];
    
    
    

}

-(NSMutableAttributedString *)getAttrStringWithZhuanDouNum:(NSString *)num
{
    NSString * numStr = num == nil? @"" : num;
    NSMutableAttributedString * secondStr = [[NSMutableAttributedString alloc]initWithString:numStr attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    NSTextAttachment *attachment=[[NSTextAttachment alloc] initWithData:nil ofType:nil];
    UIImage *img=[UIImage imageNamed:@"充值iconfont-zhuandou2"];
    attachment.image=img;
    attachment.bounds=CGRectMake(10, -5, 20, 20);
    NSAttributedString *atr2 = [NSMutableAttributedString attributedStringWithAttachment:attachment];
    [secondStr appendAttributedString:atr2];
    
    return secondStr;
    
}

- (void)setBillModel:(StagingBillModel *)billModel
{
    _billModel = billModel;
    _numberBeanTextView.attributedText = [self getAttrStringWithZhuanDouNum:_billModel.remainingBeans];
    
    CGRect rect = [_numberBeanTextView.attributedText boundingRectWithSize:CGSizeMake(kScreenWidth, 29) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    self.zhuanDouWidth.constant = rect.size.width+20;
    
    NSInteger offsetMoneyStr = [_billModel.remainingBeans integerValue] * [_billModel.proportion integerValue];
    NSInteger str3 = [_billModel.thisMonthMoney integerValue]-offsetMoneyStr;
    
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:@"支付" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",(long)str3] attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#b7d8f4"],NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"元" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}]];
    [_repaymentBtn setAttributedTitle:attStr forState:UIControlStateNormal];
}
- (IBAction)clickRepaymentBtn:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressCurrentCellrepaymentBtn)]) {
        [self.delegate pressCurrentCellrepaymentBtn];
    }
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    _numberBeanTextView.attributedText = nil;
    
}
@end
