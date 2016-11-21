//
//  MyOderExtraBottomCell.h
//  学员端
//
//  Created by zuweizhong  on 16/8/18.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyOderExtraBottomCellDelegete <NSObject>

@optional
- (void)clickPersonFourthCellPayBtn:(NSInteger)markTag;
- (void)personFourthCellsecondField;

@end

@interface MyOderExtraBottomCell : UITableViewCell

@property (nonatomic, strong) UIButton* payFirstBtn;
@property (nonatomic, strong) UIButton * paySecondBtn;

//@property (nonatomic, strong) UITextView * secondTextView;
@property (nonatomic, strong) UITextField * secondTextView;

@property(nonatomic,strong)UILabel * firstLabel;


@property(nonatomic,strong)UILabel * thirdLabel;

@property(nonatomic,strong)UILabel * fourthLabel;

-(NSMutableAttributedString *)getAttrStringWithZhuanDouNum:(NSString *)num;

@property (nonatomic, strong) UILabel * warningLabel;

@property (nonatomic,assign) id<MyOderExtraBottomCellDelegete>delegate;

@end
