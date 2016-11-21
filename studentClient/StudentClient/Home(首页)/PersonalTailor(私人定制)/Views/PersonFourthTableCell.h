//
//  PersonFourthTableCell.h
//  学员端
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonFourthTableCellDelegete <NSObject>

@optional
- (void)clickPersonFourthCellPayBtn:(NSInteger)markTag;
- (void)personFourthCellsecondField;

@end

@interface PersonFourthTableCell : UITableViewCell

@property (nonatomic, strong) UIButton *payFirstBtn;
@property (nonatomic, strong) UIButton * paySecondBtn;

//@property (nonatomic, strong) UITextView *secondTextView;
@property (nonatomic,strong) UITextField * secondTextView;

@property(nonatomic,strong)UILabel *firstLabel;

@property(nonatomic,strong)UILabel *thirdLabel;

@property(nonatomic,strong)UILabel *fourthLabel;

@property (nonatomic, strong) UILabel *warningLabel;

@property (nonatomic,assign) id<PersonFourthTableCellDelegete>delegate;

-(NSMutableAttributedString *)getAttrStringWithZhuanDouNum:(NSString *)num;
@end
