//
//  PartnerTrainingDetailCell2.m
//  学员端
//
//  Created by zuweizhong  on 16/7/15.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "PartnerTrainingDetailCell2.h"
#import "DayBtnView.h"
#import "OrderItemView.h"
#import "TeachModel.h"
#define kDayButttonCount 5

@interface PartnerTrainingDetailCell2 ()

@property(nonatomic,strong)NSDate * currentLeftDate;

@property(nonatomic,strong)NSDate * startDate;

@end

@implementation PartnerTrainingDetailCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        UIButton *leftScrollBtn = [[UIButton alloc]init];
        
        self.leftScrollBtn = leftScrollBtn;
        
        self.leftScrollBtn.backgroundColor = [UIColor colorWithHexString:@"#485358"];
        
        [self.leftScrollBtn setImage:[UIImage imageNamed:@"iconfont-left"] forState:UIControlStateNormal];
        
        [self.leftScrollBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:leftScrollBtn];
        
        self.dayBtnArray = [NSMutableArray array];
        
        self.currentLeftDate = [NSDate date];
        
        self.startDate = [NSDate date];

        for (int i = 0; i<kDayButttonCount; i++) {
            
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
        
        
        
        UILabel *selectedLabel = [[UILabel alloc]init];
        
        selectedLabel.attributedText = [self getSelectedLabelAttributeTextWithNumber:1];
        
        self.selectedLabel = selectedLabel;
        
        self.selectedLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.selectedLabel];
        
        
        _selectedLabel.attributedText = [self getSelectedLabelAttributeTextWithNumber:0];

 
    }
    return self;

}
-(void)setCurrentSelectDate:(NSDate *)currentSelectDate
{
    _currentLeftDate = currentSelectDate;
    
    self.currentLeftDate = [GHDateTools dateByAddingDays:currentSelectDate day:-2];

    for (int i = 0; i<self.dayBtnArray.count; i++) {
        
        DayBtnView *dayBtn = self.dayBtnArray[i];
        
        dayBtn.topLabel.text = [self getDateStringByIndex:i];
        
        NSDate *date = [GHDateTools dateByAddingDays:self.currentLeftDate day:i];
        
        dayBtn.bottomLabel.text = [self getWeekDayWithDate:date];
        
        if ([date compare:_startDate] == NSOrderedAscending)
        {
            dayBtn.bottomLabel.text = @"";
            dayBtn.topLabel.text = @"";
        }
        if (date.isToday) {
            dayBtn.bottomLabel.text = @"今天";
            dayBtn.topLabel.text = [self getDateStringByIndex:i];

        }
        if ([[NSDate compareDate:date] isEqualToString:@"明天"]) {
            dayBtn.bottomLabel.text = @"明天";
            dayBtn.topLabel.text = [self getDateStringByIndex:i];
        }
        
    }


}
-(void)setOrderModelArr:(NSMutableArray *)orderModelArr
{
    _orderModelArr = orderModelArr;
    
    [self.orderViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.orderViewArray = [NSMutableArray array];
    
    for (int i=0; i<_orderModelArr.count; i++) {
        
        OrderItemView *orderItemView = [[[NSBundle mainBundle]loadNibNamed:@"OrderItemView" owner:nil options:nil]lastObject];
        
        orderItemView.tag = 1990+i;
        
        TeachModel *model = _orderModelArr[i];
        
        orderItemView.teachModel = model;
        
        [orderItemView addTarget:self action:@selector(orderItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:orderItemView];
        
        [self.orderViewArray addObject:orderItemView];
        
    }
    


}
-(void)setHasSelectedTimeModelArray:(NSMutableArray *)hasSelectedTimeModelArray
{

    _hasSelectedTimeModelArray = hasSelectedTimeModelArray;
    
    _selectedLabel.attributedText = [self getSelectedLabelAttributeTextWithNumber:(int)hasSelectedTimeModelArray.count];


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
    
    CGFloat itemWidth = (kScreenWidth-34*2)/kDayButttonCount;
    
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
    
    CGFloat itemViewWidth = (kScreenWidth-24-16)/3;
    
    CGFloat itemViewHeight =  itemViewWidth*0.68;
    
    
    for (int i = 0; i<self.orderViewArray.count; i++) {
        OrderItemView *itemView = self.orderViewArray[i];
        
        int row = i/3;
        
        int col = i%3;

        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset((itemViewWidth+8)*col+12);
            make.top.equalTo(self.leftScrollBtn.mas_bottom).offset(24+(15+itemViewHeight)*row);
            make.height.equalTo(@(itemViewHeight));
            make.width.equalTo(@(itemViewWidth));
        }];
        
    }
    
    
    [self.selectedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (self.orderViewArray.count>0) {
            make.top.equalTo(((OrderItemView *)self.orderViewArray.lastObject).mas_bottom);
        }else
        {
            make.top.equalTo(self.leftScrollBtn.mas_bottom);
        }
        make.left.offset(0);
        
        make.right.offset(0);
        
        make.height.equalTo(@55);
        
    }];
    NSInteger totalRow = 0;
    if (self.orderViewArray.count != 0) {
        
        totalRow = (self.orderViewArray.count-1)/3+1;
        self.cellHeight = 48 +24 +totalRow*itemViewHeight +(totalRow-1)*15 +55+ 10;

    }
    else
    {
        self.cellHeight = 48 +24 + 30;
    
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

-(void)orderItemClick:(OrderItemView *)itemView
{
    itemView.selected = !itemView.selected;
    
    if (itemView.selected) {
        [self.hasSelectedTimeModelArray addObject:itemView.teachModel];
        itemView.teachModel.isSelected = YES;
    }
    else
    {
        [self.hasSelectedTimeModelArray removeObject:itemView.teachModel];
        itemView.teachModel.isSelected = NO;

    }
    if ([self.delegate respondsToSelector:@selector(partnerTrainingDetailCell2:didGetselectedTimeModelArray:)]) {
        [self.delegate partnerTrainingDetailCell2:self didGetselectedTimeModelArray:self.hasSelectedTimeModelArray];
    }

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
        NSDate *currentDate = [GHDateTools dateByAddingDays:self.currentLeftDate day:2];
        
        long long time = currentDate.timeIntervalSince1970;
        
        if ([self.delegate respondsToSelector:@selector(partnerTrainingDetailCell2:didSelectDayViewWithTime:)]) {
        
            [self.delegate partnerTrainingDetailCell2:self didSelectDayViewWithTime:time];
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
        
        NSDate *currentDate = [GHDateTools dateByAddingDays:self.currentLeftDate day:2];
        
        long long time = currentDate.timeIntervalSince1970;
        
        if ([self.delegate respondsToSelector:@selector(partnerTrainingDetailCell2:didSelectDayViewWithTime:)]) {
            
            [self.delegate partnerTrainingDetailCell2:self didSelectDayViewWithTime:time];
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
    
    NSDate *currentDate = [GHDateTools dateByAddingDays:self.currentLeftDate day:2];
    
    long long time = currentDate.timeIntervalSince1970;
    
    if ([self.delegate respondsToSelector:@selector(partnerTrainingDetailCell2:didSelectDayViewWithTime:)]) {
        
        [self.delegate partnerTrainingDetailCell2:self didSelectDayViewWithTime:time];
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
    
    NSDate *currentDate = [GHDateTools dateByAddingDays:self.currentLeftDate day:2];
    
    long long time = currentDate.timeIntervalSince1970;
    
    if ([self.delegate respondsToSelector:@selector(partnerTrainingDetailCell2:didSelectDayViewWithTime:)]) {
        
        [self.delegate partnerTrainingDetailCell2:self didSelectDayViewWithTime:time];
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
        NSDate *currentDate = [GHDateTools dateByAddingDays:self.currentLeftDate day:2];
        
        long long time = currentDate.timeIntervalSince1970;
        
        if ([self.delegate respondsToSelector:@selector(partnerTrainingDetailCell2:didSelectDayViewWithTime:)]) {
            
            [self.delegate partnerTrainingDetailCell2:self didSelectDayViewWithTime:time];
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
    
    NSDate *currentDate = [GHDateTools dateByAddingDays:self.currentLeftDate day:2];
    
    long long time = currentDate.timeIntervalSince1970;
    
    if ([self.delegate respondsToSelector:@selector(partnerTrainingDetailCell2:didSelectDayViewWithTime:)]) {
        
        [self.delegate partnerTrainingDetailCell2:self didSelectDayViewWithTime:time];
    }
    
    
}
-(NSMutableAttributedString *)getSelectedLabelAttributeTextWithNumber:(int)num
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"已选择"];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(0, str.length)];
    
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, str.length)];
    
    
    NSMutableAttributedString *number = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d",num]];
    
    [number addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#5cb6ff"] range:NSMakeRange(0, number.length)];
    
    [number addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, number.length)];
    
    
    [str appendAttributedString:number];
    
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:@"个时段"];
    
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(0, str2.length)];
    
    [str2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, str2.length)];
    
    [str appendAttributedString:str2];
    
    return str;
    
    
}


@end
