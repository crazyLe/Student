//
//  PartnerTrainingDetailCell2.h
//  学员端
//
//  Created by zuweizhong  on 16/7/15.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PartnerTrainingDetailCell2;

@protocol PartnerTrainingDetailCell2Delegate <NSObject>

-(void)partnerTrainingDetailCell2:(PartnerTrainingDetailCell2 *)cell didSelectDayViewWithTime:(long long)time;
-(void)partnerTrainingDetailCell2:(PartnerTrainingDetailCell2 *)cell didGetselectedTimeModelArray:(NSMutableArray *)timeModelArray;

@end

@interface PartnerTrainingDetailCell2 : UITableViewCell

@property(nonatomic,strong)UIButton * leftScrollBtn;

@property(nonatomic,strong)UIButton * rightSrcollBtn;

@property(nonatomic,strong)NSMutableArray * dayBtnArray;

@property(nonatomic,strong)NSMutableArray * orderViewArray;

@property(nonatomic,strong)UILabel * selectedLabel;

@property (nonatomic, assign)CGFloat cellHeight;

@property(nonatomic,weak)id<PartnerTrainingDetailCell2Delegate> delegate;

@property(nonatomic,strong)NSMutableArray * orderModelArr;

@property(nonatomic,strong)NSDate * currentSelectDate;

@property(nonatomic,strong)NSMutableArray * hasSelectedTimeModelArray;

-(NSMutableAttributedString *)getSelectedLabelAttributeTextWithNumber:(int)num;
@end
