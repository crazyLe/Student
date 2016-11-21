//
//  RechargeCell.m
//  学员端
//
//  Created by zuweizhong  on 16/7/25.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "RechargeCell.h"

@implementation RechargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.rechargeTextF.layer.borderWidth = 0.5f;
    self.rechargeTextF.layer.borderColor = [UIColor colorWithHexString:@"c8c8c8"].CGColor;
    self.rechargeTextF.layer.cornerRadius = 2.0f;
    self.rechargeTextF.clipsToBounds = YES;
    self.rechargeTextF.leftView = [[UIView alloc]init];
    self.rechargeTextF.leftViewMode = UITextFieldViewModeAlways;
    NSString *str = @"充值赚豆(1元=10赚豆)";
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attriStr setColor:[UIColor colorWithHexString:@"5bb7ff"] range:NSMakeRange(4, 9)];
    [attriStr setColor:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, 4)];
    
    self.tishiLabel.attributedText = attriStr;
    self.confirmRechargeBtn.layer.cornerRadius = 4.0f;
    self.confirmRechargeBtn.clipsToBounds = YES;
    self.moneyNumLabel.text = [self getMoneyFormatStringWithString:@"20000"];
    
    self.zhuanDouLabel.attributedText = [self getAttrStringWithZhuanDouNum:@"0"];
    
    self.moneyNumLabel.font = [UIFont boldSystemFontOfSize:42*AutoSizeFont];
    
    self.zhuanDouYuErLabel.font = kFont15;
    
    self.tishiLabel.font = kFont14;
    
    self.rechargeTextF.font = kFont14;
    
    self.zhuanDouLabel.font = kFont17;
    
    self.confirmRechargeBtn.titleLabel.font = kFont15;
    
    self.label.font = kFont14;
    self.label1.font = kFont14;
    self.label2.font = kFont14;
    self.label3.font = kFont14;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valuechange) name:UITextFieldTextDidChangeNotification object:nil];

    
}
-(NSMutableAttributedString *)getAttrStringWithZhuanDouNum:(NSString *)num
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@赚豆",num]];
    NSTextAttachment *attachment=[[NSTextAttachment alloc] initWithData:nil ofType:nil];
    UIImage *img=[UIImage imageNamed:@"充值iconfont-zhuandou2"];
    attachment.image=img;
    attachment.bounds=CGRectMake(5, -5, 20, 20);
    NSAttributedString *atr2 = [NSMutableAttributedString attributedStringWithAttachment:attachment];
    [str appendAttributedString:atr2];
    
    return str;

}

- (void)valuechange
{
    int dou = [self.rechargeTextF.text intValue];
    
    NSString *doustr = [NSString stringWithFormat:@"%d",dou*10];
    
    self.zhuanDouLabel.attributedText = [self getAttrStringWithZhuanDouNum:doustr];
    
}

- (NSString *)getMoneyFormatStringWithString:(NSString *)str
{
   return [NSString countNumAndChangeFormat:str];
}

- (IBAction)confirmRechargeBtnClick:(id)sender {
    int dou = [self.rechargeTextF.text intValue];
    self.chongzhi(dou);
}
@end
