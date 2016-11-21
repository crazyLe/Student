//
//  OrderItemView.m
//  学员端
//
//  Created by zuweizhong  on 16/7/15.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "OrderItemView.h"

@implementation OrderItemView

-(void)awakeFromNib
{

    self.layer.borderWidth = 1.0;
    
    self.layer.borderColor = [UIColor colorWithHexString:@"#b1d2ec"].CGColor;
    
    


}
-(void)setTeachModel:(TeachModel *)teachModel
{
    _teachModel = teachModel;
    
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:teachModel.startTime];
    
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:teachModel.endTime];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    
    df.dateFormat = @"HH:mm";
    
    NSString *startTime = [df stringFromDate:date1];

    NSString *endTime = [df stringFromDate:date2];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
    
    self.totalNumberLabel.text = [NSString stringWithFormat:@"一共可预约:%d名",teachModel.totalPlaces];

    self.leftNumberLabel.text = [NSString stringWithFormat:@"剩余名额:%d名",teachModel.remaining];

    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",teachModel.cost];
    
    if (teachModel.remaining == 0) {
        self.userInteractionEnabled = NO;
    }
    else
    {
        self.userInteractionEnabled = YES;
    }
    if (teachModel.isSelected) {
        self.selected = YES;
    }else
    {
        self.selected = NO;
    }

}
-(void)setSelected:(BOOL)selected
{

    if (selected) {
        
        self.timeLabel.backgroundColor = [UIColor colorWithHexString:@"#5cb6ff"];
        
        self.totalNumberLabel.textColor = [UIColor colorWithHexString:@"#5cb6ff"];
        
        self.leftNumberLabel.textColor = [UIColor colorWithHexString:@"#5cb6ff"];
        
        self.moneyLabel.textColor = [UIColor colorWithHexString:@"#5cb6ff"];
        
        self.layer.borderColor = [UIColor colorWithHexString:@"#5cb6ff"].CGColor;

        
        
        
        
    }else
    {
    
        self.timeLabel.backgroundColor = [UIColor colorWithHexString:@"#b1d2ec"];
        
        self.totalNumberLabel.textColor = [UIColor colorWithHexString:@"#a0c6e4"];
        
        self.leftNumberLabel.textColor = [UIColor colorWithHexString:@"#a0c6e4"];
        
        self.moneyLabel.textColor = [UIColor colorWithHexString:@"#a0c6e4"];

        
        self.layer.borderColor = [UIColor colorWithHexString:@"#b1d2ec"].CGColor;
    
    
    }
    [super setSelected:selected];


}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    
    if (userInteractionEnabled == NO) {
        
        self.timeLabel.backgroundColor = [UIColor colorWithHexString:@"e3e3e3"];
        
        self.totalNumberLabel.textColor = [UIColor colorWithHexString:@"#c7c7c7"];
        
        self.leftNumberLabel.textColor = [UIColor colorWithHexString:@"#c7c7c7"];
        
        self.moneyLabel.textColor = [UIColor colorWithHexString:@"#c7c7c7"];

        
        self.layer.borderColor = [UIColor colorWithHexString:@"#e3e3e3"].CGColor;

        
    }else
    {
    
        self.timeLabel.backgroundColor = [UIColor colorWithHexString:@"#b1d2ec"];
        
        self.totalNumberLabel.textColor = [UIColor colorWithHexString:@"#a0c6e4"];
        
        self.leftNumberLabel.textColor = [UIColor colorWithHexString:@"#a0c6e4"];
        self.moneyLabel.textColor = [UIColor colorWithHexString:@"#a0c6e4"];

        
        self.layer.borderColor = [UIColor colorWithHexString:@"#b1d2ec"].CGColor;

    }
    [super setUserInteractionEnabled:userInteractionEnabled];

}


@end
