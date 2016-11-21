//
//  SubjectOneDetailCell2.m
//  学员端
//
//  Created by zuweizhong  on 16/7/19.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "SubjectOneDetailCell2.h"
#import "DayBtnView.h"
#import "SubjectDetailItemView.h"
@interface SubjectOneDetailCell2 ()

@property(nonatomic,strong)NSDate * currentLeftDate;

@property(nonatomic,strong)NSDate * startDate;

@property(nonatomic,strong)NSMutableArray * itemViewArray;

@property(nonatomic,strong)UIButton * currentSelectBtn;



@end
@implementation SubjectOneDetailCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        self.itemViewArray = [NSMutableArray array];
        
        UIButton *leftScrollBtn = [[UIButton alloc]init];
        
        self.leftScrollBtn = leftScrollBtn;
        
        self.leftScrollBtn.backgroundColor = [UIColor colorWithHexString:@"#485358"];
        
        [self.leftScrollBtn setImage:[UIImage imageNamed:@"iconfont-left"] forState:UIControlStateNormal];
        
        [self.leftScrollBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:leftScrollBtn];
        
        self.dayBtnArray = [NSMutableArray array];
        
        self.currentLeftDate = [NSDate date];
        
        self.startDate = [NSDate date];
        
        for (int i = 0; i<5; i++) {
            
            DayBtnView *dayBtn = [[[NSBundle mainBundle]loadNibNamed:@"DayBtnView" owner:nil options:nil]lastObject];
            
            dayBtn.tag = 5000+i;
            
            dayBtn.topLabel.text = [self getDateStringByIndex:i];
            
            NSDate *date = [GHDateTools dateByAddingDays:self.currentLeftDate day:i];
            
            dayBtn.bottomLabel.text = [self getWeekDayWithDate:date];
            
            if (date.isToday) {
                dayBtn.bottomLabel.text = @"今天";
            }
            if ([[NSDate compareDate:date] isEqualToString:@"明天"]) {
                dayBtn.bottomLabel.text = @"明天";
            }
            
            [dayBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dayBtnClick:)]];
            
            [self.contentView addSubview:dayBtn];
            
            [self.dayBtnArray addObject:dayBtn];
            
            
            
            
        }
        
        UIButton *rightScrollBtn = [[UIButton alloc]init];
        
        self.rightSrcollBtn = rightScrollBtn;
        
        self.rightSrcollBtn.backgroundColor = [UIColor colorWithHexString:@"#485358"];
        
        [self.rightSrcollBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.rightSrcollBtn setImage:[UIImage imageNamed:@"iconfont-right"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:rightScrollBtn];
        
        NSMutableArray *selectTitleArr = [NSMutableArray arrayWithObjects:@"按时计费",@"按圈计费",@"提供考试车辆",@"提供教练员", nil];
        //添加选择方式
        
        CGFloat margin = 12;
        CGLineCap innering = 8;
        CGFloat btnW = (kScreenWidth-innering*3-margin*2)/4;
        CGFloat btnH = 30;
        for (int i = 0; i<4; i++) {
            int col = i%4;
            UIButton *selectBtn = [[UIButton alloc]init];
            [selectBtn setTitle:selectTitleArr[i] forState:UIControlStateNormal];
            [selectBtn setTitleColor:[UIColor colorWithHexString:@"c8c8c8"] forState:UIControlStateNormal];
            [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            selectBtn.layer.cornerRadius = 15;
            selectBtn.clipsToBounds = YES;
            selectBtn.layer.borderWidth = 1.0f;
            selectBtn.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
            selectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            
            [selectBtn setBackgroundColor:[UIColor whiteColor]];
            
            [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            selectBtn.frame = CGRectMake(margin +(btnW+innering)*col, 30+48, btnW, btnH);
            
            [self.contentView addSubview:selectBtn];
            
            if (i==0) {//默认点击第一个
                [self selectBtnClick:selectBtn];
            }
            
            
        }
        
        //添加ItemView
        for (int i = 0; i<4; i++) {
            
            SubjectDetailItemView *itemView = [[[NSBundle mainBundle]loadNibNamed:@"SubjectDetailItemView" owner:nil options:nil]lastObject];
            [itemView addTarget:self action:@selector(itemViewClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:itemView];
            [self.itemViewArray addObject:itemView];
            if (i == 1) {
                itemView.userInteractionEnabled = NO;
            }

        }
        
        //添加联系button
        UIButton *contactBtn = [[UIButton alloc]init];
        
        contactBtn.backgroundColor = [UIColor colorWithHexString:@"#f2f7f6"];
        
        contactBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        self.contactBtn = contactBtn;
        
        [contactBtn setTitle:@"*请联系教练员预约模考时间" forState:UIControlStateNormal];
        
        [contactBtn setTitleColor:[UIColor colorWithHexString:@"fe5e5d"] forState:UIControlStateNormal];
        
//        [contactBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.contactBtn];
        
        [self.contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            
            make.right.offset(0);
            
            make.bottom.offset(0);
            
            make.height.equalTo(@52);
            
        }];
        

        
        

    }
    
    
    
    
    return self;
    
}
-(void)itemViewClick:(SubjectDetailItemView *)itemView
{

    itemView.selected = YES;


}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.leftScrollBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.offset(0);
        
        make.top.offset(0);
        
        make.width.equalTo(@34);
        
        make.height.equalTo(@48);
        
    }];
    
    CGFloat itemWidth = (kScreenWidth-34*2)/5;
    
    for (int i = 0; i<self.dayBtnArray.count; i++) {
        
        DayBtnView *btn = self.dayBtnArray[i];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(itemWidth*i+34);
            make.top.equalTo(self.leftScrollBtn.mas_top);
            make.height.equalTo(self.leftScrollBtn.mas_height);
            make.width.equalTo(@(itemWidth));
        }];
        
        
        if (i == 2) {
            
            
            btn.bgImageView.hidden = NO;
            
            btn.topLabel.textColor = [UIColor whiteColor];
            
            btn.bottomLabel.textColor = [UIColor whiteColor];
            
            btn.topLabel.font = [UIFont systemFontOfSize:15];
            
            btn.bottomLabel.font = [UIFont systemFontOfSize:13];
            
            btn.backgroundColor = [UIColor whiteColor];
            
            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            
            btn.bgImageView.image = [UIImage imageNamed:@"学时陪练矩形-2"];
            
        }else
        {
            
            btn.bgImageView.hidden = YES;
            
        }
        
    }
    
    [self.rightSrcollBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftScrollBtn.mas_top);
        make.right.offset(0);
        make.width.equalTo(@34);
        make.height.equalTo(self.leftScrollBtn.mas_height);
    }];
    
    
    CGFloat itemViewW = (kScreenWidth-16*3)/2;
    CGFloat itemViewH = itemViewW*0.6;
    for (int i = 0; i<self.itemViewArray.count; i++) {
        SubjectDetailItemView *itemView = self.itemViewArray[i];
        int row = i/2;
        int col = i%2;
        itemView.frame = CGRectMake((itemViewW+16)*col+16, 30+48+50+(itemViewH+16)*row, itemViewW, itemViewH);
    }
    
    NSInteger totalRow = (self.itemViewArray.count-1)/2+1;
    
    self.cellHeight =20 +52 +totalRow*itemViewH +(totalRow-1)*16 +30+48+50 ;
    
    
    
    


}

-(void)selectBtnClick:(UIButton *)btn
{
    //UI操作
    self.currentSelectBtn.selected = NO;
    self.currentSelectBtn.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    self.currentSelectBtn.backgroundColor = [UIColor whiteColor];
    btn.selected = YES;
    btn.backgroundColor = [UIColor colorWithHexString:@"5cb6ff"];
    btn.layer.borderColor = [UIColor colorWithHexString:@"5cb6ff"].CGColor;
    self.currentSelectBtn = btn;
    
    //其他
    
    
    
    
    
    
    



}
-(void)dayBtnClick:(UITapGestureRecognizer  *)tap
{
    
    DayBtnView *btn = (DayBtnView *)tap.view;
    
    if ([btn.topLabel.text isEqualToString:@""]) {
        return;
    }
    
    if ([btn.bottomLabel.text isEqualToString:@"今天"]) {
        
        self.currentLeftDate = [GHDateTools dateByAddingDays:_currentLeftDate day:btn.tag-5000-2];
        
        for (int i = 0; i<self.dayBtnArray.count; i++) {
            
            
            
            DayBtnView *dayBtn = self.dayBtnArray[i];
            
            dayBtn.topLabel.text = [self getDateStringByIndex:i];
            
            NSDate *date1 = [GHDateTools dateByAddingDays:self.currentLeftDate day:i];
            
            dayBtn.bottomLabel.text = [self getWeekDayWithDate:date1];
            
            if (date1.isToday) {
                dayBtn.bottomLabel.text = @"今天";
            }
            if ([[NSDate compareDate:date1] isEqualToString:@"明天"]) {
                dayBtn.bottomLabel.text = @"明天";
            }
            
            if (i == 0 || i==1) {
                dayBtn.bottomLabel.text = @"";
                dayBtn.topLabel.text = @"";
            }
            
            
            
        }
        
        return;
    }
    if ([btn.bottomLabel.text isEqualToString:@"明天"]) {
        
        self.currentLeftDate = [GHDateTools dateByAddingDays:_currentLeftDate day:btn.tag-5000-2];
        
        for (int i = 0; i<self.dayBtnArray.count; i++) {
            
            
            
            DayBtnView *dayBtn = self.dayBtnArray[i];
            
            dayBtn.topLabel.text = [self getDateStringByIndex:i];
            
            NSDate *date1 = [GHDateTools dateByAddingDays:self.currentLeftDate day:i];
            
            dayBtn.bottomLabel.text = [self getWeekDayWithDate:date1];
            
            if (date1.isToday) {
                dayBtn.bottomLabel.text = @"今天";
            }
            if ([[NSDate compareDate:date1] isEqualToString:@"明天"]) {
                dayBtn.bottomLabel.text = @"明天";
            }
            
            if (i == 0) {
                dayBtn.bottomLabel.text = @"";
                dayBtn.topLabel.text = @"";
            }
            
        }
        
        return;
    }
    self.currentLeftDate = [GHDateTools dateByAddingDays:_currentLeftDate day:btn.tag-5000-2];
    
    for (int i = 0; i<self.dayBtnArray.count; i++) {
        
        DayBtnView *dayBtn = self.dayBtnArray[i];
        
        dayBtn.topLabel.text = [self getDateStringByIndex:i];
        
        NSDate *date1 = [GHDateTools dateByAddingDays:self.currentLeftDate day:i];
        
        dayBtn.bottomLabel.text = [self getWeekDayWithDate:date1];
        
        if (date1.isToday) {
            dayBtn.bottomLabel.text = @"今天";
        }
        if ([[NSDate compareDate:date1] isEqualToString:@"明天"]) {
            dayBtn.bottomLabel.text = @"明天";
        }
        
        
    }

}
-(void)leftBtnClick
{
    DayBtnView *dayBtn = self.dayBtnArray[0];
    
    if ([dayBtn.topLabel.text isEqualToString:@""]||dayBtn.topLabel.text == nil ) {
        return;
    }
    
    if ([GHDateTools isDateSameDay:self.currentLeftDate andTwoDate:self.startDate]) {
        return;
    }
    self.currentLeftDate = [GHDateTools dateByAddingDays:self.currentLeftDate day:-1];
    
    for (int i = 0; i<self.dayBtnArray.count; i++) {
        
        DayBtnView *dayBtn = self.dayBtnArray[i];
        
        dayBtn.topLabel.text = [self getDateStringByIndex:i];
        
        NSDate *date = [GHDateTools dateByAddingDays:self.currentLeftDate day:i];
        
        dayBtn.bottomLabel.text = [self getWeekDayWithDate:date];
        
        if (date.isToday) {
            dayBtn.bottomLabel.text = @"今天";
        }
        if ([[NSDate compareDate:date] isEqualToString:@"明天"]) {
            dayBtn.bottomLabel.text = @"明天";
        }
        
        
    }
    
    
    
    
}

-(void)rightBtnClick
{
    
    DayBtnView *btn = self.dayBtnArray[2];
    
    if ([btn.bottomLabel.text isEqualToString:@"今天"]) {
        
        self.currentLeftDate = [GHDateTools dateByAddingDays:self.currentLeftDate day:1];
        
        for (int i = 0; i<self.dayBtnArray.count; i++) {
            
            DayBtnView *dayBtn = self.dayBtnArray[i];
            
            dayBtn.topLabel.text = [self getDateStringByIndex:i];
            
            NSDate *date1 = [GHDateTools dateByAddingDays:self.currentLeftDate day:i];
            
            dayBtn.bottomLabel.text = [self getWeekDayWithDate:date1];
            
            if (date1.isToday) {
                dayBtn.bottomLabel.text = @"今天";
            }
            if ([[NSDate compareDate:date1] isEqualToString:@"明天"]) {
                dayBtn.bottomLabel.text = @"明天";
            }
            
            if (i == 0) {
                dayBtn.bottomLabel.text = @"";
                dayBtn.topLabel.text = @"";
            }
            
            
            
        }
        
        return;
    }
    
    self.currentLeftDate = [GHDateTools dateByAddingDays:self.currentLeftDate day:1];
    
    for (int i = 0; i<self.dayBtnArray.count; i++) {
        
        DayBtnView *dayBtn = self.dayBtnArray[i];
        
        dayBtn.topLabel.text = [self getDateStringByIndex:i];
        
        NSDate *date = [GHDateTools dateByAddingDays:self.currentLeftDate day:i];
        
        dayBtn.bottomLabel.text = [self getWeekDayWithDate:date];
        
        if (date.isToday) {
            dayBtn.bottomLabel.text = @"今天";
        }
        if ([[NSDate compareDate:date] isEqualToString:@"明天"]) {
            dayBtn.bottomLabel.text = @"明天";
        }
        
        
    }
    
    
}
-(NSString *)getWeekDayWithDate:(NSDate *)date
{
    if ([GHDateTools isMonday:date]) {
        return @"周一";
    }
    else if([GHDateTools isTuesday:date])
    {
        
        return @"周二";
        
    }
    else if([GHDateTools isWednesday:date])
    {
        
        return @"周三";
        
    }
    else if([GHDateTools isThursday:date])
    {
        
        return @"周四";
        
    }
    else if([GHDateTools isFriday:date])
    {
        
        return @"周五";
        
    }
    else if([GHDateTools isSaturday:date])
    {
        
        return @"周六";
        
    }
    else if([GHDateTools isSunday:date])
    {
        
        return @"周日";
        
    }
    
    return nil;
    
}
-(NSString *)getDateStringByIndex:(int)index
{
    
    NSDate *date = [GHDateTools dateByAddingDays:self.currentLeftDate day:index];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    
    df.dateFormat = @"MM-dd";
    
    return [df stringFromDate:date];
    
}

@end
