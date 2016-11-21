//
//  CurrentRepaymentCell.h
//  学员端
//
//  Created by gaobin on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StagingBillModel.h"

@protocol CurrentRepaymentCellDelegate <NSObject>

- (void)pressCurrentCellrepaymentBtn;

@end

@interface CurrentRepaymentCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhuanDouWidth;

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *currentRepayLab;
@property (weak, nonatomic) IBOutlet UILabel *englishLab;
@property (weak, nonatomic) IBOutlet UILabel *studyExpensesLab;
@property (weak, nonatomic) IBOutlet UILabel *studyExpensesLab1;
@property (weak, nonatomic) IBOutlet UILabel *totalInterestLab;
@property (weak, nonatomic) IBOutlet UILabel *totalInterestLab1;
@property (weak, nonatomic) IBOutlet UILabel *monthSupplyLab;
@property (weak, nonatomic) IBOutlet UILabel *monthSupplyLab1;
@property (weak, nonatomic) IBOutlet UILabel *timeLimitLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLimitLab1;
@property (weak, nonatomic) IBOutlet UILabel *alreadyRepayLab;
@property (weak, nonatomic) IBOutlet UILabel *alreadyRepayLab1;
@property (weak, nonatomic) IBOutlet UILabel *repayDayLab;
@property (weak, nonatomic) IBOutlet UILabel *repayDayLab1;
@property (weak, nonatomic) IBOutlet UILabel *currentMonthShouldLab;
@property (weak, nonatomic) IBOutlet UILabel *earnBeanLab;
@property (weak, nonatomic) IBOutlet UITextView *numberBeanTextView;
@property (weak, nonatomic) IBOutlet UILabel *offsetMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *actrulRepayLab;
@property (weak, nonatomic) IBOutlet UIButton *repaymentBtn;

@property (nonatomic, strong) id<CurrentRepaymentCellDelegate>delegate;

@property (nonatomic, strong) StagingBillModel * billModel;

-(NSMutableAttributedString *)getAttrStringWithZhuanDouNum:(NSString *)num;
@end
