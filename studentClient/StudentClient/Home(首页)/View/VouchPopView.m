//
//  VouchPopView.m
//  学员端
//
//  Created by zuweizhong  on 16/7/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "VouchPopView.h"

@implementation VouchPopView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.topConstraint.constant = 130*AutoSizeScaleX;
    self.middleConstraint.constant = 20*AutoSizeScaleX;
    self.bottomConstraint.constant = 55*AutoSizeScaleX;

    self.backgroundColor = [UIColor clearColor];
    
    self.moneyLabel.attributedText = [self getAttrTextWithMoney:@"200"];


}
-(NSMutableAttributedString *)getAttrTextWithMoney:(NSString *)money
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"￥"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"fe513e"] range:NSMakeRange(0, str.length)];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-BoldOblique" size:35] range:NSMakeRange(0, str.length)];

    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:money];
    
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"fe513e"] range:NSMakeRange(0, str2.length)];
    
    [str2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-BoldOblique" size:60] range:NSMakeRange(0, str2.length)];
    
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc]initWithString:@"代金券"];

    [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"fe513e"] range:NSMakeRange(0, str3.length)];
    
    [str3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, str3.length)];
    [str appendAttributedString:str2];
    [str appendAttributedString:str3];

    return str;


}
- (IBAction)knowBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(vouchPopViewDidClickKnowBtn:)]) {
        [self.delegate vouchPopViewDidClickKnowBtn:self];
    }
}
- (void)setVouchers:(VouchersListModel *)vouchers {
    
    _vouchers = vouchers;
    self.moneyLabel.attributedText = [self getAttrTextWithMoney:[NSString stringWithFormat:@"%d",vouchers.money]];
    _driverSchoolLabel.text = vouchers.title;
    NSString * dateString = [Utilities calculateTimeWithDay:[NSString stringWithFormat:@"%d",vouchers.endTime]];
    _timeLabel.text = [NSString stringWithFormat:@"有效期至:%@",dateString];
    
}
@end
